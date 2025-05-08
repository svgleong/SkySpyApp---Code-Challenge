//
//  AirlinesView.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import SwiftUI

struct AirlinesView: View {
    
    @ObservedObject private var viewModel: AirlinesViewModel
    
    init(viewModel: AirlinesViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        showFavoritesButton
        
        ScrollView {
            VStack(alignment: .leading) {
                ForEach($viewModel.airlines.filter { airline in !viewModel.showFavoritesOnly || airline.wrappedValue.isFavorite}, id: \.id) { $airline in
                    HStack() {
                        
                        favoriteButton(airline: $airline)
                        airlineRow(airline: airline)
                    }
                    
                    Divider()
                }
            }
            .scrollContentBackground(.hidden)
            .font(.system(size: 16))
            .padding(.horizontal, 16)
            
        }
    }
    
    private var showFavoritesButton: some View {
        Button(action: {
            viewModel.showFavoritesOnly.toggle()
        }) {
            Label(viewModel.showFavoritesOnly ? "Show All" : "Your Favorites",
                  systemImage: viewModel.showFavoritesOnly ? "list.bullet" : "heart.fill"
            )
            .font(.headline)
            .padding(4)
            .background(.white)
            .cornerRadius(8)
        }
        .padding()
        .foregroundStyle(.gray)
    }
    
    private func favoriteButton(airline: Binding<SingleAirlineInfo>) -> some View {
        Button {
            viewModel.favoriteAction(airline: airline.wrappedValue)
        } label: {
            airline.wrappedValue.isFavorite
            ? Image(systemName: "heart.fill")
            : Image(systemName: "heart")
        }
        .padding(.trailing, 12)
        .foregroundStyle(.white)
        .bold()
    }
    
    private func airlineRow(airline: SingleAirlineInfo) -> some View {
        NavigationLink(
            destination: FlightsView(viewModel: viewModel.getFlightsViewModel(airlineName: airline.airlineName))
        ) {
            HStack {
                Text(airline.airlineName)
                    .foregroundStyle(.black)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray)
                    .bold()
            }
        }
    }
}

