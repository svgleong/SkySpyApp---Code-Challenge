//
//  FlightService.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import Foundation

protocol AviationStackServiceProtocol {
    func fetchAirlineData(for input: String?) async throws -> AirlineDataAPI
    func fetchFlightData(for input: String?) async throws -> FlightDataAPI
}

struct AviationStackService: AviationStackServiceProtocol {
    let client: any APIClientProtocol
}

extension AviationStackService {
    func fetchAirlineData(for input: String?) async throws -> AirlineDataAPI {
        let endpoint = AviationStackEndpoint(type: .airlines, airlineName: input)
        let data = try await client.fetchData(endpoint: endpoint)
        return try model(from: data, as: AirlineDataAPI.self)
    }
    
    func fetchFlightData(for input: String?) async throws -> FlightDataAPI {
        let endpoint = AviationStackEndpoint(type: .flights, airlineName: input)
        let data = try await client.fetchData(endpoint: endpoint)
        return try model(from: data, as: FlightDataAPI.self)
    }
}

extension AviationStackService: ModelDecodable {}
