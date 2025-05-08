//
//  FlightInfoView.swift
//  SkySpy
//
//  Created by SofiaLeong on 02/05/2025.
//

import SwiftUI

struct FlightsInfoView: View {
    @ObservedObject private var viewModel: FlightsInfoViewModel
    
    init(viewModel: FlightsInfoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            if viewModel.flights.isEmpty {
                Text("No results found")
            } else {
                ZStack(alignment: .bottom) {
                    VStack {
                        filtersButton

                        flightsScrollView
                    }
                    
                    MapButtonView(viewModel: viewModel)
                }
            }
        }
        .background(.clear)
        .navigationTitle(viewModel.airline)
        .scrollContentBackground(.hidden)
        .fullScreenCover(isPresented: $viewModel.showMap) {
            MapFlightsView(viewModel: viewModel)
        }
    }
    
    private var filtersButton: some View {
        Group {
            Button(action: {
                viewModel.showFilters.toggle()
            }) {
                Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                    .font(.headline)
                    .padding(4)
                    .background(.white)
                    .cornerRadius(8)
            }
            .foregroundStyle(.gray)
            
            if viewModel.showFilters {
                FiltersView(viewModel: viewModel.filters)
            }
        }
    }
    
    private var flightsScrollView: some View {
        ScrollView {
            VStack(spacing: 8) {
                if viewModel.filteredFlights.isEmpty {
                    Text("No results found")
                }
                
                ForEach(viewModel.filteredFlights, id: \.id) { flight in
                    flightInfo(for: flight)
                        .listRowBackground(Color.clear)
                }
            }
            .padding(16)
            .background(.clear)
        }
        .scrollContentBackground(.hidden)
    }
    
    private func flightInfo(for flight: SingleFlightInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {

            flightNumberAndStatus(for: flight)
            
            departureAndArrival(for: flight)
            
            if let terminal = flight.terminal, let gate = flight.gate {
                Text("Terminal: \(terminal), Gate: \(gate)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            if let delay = flight.delayInMinutes, delay > 0 {
                Text("⚠️ Delayed by \(delay) minutes")
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
            
            if let reg = flight.aircraftRegistration {
                Text("Aircraft: \(reg)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            if flight.isLive, let altitude = flight.altitude {
                Text("✈️ Altitude: \(Int(altitude)) m")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .background(Color.white.opacity(0.6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.vertical, 8)
    }
    
    private func flightNumberAndStatus(for flight: SingleFlightInfo) -> some View {
        HStack {
            Text("\(flight.airlineIata) \(flight.flightNumber)")
                .font(.headline)
            if flight.isLive {
                Text("LIVE")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            if let status = flight.status {
                Text(status.capitalized)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(viewModel.filters.statusColor(for: status).opacity(0.2))
                    .foregroundStyle(viewModel.filters.statusColor(for: status))
                    .cornerRadius(8)
            }
                        
        }
    }
    
    private func departureAndArrival(for flight: SingleFlightInfo) -> some View{
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Departure:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(alignment: .bottom, spacing: 0) {
                    if let airport = flight.departureAirport {
                        Text("\(airport)")
                    }
                    Text(" at \(viewModel.formattedTime(flight.departureTime!, timeZone: flight.departureTimezone))")
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("Arrival:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                HStack(alignment: .bottom, spacing: 0) {
                    if let airport = flight.arrivalAirport {
                        Text("\(airport)")
                    }
                    Text(" at \(viewModel.formattedTime(flight.arrivalTime, timeZone: flight.arrivalTimezone))")
                }
            }
        }
    }
}

#Preview {
    var client: APIClient { APIClient(session: URLSession.shared) }
    var service: AviationStackService { AviationStackService(client: client) }

    let flight = SingleFlightInfo.sample()
    
    var viewModel: FlightsInfoViewModel { FlightsInfoViewModel(model: [
        flight, flight
    ]) }
    return FlightsInfoView(viewModel: viewModel)
}

