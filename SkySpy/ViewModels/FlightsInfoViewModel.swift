//
//  FlightInfoViewModel.swift
//  SkySpy
//
//  Created by SofiaLeong on 02/05/2025.
//

import SwiftUI
import Combine

class FlightsInfoViewModel: ObservableObject, MapButtonViewModelRepresentable {
    var mapButtonTitle: String = "Map"

    func mapButtonPressed() {
        showMap = true
    }


    var flights: [SingleFlightInfo]
    let airline: String

    @Published var filters: FiltersViewModel
    @Published var showFilters = false
    @Published var showMap = false
    private var cancellables = Set<AnyCancellable>()


    init(model: [SingleFlightInfo]) {
        self.flights = model
        self.airline = flights.first?.airlineName ?? "Flights"
        self.filters = FiltersViewModel(
            allArrivalAirports: Set(flights.compactMap { $0.arrivalAirport }),
            allDepartureAirports: Set(flights.compactMap { $0.departureAirport })
        )

        observeFilters()
    }

    func formattedTime(_ dateString: String, timeZone: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        guard let date = isoFormatter.date(from: dateString) else {
            return "Invalid date"
        }

        let displayFormatter = DateFormatter()
        displayFormatter.timeStyle = .short
        displayFormatter.dateStyle = .none
        displayFormatter.timeZone = TimeZone(identifier: timeZone)

        return displayFormatter.string(from: date)
    }

    private func observeFilters() {
        filters.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

}

//MARK: - Filters logic
extension FlightsInfoViewModel {
    var filteredFlights: [SingleFlightInfo] {
        flights.filter { flight in
            // Status Filter
            if !filters.selectedStatuses.isEmpty,
               let status = flight.status?.lowercased(),
               !filters.selectedStatuses.contains(FlightStatus(rawValue: status) ?? .scheduled) {
                return false
            }

            // Altitude Filter
            if !filters.selectedAltitudesAbove.isEmpty {
                let altitude = flight.altitude ?? 0
                let satisfies = filters.selectedAltitudesAbove.contains {
                    switch $0 {
                    case .low: return altitude < 1000
                    case .medium: return altitude >= 1000 && altitude <= 5000
                    case .high: return altitude > 5000 && altitude <= 10000
                    case .veryHigh: return altitude > 10000
                    }
                }
                if !satisfies { return false }
            }

            // Delay Filter
            if !filters.selectedDelays.isEmpty {
                let delay = flight.delayInMinutes ?? 0
                let satisfies = filters.selectedDelays.contains {
                    switch $0 {
                    case .none: return delay == 0
                    case .lessThan30: return delay < 30
                    case .lessThan60: return delay < 60
                    case .moreThan60: return delay > 60
                    case .moreThan120: return delay > 120
                    }
                }
                if !satisfies { return false }
            }

            // Arrival Airport Filter
            if !filters.selectedArrivalAirports.isEmpty {
                guard let airport = flight.arrivalAirport, filters.selectedArrivalAirports.contains(airport) else {
                    return false
                }
            }

            // Departure Airport Filter
            if !filters.selectedDepartureAirports.isEmpty {
                guard let airport = flight.departureAirport, filters.selectedDepartureAirports.contains(airport) else {
                    return false
                }
            }

            return true
        }
    }
}

enum FlightStatus: String, CaseIterable {
    case scheduled, active, landed, cancelled, incident, diverted
}

enum DelayCategory: String, CaseIterable {
    case none = "No Delay"
    case lessThan30 = "< 30 min"
    case lessThan60 = "< 1 hr"
    case moreThan60 = "> 1 hr"
    case moreThan120 = "> 2 hr"

    func contains(_ delay: Int?) -> Bool {
        guard let delay = delay else {
            return self == .none
        }

        switch self {
        case .none:
            return delay == 0
        case .lessThan30:
            return delay > 0 && delay < 30
        case .lessThan60:
            return delay >= 30 && delay <= 60
        case .moreThan60:
            return delay > 60
        case .moreThan120:
            return delay > 120
        }
    }
}

enum AltitudeCategory: String, CaseIterable {
    case low = "< 1,000m"
    case medium = "1,000m – 5,000m"
    case high = "5,000m - 10,000m"
    case veryHigh = "> 10,000m"

    func contains(_ altitude: Double?) -> Bool {
        guard let altitude = altitude else { return false }

        switch self {
        case .low:
            return altitude < 1000
        case .medium:
            return altitude >= 1000 && altitude <= 5000
        case .high:
            return altitude > 5000 && altitude <= 10000
        case .veryHigh:
            return altitude > 10000
        }
    }
}
