//
//  MockAPIClient.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 05/05/2025.
//

@testable import SkySpy
import XCTest

final class MockAPIClient: APIClientProtocol {
    var mockData: Data
    var shouldThrowError = false

    init(mockData: Data) {
        self.mockData = mockData
    }

    func fetchData(endpoint: Endpointable) async throws -> Data {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return mockData
    }
}
