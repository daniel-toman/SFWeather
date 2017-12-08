//
//  Weather.swift
//  MapDemo
//
//  Created by Gloria Chan on 11/17/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import MapKit

class WeatherAnnotation: NSObject, MKAnnotation {
    var degrees: Int
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    var desc: String
    
    init(locationName: String, coordinate: CLLocationCoordinate2D) {
        self.locationName = locationName
        self.coordinate = coordinate
        self.degrees = 0
        self.desc = ""
        
        super.init()
    }
    
    var subtitle: String? {
        return " \(desc)"
    }
    
    var title: String? {
        return "\(degrees)"
    }
}
