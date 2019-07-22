//
//  FlightData+CoreDataProperties.swift
//  
//
//  Created by Anna Grace on 2/19/19.
//
//

import Foundation
import CoreData


extension FlightData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlightData> {
        return NSFetchRequest<FlightData>(entityName: "FlightData")
    }

    @NSManaged public var fileURL: URL?
    @NSManaged public var date: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var flightName: String?

}
