//
//  AddCityTableViewController.swift
//  Warp17ios
//
//  Created by Mac on 18.07.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import UIKit
import MapKit

class AddCityViewController: UIViewController, MKMapViewDelegate
{
    var planetId: Int = 0
    
    @IBOutlet weak var newCityName: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateMap(_:)), name: NSNotification.Name(rawValue: String(describing: NotificationEvent.gpsUpdated)), object: nil)
        
        GeoService.shared.startUpdatingLocation()
        
        //let placeLocation  = CLLocationCoordinate2D(latitude: localCoordinate.coordinate.latitude, longitude: localCoordinate.coordinate.longitude)
        
        //let placeMark = MapPin(coordinate: placeLocation, title: "new place", subtitle: "home")
        //mapView.a//.addAnnotation(placeMark)
        
    }
    
    func updateMap(_ notification: NSNotification) {
        UiUtils.debugPrint("addCityView", "updateMap")
        
        if let location = notification.userInfo?["location"] as? CLLocation {
            centerMapOnLocation(location: location)
        }
        
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        //let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //region.center = mapView.userLocation.coordinate
        
        UiUtils.debugPrint("addCityView", "map - setRegion")

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func CreateCity(_ sender: UIBarButtonItem) {
        
        if newCityName.text!.isEmpty {
            UiUtils.sharedInstance.errorAlert(text: "New city name is empty.")
        } else if !DataStorage.sharedDataStorage.citiesById.filter({ (_, city) -> Bool in
            return (city.name == newCityName.text!)
            }).isEmpty
        {
            UiUtils.sharedInstance.errorAlert(text: "This city name is already used.")
        } else {
            
            let citiesProvider = CitiesProvider()
            citiesProvider.createCity(planetId: DataStorage.sharedDataStorage.currentPlanetId, latitude: 51.51, longitude: 52.52, name: newCityName.text!)
            
            self.performSegue(withIdentifier: "returnToCitiesList", sender: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
