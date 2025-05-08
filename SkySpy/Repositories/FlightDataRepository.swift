//
//  FlightRepo.swift
//  SkySpy
//
//  Created by SofiaLeong on 03/05/2025.
//

import Foundation
import CoreData

protocol FlightDataSavable {
    func saveAirlineFlightsData(data: [SingleFlightInfo], airlineName: String)
}

struct FlightDataRepository: FlightDataSavable {
    func saveAirlineFlightsData(data: [SingleFlightInfo], airlineName: String) {
        let moc = DataController.shared.container.viewContext
        
        guard data.first != nil else {
            print("No flight data provided.")
            return
        }
        
        let fetchRequest: NSFetchRequest<AirlineInfoEntity> = AirlineInfoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", airlineName)
        
        do {
            let savedAirlines = try moc.fetch(fetchRequest)
            let airline: AirlineInfoEntity
            
            if let airlineExists = savedAirlines.first {
                airline = airlineExists
                
                // Clean previous flights before adding new ones
                if let flights = airline.flights as? Set<FlightInfoEntity> {
                    for flight in flights {
                        moc.delete(flight)
                    }
                }
            } else {
                airline = AirlineInfoEntity(context: moc)
                airline.name = airlineName
            }
            
            
            for flightData in data {
                let newFlight = FlightInfoEntity(context: moc)
                
                newFlight.id = flightData.id
                newFlight.flightNumber = flightData.flightNumber
                newFlight.flightDate = flightData.flightDate
                newFlight.airlineName = flightData.airlineName
                newFlight.airlineIata = flightData.airlineIata
                newFlight.departureAirport = flightData.departureAirport
                newFlight.departureTime = flightData.departureTime
                newFlight.departureTimezone = flightData.departureTimezone
                newFlight.departureAirportName = flightData.departureAirportName
                newFlight.arrivalAirportName = flightData.arrivalAirportName
                newFlight.arrivalAirport = flightData.arrivalAirport
                newFlight.arrivalTime = flightData.arrivalTime
                newFlight.arrivalTimezone = flightData.arrivalTimezone
                newFlight.terminal = flightData.terminal
                newFlight.gate = flightData.gate
                newFlight.delayInMinutes = Int16(flightData.delayInMinutes ?? -1)
                newFlight.aircraftRegistration = flightData.aircraftRegistration
                newFlight.isLive = flightData.isLive
                newFlight.status = flightData.status
                newFlight.altitude = flightData.altitude ?? -1
                newFlight.latitude = flightData.latitude ?? -1
                newFlight.longitude = flightData.longitude ?? -1
                
                airline.addToFlights(newFlight)
            }
                
            try moc.save()
            print("Airline data saved successfully!")
            
        } catch {
            print("Error saving airline data: \(error.localizedDescription)")
        }
    }
}
