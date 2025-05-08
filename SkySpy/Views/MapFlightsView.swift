//
//  MapFlightsView.swift
//  SkySpy
//
//  Created by SofiaLeong on 06/05/2025.
//

import SwiftUI
import MapKit

struct MapFlightsView: View {

    @ObservedObject private var viewModel: FlightsInfoViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: FlightsInfoViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .top) {
            mapView
            
            filtersButton
                .padding(.top, 20)
            
//            if viewModel.showFilters {
//                FiltersView(viewModel: viewModel.filters)
//            }
        }
    }
    
    private var mapView: some View {
        Map {
            ForEach(viewModel.filteredFlights) { item in
                if let latitude = item.latitude, let longitude = item.longitude {
                    Annotation("", coordinate: CLLocationCoordinate2D(
                        latitude: latitude,
                        longitude: longitude)
                    ) {
                        Text("✈️")
                            .font(.system(size: 30))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private var filtersButton: some View {
        HStack {
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "x.circle")
                    .foregroundStyle(.white)
                    .bold()
                    .font(.system(size: 30))
            }
            .padding(.leading, 12)
            
            Spacer()
//
//            
//            HStack {
//                Spacer()
//                
//                Button(action: {
//                    viewModel.showFilters.toggle()
//                }) {
//                    Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
//                        .font(.headline)
//                        .padding(4)
//                        .background(.white)
//                        .cornerRadius(8)
//                }
//                .foregroundStyle(.gray)
//                
//                Spacer()
//            }
        }
    }
}
