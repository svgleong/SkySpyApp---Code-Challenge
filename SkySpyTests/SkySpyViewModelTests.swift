//
//  SkySpyViewModelTests.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 05/05/2025.
//

@testable import SkySpy
import XCTest
import CoreData

final class SkySpyViewModelTests: XCTestCase {
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [FakeURLProtocol.self]
        return URLSession(configuration: configuration)
    }()

    lazy var client: APIClient = {
        APIClient(session: session)
    }()

    var service: AviationStackService!
    var viewModel: SkySpyViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        clearCachedFavorites()

        service = AviationStackService(client: client)
        viewModel = SkySpyViewModel(service: service)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        service = nil
        FakeURLProtocol.requestHandler = nil

        try super.tearDownWithError()
    }
}

extension SkySpyViewModelTests {

    // GIVEN that we perform a request
    // WHEN we receive an error
    // THEN we're in a failure state
    func testItFetchesAirlinesWithError() async throws {
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
            XCTAssertEqual(viewModel.airlines.first?.airlineName, "America Airlines")
            XCTAssertEqual(viewModel.airlines.first?.isFavorite, false)
        } else {
            XCTFail("Expected State to be Success")
        }
    }

    // GIVEN that we perform a request
    // WHEN we receive an invalid response
    // THEN we're in a failure state
    func testItFailsWithInvalidResponse() async throws {
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

extension SkySpyViewModelTests {
    var mockData: Data? {
        return readDataFromFile(named: "airlines_response")
    }

    var invalidMockData: Data? {
        return readDataFromFile(named: "airlines_response_invalid")
    }
}

extension XCTest {
    func readDataFromFile(named fileName: String) -> Data? {
        guard let fileURL = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") else {
            XCTFail("Missing file: \(fileName).json")
            return nil
        }

        do {
            return try Data(contentsOf: fileURL)
        } catch {
            XCTFail("Failed to read file: \(fileName).json, error: \(error)")
            return nil
        }
    }
}

extension SkySpyViewModelTests {
    func clearCachedFavorites() {
        let context = DataController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = FavoriteAirline.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            XCTFail("Failed to clear cached favorites: \(error)")
        }
    }

}
