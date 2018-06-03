//
//  MapAnnotation.swift
//  oefening2
//
//  Created by student on 03/06/18.
//  Copyright © 2018 student. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {
    
    var address: String?
    var available_bike_stands: Int32
    var available_bikes: Int32
    var banking: Bool
    var bike_stands: Int32
    var bonus: Bool
    var contract_name: String?
    var last_update: Int64
    var coordinate: CLLocationCoordinate2D
    var name: String?
    var number: Int32
    var status: String?
    var title: String?
    var subtitle: String?
    
    
    init (address:String,AvailBikeStands:Int32,AvailBikes:Int32,banking:Bool,bonus:Bool,BikeStands:Int32,ContrName:String,LastUpdate:Int64,coordinate:CLLocationCoordinate2D, name:String,number:Int32,status:String )
    {
        self.address = address
        self.available_bike_stands = AvailBikeStands
        self.available_bikes = AvailBikes
        self.banking = banking
        self.bonus = bonus
        self.bike_stands = BikeStands
        self.contract_name = ContrName
        self.last_update = LastUpdate
        self.coordinate = coordinate
        self.name = name
        self.number = number
        self.status = status
    }
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.name = ""
        self.number = 0
        self.status = ""
        self.address = ""
        self.available_bike_stands = 0
        self.available_bikes = 0
        self.banking = false
        self.bonus = false
        self.bike_stands = 0
        self.contract_name = ""
        self.last_update = 0
    }
    
    
    
}
