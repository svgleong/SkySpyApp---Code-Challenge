//
//  Mock.swift
//  SkySpyTests
//
//  Created by SofiaLeong on 06/05/2025.
//

@testable import SkySpy

class MockFavoriteAirlinesRepository: FavoriteAirlineSavable {
    var didCallSaveFavoriteAirline = false
    var didCallDeleteFavoriteAirline = false

    func saveFavoriteAirline(data: SingleAirlineInfo) {
        didCallSaveFavoriteAirline = true
    }

    func deleteFavoriteAirline(data: SingleAirlineInfo) {
        didCallDeleteFavoriteAirline = true
    }
}
