//
//  FiltersView.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//

import SwiftUI

struct FiltersView: View {
    @ObservedObject private var viewModel: FiltersViewModel
    
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            flightStatus
            
            delay
            
            altitude
            
            departureAirports
            
            arrivalAirports

            reset
        }
        .padding(.horizontal, 12)
    }
    
    private var flightStatus: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Flight Status")
                .padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(FlightStatus.allCases, id: \.self) { status in
                        SingleFilterButton(
                            title: status.rawValue.capitalized,
                            isSelected: viewModel.selectedStatuses.contains(status),
                            color: viewModel.statusColor(for: status.rawValue)
                        ) {
                            viewModel.handleFlightStatusTap(status)
                        }
                    }
                }
                .padding(2)
            }
        }
    }
    
    private var delay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Delay")
                .padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(DelayCategory.allCases, id: \.self) { delay in
                        SingleFilterButton(
                            title: delay.rawValue,
                            isSelected: viewModel.selectedDelays.contains(delay),
                            color: .black
                        ) {
                            viewModel.handleDelayTap(delay)
                        }
                    }
                }
                .padding(2)
            }
        }
    }
    
    private var altitude: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Altitude")
                .padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(AltitudeCategory.allCases, id: \.self) { altitude in
                        SingleFilterButton(
                            title: altitude.rawValue,
                            isSelected: viewModel.selectedAltitudesAbove.contains(altitude),
                            color: .black
                        ) {
                            viewModel.handleAltitudeTap(altitude)
                        }
                    }
                }
                .padding(2)
            }
        }
    }
    
    private var arrivalAirports: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Arrival Airports")
                .padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(viewModel.allArrivalAirports).sorted(), id: \.self) { airport in
                        SingleFilterButton(
                            title: airport,
                            isSelected: viewModel.selectedArrivalAirports.contains(airport),
                            color: .black
                        ) {
                            viewModel.handleArrivalAirportsTap(airport)
                        }
                    }
                }
                .padding(2)
            }
        }
    }
    
    private var departureAirports: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Departure Airports")
                .padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(viewModel.allDepartureAirports).sorted(), id: \.self) { airport in
                        SingleFilterButton(
                            title: airport,
                            isSelected: viewModel.selectedDepartureAirports.contains(airport),
                            color: .black
                        ) {
                            viewModel.handleDepartureAirportsTap(airport)
                        }
                    }
                }
                .padding(2)
            }
        }
    }
    
    private var reset: some View {
        Button("Reset") {
            viewModel.resetFilters()
        }
        .padding(6)
        .background(Color.gray.opacity(0.3))
        .cornerRadius(10)
    }
}
