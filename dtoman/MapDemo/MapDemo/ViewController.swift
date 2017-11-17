//
//  ViewController.swift
//  MapDemo
//
//  Created by Daniel on 11/16/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 14000 //meters radius from center point
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //roughly the center of SF
        let initialLocation = CLLocation(latitude: 37.751851026046666, longitude: -122.43558883666992)

        centerMapOnLocation(location: initialLocation)
    }

}

