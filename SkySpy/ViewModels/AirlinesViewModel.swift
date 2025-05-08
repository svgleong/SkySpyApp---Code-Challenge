//
//  AirlinesViewModel.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import Foundation

class AirlinesViewModel: ObservableObject {
    
    @Published var airlines: [SingleAirlineInfo]
    @Published var showFavoritesOnly = false
    let dependencies: Dependencies
    
    let onFavoriteToggled: (SingleAirlineInfo) -> Void
    
    struct Dependencies {
        let service: any AviationStackServiceProtocol
        let saveFavorites: any FavoriteAirlineSavable
    }
    
    init(model: [SingleAirlineInfo], dependencies: Dependencies,  onFavoriteToggled: @escaping (SingleAirlineInfo) -> Void) {
        self.airlines = model
        self.dependencies = dependencies
        self.onFavoriteToggled = onFavoriteToggled
    }
    
    func getFlightsViewModel(airlineName: String) -> FlightsViewModel {
        FlightsViewModel(airline: airlineName, dependencies: .init(service: dependencies.service, saveFlights: FlightDataRepository()))
    }

    @MainActor
    func favoriteAction(airline: SingleAirlineInfo) {
        var updatedAirline = airline
        updatedAirline.isFavorite.toggle()
        
        if updatedAirline.isFavorite {
            dependencies.saveFavorites.saveFavoriteAirline(data: updatedAirline)
        } else {
            dependencies.saveFavorites.deleteFavoriteAirline(data: updatedAirline)
        }
        
        // Update the airline in the local array
        if let index = airlines.firstIndex(where: { $0.airlineName == airline.airlineName }) {
            airlines[index] = updatedAirline
        }
        
        // Notify SkySpyViewModel
        onFavoriteToggled(updatedAirline)
    }

}
