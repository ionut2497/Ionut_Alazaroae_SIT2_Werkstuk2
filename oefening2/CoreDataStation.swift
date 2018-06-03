//
//  CoreDataStation.swift
//  oefening2
//
//  Created by student on 03/06/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import CoreData


public class CoreDataStation: NSManagedObject{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<VilloStation> {
        return NSFetchRequest<VilloStation>(entityName: "Station")
    }
    
    @NSManaged public var address: String?
    @NSManaged public var available_bike_stands: Int32
    @NSManaged public var available_bikes: Int32
    @NSManaged public var banking: Bool
    @NSManaged public var bike_stands: Int32
    @NSManaged public var bonus: Bool
    @NSManaged public var contract_name: String?
    @NSManaged public var last_update: Int64
    @NSManaged public var lat: Double
    @NSManaged public var lng: Double
    @NSManaged public var name: String?
    @NSManaged public var number: Int32
    @NSManaged public var status: String?
    
}

