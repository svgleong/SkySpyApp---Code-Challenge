//
//  SkySpyViewModel.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import Foundation
import CoreData

class SkySpyViewModel: AviationStackContentLoadable {
    
    let service: AviationStackService
    
    var airlines: [SingleAirlineInfo] = []
    @Published var filteredAirlines: [SingleAirlineInfo] = []
    @Published var state: LoadableState = .loading
    @Published var isCached = false
    
    var searchText = ""
    
    init(service: AviationStackService) {
        self.service = service
    }
    
    var airlinesViewModel: AirlinesViewModel {
        AirlinesViewModel(
            model: filteredAirlines,
            dependencies: .init(
                service: service,
                saveFavorites: FavoriteAirlineRepository()
            ),
            onFavoriteToggled: { [weak self] updatedAirline in
                guard let self else { return }
                
                // Find and update the airline in both arrays
                if let index = self.airlines.firstIndex(where: { $0.airlineName == updatedAirline.airlineName }) {
                    self.airlines[index] = updatedAirline
                }
                
                if let index = self.filteredAirlines.firstIndex(where: { $0.airlineName == updatedAirline.airlineName }) {
                    self.filteredAirlines[index] = updatedAirline
                }
            }
        )
    }
    
    @MainActor
    func filterAirlines() {
        if searchText.isEmpty {
            filteredAirlines = airlines
            return
        }

        filteredAirlines = airlines.filter {
            $0.airlineName.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func clearSearch() {
        searchText = ""
        filteredAirlines = airlines
    }
}

//MARK: - fetch airline data
extension SkySpyViewModel {
    @MainActor
    func fetchData() async {
        //        await fetchData(searchText)
        await fetchData("")
    }
    
    func fetchData(_ searchField: String) async {
        let input = searchField.isEmpty ? nil : searchField
        
        do {
            let model = try await service.fetchAirlineData(for: input)
            await handleSuccess(model: model)
        } catch {
            let cached = loadCachedData()
            if !cached.isEmpty {
                await handleCachedFailure(model: cached)
            }
            else {
                await handleFailure()
            }
        }
    }
    
    func loadCachedData() -> [SingleAirlineInfo] {
        let moc = DataController.shared.container.viewContext
        let request: NSFetchRequest<FavoriteAirline> = FavoriteAirline.fetchRequest()

        do {
            let entities = try moc.fetch(request)
            return entities.compactMap { SingleAirlineInfo(from: $0)}
        } catch {
            print("Failed to fetch cached airlines data: \(error.localizedDescription)")
            return []
        }
    }
}

//MARK: - handle app states
extension SkySpyViewModel {
    @MainActor
    func handleSuccess(model: AirlineDataAPI) {
        let cachedAirlines = loadCachedData()
        var fetchedAirlines = model.data.compactMap { SingleAirlineInfo(from: $0) }
        
        for cachedAirline in cachedAirlines {
            if let i = fetchedAirlines.firstIndex(where: { $0.airlineName == cachedAirline.airlineName }) {
                fetchedAirlines[i] = cachedAirline
            } else {
                fetchedAirlines.append(cachedAirline)
            }
        }
        
        airlines = fetchedAirlines
        filteredAirlines = fetchedAirlines
        state = .success
        isCached = false
    }
    
    @MainActor
    func handleCachedFailure(model: [SingleAirlineInfo]) {
        airlines = model
        filteredAirlines = model
        state = .cachedFailure
        isCached = true
    }
    
    func reloadAction() {
        searchText = ""
        Task {
            await fetchData()
        }
    }
}
