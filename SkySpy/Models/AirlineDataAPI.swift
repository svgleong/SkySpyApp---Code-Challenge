//
//  FlightData.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import Foundation

// MARK: - FlightData
struct AirlineDataAPI: Codable {
    let pagination: Pagination
    let data: [AirlineData]
}

// MARK: - Data
struct AirlineData: Codable {
    let id: String
    let fleetAverageAge: String?
    let airlineID: String?
    let callsign: String?
    let hubCode: String?
    let iataCode: String?
    let icaoCode: String?
    let countryIso2: String?
    let dateFounded: String?
    let iataPrefixAccounting: String?
    let airlineName: String
    let countryName: String?
    let fleetSize: String?
    let status: String?
    let type: String?


    enum CodingKeys: String, CodingKey {
        case id
        case fleetAverageAge = "fleet_average_age"
        case airlineID = "airline_id"
        case callsign
        case hubCode = "hub_code"
        case iataCode = "iata_code"
        case icaoCode = "icao_code"
        case countryIso2 = "country_iso2"
        case dateFounded = "date_founded"
        case iataPrefixAccounting = "iata_prefix_accounting"
        case airlineName = "airline_name"
        case countryName = "country_name"
        case fleetSize = "fleet_size"
        case status
        case type
    }

}

// MARK: - Pagination
struct Pagination: Codable {
    let offset: Int
    let limit: Int
    let count: Int
    let total: Int
}

