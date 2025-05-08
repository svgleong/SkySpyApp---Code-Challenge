//
//  SingleFlightInfo.swift
//  SkySpy
//
//  Created by SofiaLeong on 02/05/2025.
//

import Foundation

struct SingleFlightInfo: Identifiable {
    let id = UUID()
    let flightNumber: String
    let flightDate: String?
    let airlineName: String
    let airlineIata: String
    let departureAirport: String?
    let departureTime: String?
    let departureTimezone: String
    let departureAirportName: String?
    let arrivalAirportName: String?
    let arrivalAirport: String?
    let arrivalTime: String
    let arrivalTimezone: String
    let terminal: String?
    let gate: String?
    let delayInMinutes: Int?
    let aircraftRegistration: String?
    let isLive: Bool
    let status: String?
    let altitude: Double?
    let latitude: Double?
    let longitude: Double?
}

extension SingleFlightInfo {
    init?(from data: FlightData) {
        let actualDeparture = data.departure?.actual ?? data.departure?.scheduled
        let actualArrival = data.arrival.actual ?? data.arrival.scheduled
        
        guard
            let flightNum = data.flight.number
        else {
            print("Missing flight number — skipping flight.")
            return nil
        }

        self.flightNumber = flightNum
        self.flightDate = data.flightDate
        self.airlineName = data.airline.name
        self.airlineIata = data.airline.iata
        self.departureAirport = data.departure?.iata
        self.departureTime = actualDeparture
        self.departureTimezone = data.departure?.timezone ?? "Europe/London"
        self.departureAirportName = data.departure?.airport
        self.arrivalAirportName = data.arrival.airport
        self.arrivalAirport = data.arrival.iata
        self.arrivalTime = actualArrival
        self.arrivalTimezone = data.arrival.timezone ?? "Europe/London"
        self.terminal = data.arrival.terminal
        self.gate = data.arrival.gate
        self.delayInMinutes = data.arrival.delay
        self.aircraftRegistration = data.aircraft?.registration
        self.isLive = !(data.live?.isGround ?? true)
        self.status = data.flightStatus
        self.altitude = data.live?.altitude
        self.latitude = data.live?.latitude
        self.longitude = data.live?.longitude
    }
    
    init?(from entity: FlightInfoEntity) {
        
        guard
            let flightNum = entity.flightNumber
        else {
            print("Missing flight number — skipping flight.")
            return nil
        }
        
        self.flightNumber = flightNum
        self.flightDate = entity.flightDate
        self.airlineName = entity.airlineName ?? ""
        self.airlineIata = entity.airlineIata ?? ""
        self.departureAirport = entity.departureAirport
        self.departureTime = entity.departureTime
        self.departureTimezone = entity.departureTimezone ?? "Europe/London"
        self.departureAirportName = entity.departureAirportName
        self.arrivalAirport = entity.arrivalAirport
        self.arrivalAirportName = entity.arrivalAirportName
        self.arrivalTime = entity.arrivalTime ?? ""
        self.arrivalTimezone = entity.arrivalTimezone ?? "Europe/London"
        self.terminal = entity.terminal
        self.gate = entity.gate
        self.delayInMinutes = entity.delayInMinutes == -1 ? nil : Int(entity.delayInMinutes)
        self.aircraftRegistration = entity.aircraftRegistration
        self.isLive = entity.isLive
        self.status = entity.status
        self.altitude = entity.altitude == -1 ? nil : entity.altitude
        self.latitude = entity.latitude == -1 ? nil : entity.latitude
        self.longitude = entity.longitude == -1 ? nil : entity.longitude
    }
}

extension SingleFlightInfo {
    static func sample(flightNumber: String = "1234",
                       flightDate: String? = "2025-05-03T00:45:00+00:00",
                       airlineName: String = "TAP",
                       airlineIata: String = "TP",
                       departureAirport: String? = "LIS",
                       departureTime: String? = "2025-05-03T00:45:00+00:00",
                       departureTimezone: String = "",
                       departureAirportName: String? = "Madrid airport",
                       arrivalAirportName: String? = "Lisbon Airport",
                       arrivalAirport: String? = "MAD",
                       arrivalTime: String = "2025-05-03T00:45:00+00:00",
                       arrivalTimezone: String = "Europe/London",
                       terminal: String? = "1",
                       gate: String? = "42",
                       delayInMinutes: Int = 50,
                       aircraftRegistration: String? = "RFC",
                       isLive: Bool = true,
                       status: String? = "scheduled",
                       altitude: Double? = 5000,
                       latitude: Double? = 12,
                       longitude: Double? = 12) -> SingleFlightInfo {
        return SingleFlightInfo(flightNumber: flightNumber,
                                flightDate: flightDate,
                                airlineName: airlineName,
                                airlineIata: airlineIata,
                                departureAirport: departureAirport,
                                departureTime: departureTime,
                                departureTimezone: departureTimezone,
                                departureAirportName: departureAirportName,
                                arrivalAirportName: arrivalAirportName,
                                arrivalAirport: arrivalAirport,
                                arrivalTime: arrivalTime,
                                arrivalTimezone: arrivalTimezone,
                                terminal: terminal,
                                gate: gate,
                                delayInMinutes: delayInMinutes,
                                aircraftRegistration: aircraftRegistration,
                                isLive: isLive,
                                status: status,
                                altitude: altitude,
                                latitude: latitude,
                                longitude: longitude
                               )
    }
}
