//
//  ViewController.swift
//  MapDemo
//
//  Created by Daniel on 11/16/17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    
    

    
    @IBOutlet weak var mapView: MKMapView!
    var neighborhoodCoords = NeighborhoodCoords()
    var locations = [WeatherAnnotation]()
    let regionRadius: CLLocationDistance = 14000 //meters radius from center point
    let mapWidth: CLLocationDistance = 14000
    let mapHeight: CLLocationDistance = 14000

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, mapHeight, mapWidth)
        mapView.setRegion(mapView.regionThatFits(coordinateRegion), animated: true)
    }
    override func viewDidLoad() {
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
       // regionRadius = Double(width) * 33.8
        
        //roughly the center of SF
        let initialLocation = CLLocation(latitude: 37.751851026046666, longitude: -122.43558883666992)
        centerMapOnLocation(location: initialLocation)


        print(width)
        print(height)
        print(height/width)
        
        //iphone se
//        320.0
//        568.0
//        1.775
        
//        //iphone plus
//        414.0
//        736.0
//        1.77777777777778
        
        
        
        //33.8164251207729 iphone plus
        //19.0217391304348
        
        //43.75 iphone SE
        //24.6478873239437
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        for l in neighborhoodCoords.locations {
            let weatherPoint = WeatherAnnotation(locationName: l.neighborhood,
                                                 coordinate: l.coord)
            let url = getURL(lat: l.coord.latitude, lon: l.coord.longitude)
            let task = URLSession.shared.dataTask(with: url) {
                data, response, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                let weatherData = self.weatherInfoFromData(data)
                weatherPoint.degrees = Int(self.KtoF(weatherData["temp"] as! Double))
                weatherPoint.desc = weatherData["desc"] as! String
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(weatherPoint)
                }
            }
            task.resume()
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "reuseid"
        var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if av == nil {
            av = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            lbl.backgroundColor = .black
            lbl.textColor = .white
            lbl.textAlignment = NSTextAlignment.center
            lbl.alpha = 0.7
            lbl.tag = 42
            av?.addSubview(lbl)
            av?.canShowCallout = true
            av?.frame = lbl.frame
        }
        else {
            av?.annotation = annotation
        }
        
        let lbl = av?.viewWithTag(42) as! UILabel
        lbl.text = annotation.title!
        
        return av
    }
    
    func getURL(lat: Double, lon: Double) -> URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=e84361abfff7e3a663da48cdaf23ea18")!
    }
    
    func weatherInfoFromData(_ data: Data?) -> [String : Any] {
        var results = [String: Any]()
        
        // No data, return an empty array
        guard let data = data else {
            return results
        }
        
        // Parse the Data into a JSON Object
        let JSONObject = try! JSONSerialization.jsonObject(with: data)
        
        // Insist that this object must be a dictionary
        guard let dictionary = JSONObject as? [String : Any] else {
            assertionFailure("Failed to parse data. data.length: \(data.count)")
            return results
        }
        
        let dict = dictionary["main"] as! [String : AnyObject]
        results["temp"] = dict["temp"]
        let arr = dictionary["weather"] as! [[String : AnyObject]]
        results["desc"] = arr.first!["main"]
        results["icon"] = arr.first!["icon"]
        //print(results["desc"])
        
        
        return results
    }
    func KtoF(_ k: Double) -> Double {
        return (9/5)*(k - 273) + 32
    }
}

