//
//  LocationFetcher.swift
//  ClimaUI
//
//  Created by Kenneth Liou on 12/16/19.
//  Copyright © 2019 Kenneth Liou. All rights reserved.
//

import Foundation
import CoreLocation
//class to fetch weather
class LocationFetcher: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var lastKnownLocation: CLLocationCoordinate2D?
    
    //when the app starts...
    override init() {
        super.init()
        manager.delegate = self
        start()
    }

    //start getting location data
    func start() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
    }
}
