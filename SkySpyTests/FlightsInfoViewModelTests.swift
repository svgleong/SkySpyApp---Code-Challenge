//
//  FlightsInfoViewModelTests.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 05/05/2025.
//

@testable import SkySpy
import XCTest
import Combine

final class FlightsInfoViewModelTests: XCTestCase {

    var viewModel: FlightsInfoViewModel!
    var filters: FiltersViewModel!
    var flights: [SingleFlightInfo]!

    override func setUp(){
        super.setUp()

        flights = [
            .sample(departureAirport: "LHR", arrivalAirport: "JFK", delayInMinutes: 0, status: "scheduled", altitude: 5800),
            .sample(departureAirport: "LHR", arrivalAirport: "LAX", delayInMinutes: 15, status: "active", altitude: 2000),
            .sample(departureAirport: "CDG", arrivalAirport: "JFK", delayInMinutes: 65, status: "landed", altitude: 0),
            .sample(departureAirport: "LIS", arrivalAirport: "MAD", delayInMinutes: 65, status: "diverted", altitude: 0),
            .sample(departureAirport: "LHR", arrivalAirport: "SYD", delayInMinutes: 0, status: "cancelled", altitude: nil)
        ]

        let allArrivalAirports = Set(flights.compactMap { $0.arrivalAirport })
        let allDepartureAirports = Set(flights.compactMap { $0.departureAirport })

        viewModel = FlightsInfoViewModel(model: flights)
        viewModel.filters = FiltersViewModel(allArrivalAirports: allArrivalAirports, allDepartureAirports: allDepartureAirports)
    }

    override func tearDown(){
        viewModel = nil
        flights = []
        FakeURLProtocol.requestHandler = nil

        super.tearDown()
    }
}

extension FlightsInfoViewModelTests {

    // GIVEN a valid ISO date string and timezone
    // WHEN we format the time
    // THEN it should return the correctly formatted time
    func testFormattedTime_ValidISODate_ReturnsFormattedTime() {

        let isoDate = "2025-05-05T14:00:00Z"
        let formatted = viewModel.formattedTime(isoDate, timeZone: "America/New_York")

        XCTAssertEqual(formatted, "10:00")
    }

    // GIVEN an invalid date string
    // WHEN we format the time
    // THEN it should return "Invalid date"
    func testFormattedTime_InvalidDate_ReturnsInvalidDate() {

        let invalidDate = "not-a-real-date"
        let result = viewModel.formattedTime(invalidDate, timeZone: "UTC")

        XCTAssertEqual(result, "Invalid date")
    }

    // GIVEN different flight status strings
    // WHEN we get the color for each status
    // THEN it should return the correct color for each status
    func testStatusColorMapping() {
        XCTAssertEqual(viewModel.filters.statusColor(for: "scheduled"), .blue)
        XCTAssertEqual(viewModel.filters.statusColor(for: "ACTIVE"), .green)
        XCTAssertEqual(viewModel.filters.statusColor(for: "landed"), .gray)
        XCTAssertEqual(viewModel.filters.statusColor(for: "cancelled"), .red)
        XCTAssertEqual(viewModel.filters.statusColor(for: "incident"), .orange)
        XCTAssertEqual(viewModel.filters.statusColor(for: "diverted"), .purple)
        XCTAssertEqual(viewModel.filters.statusColor(for: "unknown"), .black)
    }

    // GIVEN a list of flights with different statuses
    // WHEN we filter by active status
    // THEN it should return only active flights
    func testFiltersByStatus() {
        viewModel.filters.handleFlightStatusTap(.active)
        let filtered = viewModel.filteredFlights

        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.status, "active")
    }

    // GIVEN a list of flights with different delay times
    // WHEN we filter by delays greater than 60 minutes
    // THEN it should return only flights with delays over 60 minutes
    func testFiltersByDelay() {
        viewModel.filters.handleDelayTap(.moreThan60)
        let filtered = viewModel.filteredFlights

        XCTAssertEqual(filtered.count, 2)
        XCTAssertEqual(filtered.first?.delayInMinutes, 65)
    }

    // GIVEN a list of flights at different altitudes
    // WHEN we filter by low altitude
    // THEN it should return only flights at low altitude
    func testFiltersByAltitude() {
        viewModel.filters.handleAltitudeTap(.low)
        let filtered = viewModel.filteredFlights

        XCTAssertEqual(filtered.count, 3)
        XCTAssertEqual(filtered.first?.altitude, 0)
    }

    // GIVEN a list of flights to different arrival airports
    // WHEN we filter by JFK airport
    // THEN it should return only flights arriving at JFK
    func testFiltersByArrivalAirport() {
        viewModel.filters.handleArrivalAirportsTap("JFK")
        let filtered = viewModel.filteredFlights

        XCTAssertEqual(filtered.count, 2)
        XCTAssertTrue(filtered.allSatisfy { $0.arrivalAirport == "JFK" })
    }

    // GIVEN a list of flights with various properties
    // WHEN we apply multiple filter criteria simultaneously
    // THEN it should return only flights matching all criteria
    func testFiltersByMultipleCriteria() {
        viewModel.filters.handleFlightStatusTap(.landed)
        viewModel.filters.handleDelayTap(.moreThan60)
        viewModel.filters.handleArrivalAirportsTap("JFK")

        let filtered = viewModel.filteredFlights

        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.status, "landed")
        XCTAssertEqual(filtered.first?.delayInMinutes, 65)
        XCTAssertEqual(filtered.first?.arrivalAirport, "JFK")
    }
}
