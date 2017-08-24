//
//  GeoService.swift
//  Warp17ios
//
//  Created by Mac on 24.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import CoreLocation

private let _sharedGeoService = GeoService()

class GeoService: NSObject, CLLocationManagerDelegate {
    class var shared: GeoService {
        return _sharedGeoService
    }

    var locationManager = CLLocationManager()
    let coder = CLGeocoder()
    
    var location: CLLocation = CLLocation() {
        didSet {
            NotificationCenter.default.post(
                name: NSNotification.Name(rawValue: String(describing: NotificationEvent.gpsUpdated)),
                object: nil,
                userInfo: [location:location]
            )
        }
    }
    
    override init()
    {
        UiUtils.debugPrint("GeoService", "init")
        
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestWhenInUseAuthorization()

    }
    
    func startUpdatingLocation() {
        UiUtils.debugPrint("GeoService", "async startUpdatingLocation call...")
        
        DispatchQueue.main.async {
            UiUtils.debugPrint("GeoService", "startUpdatingLocation")
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        UiUtils.debugPrint("GeoService", "didUpdateLocations")
        
        if let coordinate = locations.last?.coordinate {
            location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
        
        UiUtils.debugPrint("GeoService", "location: \(location)")

        if let currentLocation  = locations.first?.coordinate {
            let coordinate2 = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            coder.reverseGeocodeLocation(coordinate2) { (myPlaces, Error) -> Void in
                print(myPlaces!)
                
                if let place = myPlaces?.first {
                    print(place.locality ?? "no locality")
                }
                
            }
        }
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
    }
    
}
