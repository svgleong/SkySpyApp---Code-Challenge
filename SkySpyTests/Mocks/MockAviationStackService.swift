//
//  MockAviationStackService.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 06/05/2025.
//

import XCTest
@testable import SkySpy

class MockAviationStackService: AviationStackServiceProtocol {
    
    var shouldThrowError = false
    var mockAirlineData: AirlineDataAPI?
    var mockFlightData: FlightDataAPI?

    func fetchAirlineData(for input: String?) async throws -> SkySpy.AirlineDataAPI {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        guard let data = mockAirlineData else {
            throw NSError(domain: "MockError", code: 2, userInfo: nil)
        }
        return data
    }

    func fetchFlightData(for input: String?) async throws -> SkySpy.FlightDataAPI {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        guard let data = mockFlightData else {
            throw NSError(domain: "MockError", code: 2, userInfo: nil)
        }
        return data
    }
}
