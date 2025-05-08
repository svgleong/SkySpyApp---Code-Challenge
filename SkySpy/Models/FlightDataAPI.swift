//
//  FlightData.swift
//  SkySpy
//
//  Created by SofiaLeong on 01/05/2025.
//

import Foundation

struct FlightDataAPI: Codable {
    let pagination: Pagination
    let data: [FlightData]
}

// MARK: - Datum
struct FlightData: Codable {
    let flightDate, flightStatus: String?
    let departure: Arrival?
    let arrival: Arrival
    let airline: Airline
    let flight: Flight
    let aircraft: Aircraft?
    let live: Live?

    enum CodingKeys: String, CodingKey {
        case flightDate = "flight_date"
        case flightStatus = "flight_status"
        case departure, arrival, airline, flight, aircraft, live
    }
}

// MARK: - Aircraft
struct Aircraft: Codable {
    let registration, iata, icao, icao24: String
}

// MARK: - Airline
struct Airline: Codable {
    let name, iata, icao: String
}

// MARK: - Arrival
struct Arrival: Codable {
    let airport: String?
    let timezone, iata, icao: String?
    let terminal, gate: String?
    let baggage: String?
    let delay: Int?
    let scheduled: String
    let estimated, actual, estimatedRunway, actualRunway: String?

    enum CodingKeys: String, CodingKey {
        case airport, timezone, iata, icao, terminal, gate, baggage, delay, scheduled, estimated, actual
        case estimatedRunway = "estimated_runway"
        case actualRunway = "actual_runway"
    }
}

// MARK: - Flight
struct Flight: Codable {
    let number: String?
    let iata, icao: String
    let codeshared: Codeshared?
}

// MARK: - Live
struct Live: Codable {
    let updated: String
    let latitude, longitude, altitude, direction: Double
    let speedHorizontal, speedVertical: Double
    let isGround: Bool

    enum CodingKeys: String, CodingKey {
        case updated, latitude, longitude, altitude, direction
        case speedHorizontal = "speed_horizontal"
        case speedVertical = "speed_vertical"
        case isGround = "is_ground"
    }
}

// MARK: - Codeshared
struct Codeshared: Codable {
    let airlineName, airlineIata, airlineIcao, flightNumber: String
    let flightIata, flightIcao: String

    enum CodingKeys: String, CodingKey {
        case airlineName = "airline_name"
        case airlineIata = "airline_iata"
        case airlineIcao = "airline_icao"
        case flightNumber = "flight_number"
        case flightIata = "flight_iata"
        case flightIcao = "flight_icao"
    }
}
