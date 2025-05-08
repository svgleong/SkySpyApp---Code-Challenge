//
//  FiltersViewModel.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//

import SwiftUI

class FiltersViewModel: ObservableObject {
    @Published var selectedStatuses: Set<FlightStatus> = []
    @Published var selectedDelays: Set<DelayCategory> = []
    @Published var selectedArrivalAirports: Set<String> = []
    @Published var selectedDepartureAirports: Set<String> = []
    @Published var selectedAltitudesAbove:Set<AltitudeCategory> = []
    
    var allArrivalAirports: Set<String>
    var allDepartureAirports: Set<String>
    
    init(allArrivalAirports: Set<String>, allDepartureAirports: Set<String>) {
        self.allArrivalAirports = allArrivalAirports
        self.allDepartureAirports = allDepartureAirports
    }
    
    func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "scheduled": return .blue
        case "active": return .green
        case "landed": return .gray
        case "cancelled": return .red
        case "incident": return .orange
        case "diverted": return .purple
        default: return .black
        }
    }
    
    func resetFilters() {
        selectedStatuses.removeAll()
        selectedDelays.removeAll()
        selectedAltitudesAbove.removeAll()
        selectedArrivalAirports.removeAll()
        selectedDepartureAirports.removeAll()
    }
    
    func handleFlightStatusTap(_ status: FlightStatus) {
        print("Before toggle: \(selectedStatuses)")
        toggle(status, in: &selectedStatuses)
        print("After toggle: \(selectedStatuses)")
    }

    func handleDelayTap(_ delay: DelayCategory) {
        toggle(delay, in: &selectedDelays)
    }

    func handleAltitudeTap(_ altitude: AltitudeCategory) {
        toggle(altitude, in: &selectedAltitudesAbove)
    }

    func handleArrivalAirportsTap(_ airport: String) {
        toggle(airport, in: &selectedArrivalAirports)
    }

    func handleDepartureAirportsTap(_ airport: String) {
        toggle(airport, in: &selectedDepartureAirports)
    }
}

extension FiltersViewModel {
    private func toggle<T: Hashable>(_ item: T, in set: inout Set<T>) {
        if set.contains(item) {
            set.remove(item)
        } else {
            set.insert(item)
        }
        print("After toggle 1: \(selectedStatuses)")
    }
}
