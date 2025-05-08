//
//  FlightsViewModelTests.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 05/05/2025.
//

@testable import SkySpy
import XCTest

final class FlightsViewModelTests: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    lazy var client: APIClient = {
        APIClient(session: session)
    }()

    var service: AviationStackService!
    var viewModel: FlightsViewModel!
    var saveFlights: FlightDataSavable!

    override func setUpWithError() throws {
        try super.setUpWithError()

        service = AviationStackService(client: client)
        saveFlights = MockFlightDataRepository()
        viewModel = FlightsViewModel(airline: "British Airways", dependencies: .init(service: service, saveFlights: saveFlights))
    }

    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
        FakeURLProtocol.requestHandler = nil

        try super.tearDownWithError()
    }
}

extension FlightsViewModelTests {
    // GIVEN that we perform a request
    // WHEN we receive the right data
    // THEN we're in a success state
    func testItFetchesAirlinesSuccessfully() async throws {
        FakeURLProtocol.requestHandler = { [weak self] request in
            let url = try XCTUnwrap(request.url)
            
            let httpResponse = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = try XCTUnwrap(self?.mockData)
            let response = try XCTUnwrap(httpResponse)
            
            return (response, data)
        }
        
        await viewModel.fetchData()
        
        if case .success = viewModel.state {
            XCTAssertEqual(viewModel.airline, "British Airways")
            XCTAssertEqual(viewModel.flights.first?.departureAirport, "DPS")
            XCTAssertEqual(viewModel.flights.first?.isLive, true)
        } else {
            XCTFail("Expected State to be Success")
        }
    }
    
    // GIVEN that we perform a request
    // WHEN we receive an error
    // THEN we're in a failure state
    func testItFetchesAirlinesWithError() async throws {
        viewModel = FlightsViewModel(airline: "Ryanair", dependencies: .init(service: service, saveFlights: saveFlights))
        
        FakeURLProtocol.requestHandler = { [weak self] request in
            let url = try XCTUnwrap(request.url)
            
            let httpResponse = HTTPURLResponse(
                url: url,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = try XCTUnwrap(self?.mockData)
            let response = try XCTUnwrap(httpResponse)
            
            return (response, data)
        }
        
        await viewModel.fetchData()
        
        if case .failure = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected State to be Failure")
        }
    }
    
    // GIVEN that we perform a request
    // WHEN we receive an invalid response
    // THEN we're in a failure state
    func testItFailsWithInvalidResponse() async throws {
        viewModel = FlightsViewModel(airline: "TAP", dependencies: .init(service: service, saveFlights: saveFlights))
        
        FakeURLProtocol.requestHandler = { [weak self] request in
            let url = try XCTUnwrap(request.url)
            
            let httpResponse = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            let data = try XCTUnwrap(self?.invalidMockData)
            let response = try XCTUnwrap(httpResponse)
            
            return (response, data)
        }
        
        await viewModel.fetchData()
        
        if case .failure = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail("Expected State to be Failure")
        }
    }
}

extension FlightsViewModelTests {
    var mockData: Data? {
        return readDataFromFile(named: "flights_response")
    }
    
    var invalidMockData: Data? {
        return readDataFromFile(named: "flights_response_invalid")
    }
}
