//
//  MapViewController.swift
//  GetLost
//
//  Created by Alexander Acevedo on 12/9/20.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapLayerButton: UIButton!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true;

        
    }
    
    @IBAction func mapLayerSelectorButton(_ sender: Any) {
        switch mapView.mapType {
        case .standard:
            mapView.mapType = .hybrid
        case .hybrid:
            mapView.mapType = .hybridFlyover
        default:
            mapView.mapType = .standard
        }
    }
    
    @IBAction func currentLocationButton(_ sender: Any) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func trackingButton(_ sender: Any) {
        print("button pressed")
    }
    
    

    
}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region = MKCoordinateRegion(center: myLocation, span: span)
            mapView.setRegion(region, animated: true)
        }
        mapView.showsUserLocation = true;
        locationManager.stopUpdatingLocation()
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

