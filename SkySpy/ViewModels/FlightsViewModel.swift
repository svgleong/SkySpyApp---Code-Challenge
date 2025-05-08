//
//  FlightsViewModel.swift
//  SkySpy
//
//  Created by SofiaLeong on 02/05/2025.
//

import Foundation
import CoreData

class FlightsViewModel: AviationStackContentLoadable {
    
    struct Dependencies {
        let service: any AviationStackServiceProtocol
        let saveFlights: any FlightDataSavable
    }
    
    let dependencies: Dependencies
    
    let airline: String
    @Published var state: LoadableState = .loading
    var flights: [SingleFlightInfo]

    var isCached = false
    
    init(airline: String, dependencies: Dependencies) {
        self.dependencies = dependencies
        self.airline = airline
        self.flights = []
    }
    
    lazy var flightsInfoViewModel = {
        FlightsInfoViewModel(model: flights)
    }()
}

//MARK: - fetch flight data
extension FlightsViewModel {
    @MainActor
    func fetchData() async {
        do {
            let model = try await dependencies.service.fetchFlightData(for: airline)
            handleSuccess(model: model)
        } catch {
            let cached = loadCachedData()
            if !cached.isEmpty {
                handleCachedFailure(model: cached)
            }
            else {
                handleFailure()
            }
        }
    }
    
    func loadCachedData() -> [SingleFlightInfo] {
        let moc = DataController.shared.container.viewContext
        let request: NSFetchRequest<FlightInfoEntity> = FlightInfoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "airlineName =[c] %@", airline)

        do {
            let entities = try moc.fetch(request)
            return entities.compactMap { SingleFlightInfo(from: $0)}
        } catch {
            print("Failed to fetch cached flights data: \(error.localizedDescription)")
            return []
        }
    }
}

//MARK: - handle states
extension FlightsViewModel {
    @MainActor
    func handleSuccess(model: FlightDataAPI) {
        flights = model.data.compactMap { SingleFlightInfo(from: $0) }
        state = .success
        dependencies.saveFlights.saveAirlineFlightsData(data: flights, airlineName: airline)
        isCached = false
    }
}

