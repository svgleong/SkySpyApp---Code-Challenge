//
//  AirlineInfoEntity+CoreDataProperties.swift
//  SkySpy
//
//  Created by SofiaLeong on 03/05/2025.
//
//

import Foundation
import CoreData


extension AirlineInfoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AirlineInfoEntity> {
        return NSFetchRequest<AirlineInfoEntity>(entityName: "AirlineInfoEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var flights: NSSet?

}

// MARK: Generated accessors for flights
extension AirlineInfoEntity {

    @objc(addFlightsObject:)
    @NSManaged public func addToFlights(_ value: FlightInfoEntity)

    @objc(removeFlightsObject:)
    @NSManaged public func removeFromFlights(_ value: FlightInfoEntity)

    @objc(addFlights:)
    @NSManaged public func addToFlights(_ values: NSSet)

    @objc(removeFlights:)
    @NSManaged public func removeFromFlights(_ values: NSSet)

}

extension AirlineInfoEntity : Identifiable {

}
