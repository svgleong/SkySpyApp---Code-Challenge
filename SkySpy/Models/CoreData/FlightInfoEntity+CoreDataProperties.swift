//
//  FlightInfoEntity+CoreDataProperties.swift
//  SkySpy
//
//  Created by SofiaLeong on 03/05/2025.
//
//

import Foundation
import CoreData


extension FlightInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightInfoEntity> {
        return NSFetchRequest<FlightInfoEntity>(entityName: "FlightInfoEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var flightNumber: String?
    @NSManaged public var flightDate: String?
    @NSManaged public var airlineName: String?
    @NSManaged public var airlineIata: String?
    @NSManaged public var departureAirport: String?
    @NSManaged public var departureTime: String?
    @NSManaged public var departureTimezone: String?
    @NSManaged public var departureAirportName: String?
    @NSManaged public var arrivalAirportName: String?
    @NSManaged public var arrivalAirport: String?
    @NSManaged public var arrivalTime: String?
    @NSManaged public var arrivalTimezone: String?
    @NSManaged public var terminal: String?
    @NSManaged public var gate: String?
    @NSManaged public var delayInMinutes: Int16
    @NSManaged public var aircraftRegistration: String?
    @NSManaged public var isLive: Bool
    @NSManaged public var status: String?
    @NSManaged public var altitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var airline: AirlineInfoEntity?

}

extension FlightInfoEntity : Identifiable {

}
