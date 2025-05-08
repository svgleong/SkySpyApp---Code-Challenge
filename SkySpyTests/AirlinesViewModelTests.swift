//
//  AirlinesViewModelTests.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 06/05/2025.
//

import XCTest
@testable import SkySpy

final class AirlinesViewModelTests: XCTestCase {

    var viewModel: AirlinesViewModel!
    var mockService: MockAviationStackService!
    var airlines: [SingleAirlineInfo]!
    var saveFavorites: MockFavoriteAirlinesRepository!

    override func setUp() {
        super.setUp()

        airlines = [
            SingleAirlineInfo(airlineName: "Airline A", isFavorite: false),
            SingleAirlineInfo(airlineName: "Airline B", isFavorite: true),
            SingleAirlineInfo(airlineName: "Airline C", isFavorite: false)
        ]

        saveFavorites = MockFavoriteAirlinesRepository()
        mockService = MockAviationStackService()
        viewModel = AirlinesViewModel(model: airlines, dependencies: .init(service: mockService, saveFavorites: saveFavorites), onFavoriteToggled: {_ in })
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        saveFavorites = nil
        airlines = nil

        super.tearDown()
    }

    // GIVEN that we initialize the view model with airlines
    // WHEN we check the airlines array
    // THEN it should contain the correct airlines
    func testInitialization() {
        XCTAssertEqual(viewModel.airlines.count, 3)
        XCTAssertEqual(viewModel.airlines.first?.airlineName, "Airline A")
    }

    // GIVEN that showFavoritesOnly is false
    // WHEN we toggle it
    // THEN it should be true
    func testToggleShowFavoritesOnly() {
        XCTAssertFalse(viewModel.showFavoritesOnly)
        viewModel.showFavoritesOnly = true
        XCTAssertTrue(viewModel.showFavoritesOnly)
    }

    // GIVEN that we have an airline name
    // WHEN we get a flights view model for it
    // THEN it should have the correct airline name
    func testGetFlightsViewModel() {
        let flightsViewModel = viewModel.getFlightsViewModel(airlineName: "Airline A")
        XCTAssertEqual(flightsViewModel.airline, "Airline A")
    }

    // GIVEN that we have an airline
    // WHEN we perform the favorite action on it
    // THEN the appropriate repository method should be called
    @MainActor func testFavoriteAction() {
        let airline = airlines[0]
        viewModel.favoriteAction(airline: airline)

        if airline.isFavorite {
            XCTAssertTrue(saveFavorites.didCallDeleteFavoriteAirline)
        } else {
            XCTAssertTrue(saveFavorites.didCallSaveFavoriteAirline)
        }
    }
}
