//
//  Location.swift
//  MapDemo
//
//  Created by Gloria Chan on 11/20/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import UIKit
import MapKit


struct Location {
    var neighborhood: String
    var coord: CLLocationCoordinate2D
    
    init(_ nh: String, _ coordinate: CLLocationCoordinate2D) {
        neighborhood = nh;
        coord = coordinate;
    }
}
