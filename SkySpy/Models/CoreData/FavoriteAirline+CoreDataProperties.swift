//
//  FavoriteAirline+CoreDataProperties.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//
//

import Foundation
import CoreData


extension FavoriteAirline {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteAirline> {
        return NSFetchRequest<FavoriteAirline>(entityName: "FavoriteAirline")
    }

    @NSManaged public var airlineName: String?

}

extension FavoriteAirline : Identifiable {

}
