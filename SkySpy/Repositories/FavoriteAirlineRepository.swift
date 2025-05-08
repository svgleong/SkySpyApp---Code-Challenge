//
//  FavoriteAirlineSavable.swift
//  SkySpy
//
//  Created by SofiaLeong on 04/05/2025.
//

import Foundation
import CoreData

protocol FavoriteAirlineSavable {
    func saveFavoriteAirline(data: SingleAirlineInfo)
    func deleteFavoriteAirline(data: SingleAirlineInfo)
}

struct FavoriteAirlineRepository: FavoriteAirlineSavable {
    func saveFavoriteAirline(data: SingleAirlineInfo) {
        let moc = DataController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteAirline> = FavoriteAirline.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "airlineName == %@", data.airlineName)
        
        do {
            let savedAirlines = try moc.fetch(fetchRequest)

            if savedAirlines.isEmpty {
                let newAirline = FavoriteAirline(context: moc)
                
                newAirline.airlineName = data.airlineName
                
                try moc.save()
                print("Favorite airline saved successfully!")
            }
        } catch {
            print("Error saving favorite airline: \(error.localizedDescription)")
        }
    }
    
    func deleteFavoriteAirline(data: SingleAirlineInfo) {
        let moc = DataController.shared.container.viewContext
        
        let fetchRequest: NSFetchRequest<FavoriteAirline> = FavoriteAirline.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "airlineName == %@", data.airlineName)
        
        do {
            let savedAirlines = try moc.fetch(fetchRequest)

            if let airline = savedAirlines.first {
                moc.delete(airline)
                print("Favorite airline deleted successfully!")
            } else {
                print("No favorite airline found to delete.")
            }
            
        } catch {
            print("Error deleting favorite airline: \(error.localizedDescription)")
        }
    }
}
