//
//  SIngleAirlineInfo.swift
//  SkySpy
//
//  Created by SofiaLeong on 03/05/2025.
//

import Foundation

struct SingleAirlineInfo: Identifiable {
    let id = UUID()
    let airlineName: String
    var isFavorite: Bool
}

extension SingleAirlineInfo {
    init?(from data: AirlineData) {
        self.airlineName = data.airlineName
        self.isFavorite = false
    }
    
    init?(from data: FavoriteAirline) {
        self.airlineName = data.airlineName ?? ""
        self.isFavorite = true
    }
}
