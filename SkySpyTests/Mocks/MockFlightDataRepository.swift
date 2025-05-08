//
//  MockFlightDataRepository.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 06/05/2025.
//

@testable import SkySpy

class MockFlightDataRepository: FlightDataSavable {
    var didCallSaveAirlineData = false
    
    func saveAirlineFlightsData(data: [SkySpy.SingleFlightInfo], airlineName: String) {
        didCallSaveAirlineData = true
    }
}
