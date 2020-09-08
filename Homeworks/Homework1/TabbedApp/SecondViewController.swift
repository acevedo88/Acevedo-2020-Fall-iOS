//
//  SecondViewController.swift
//  TabbedApp
//
//  Created by Alexander Acevedo on 9/7/20.
//  Copyright © 2020 Stasis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SecondViewController: UIViewController{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var outputTextLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let bsuLocation = CLLocation(latitude: 43.602760, longitude: -116.201870)
    let csLocation = CLLocation(latitude: 43.615230, longitude: -116.203451)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func locationButton(_ sender: Any) {
            
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        outputTextLabel.text = "This is the Apple Headquaters.  Technically where you are when running this simulator."
        
    }
    
    @IBAction func bsuLocationButton(_ sender: Any) {
        
        mapView.centerTo(location: bsuLocation)
        locationManager.stopUpdatingLocation()
        outputTextLabel.text = "This is Boise State University Location."
    }
    
    @IBAction func csLocationButton(_ sender: Any) {
        
        mapView.centerTo(location: csLocation)
        locationManager.stopUpdatingLocation()
        outputTextLabel.text = "This is the Computer Science Building Location."
        
    }
    
}

extension SecondViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
}

private extension MKMapView{
    func centerTo( location: CLLocation, regionRadius: CLLocationDistance = 1000){
        let coordinateRegion = MKCoordinateRegion(
          center: location.coordinate,
          latitudinalMeters: regionRadius,
          longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
        
    }
}

