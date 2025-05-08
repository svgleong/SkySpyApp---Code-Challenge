//
//  DataController.swift
//  SkySpy
//
//  Created by SofiaLeong on 03/05/2025.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container: NSPersistentContainer
    
    // Singleton
    static let shared = DataController()
    
    private init() {
        container = NSPersistentContainer(name: "FlightModel")
        
        guard Bundle(for: type(of: self)).url(forResource: "FlightModel", withExtension:"momd") != nil else {
            fatalError("Error loading model from bundle")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unable to save changes: \(error.localizedDescription)")
            }
        }
    }
}
