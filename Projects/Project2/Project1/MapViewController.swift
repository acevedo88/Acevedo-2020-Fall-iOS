//
//  MapViewController.swift
//  Project1
//
//  Created by Alexander Acevedo on 10/27/20.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var gpsValue:[String] = []
    var latitudeText = ""
    var longitudeText = ""
    var gpsCoordinate = ""
    
    var longText = ""
    var latText = ""
    var mapTypeText = ""
    var mapNameText = ""
    var waypointText = ""

    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func coordinateButton(_ sender: Any) {
        
        
        let latitude = CLLocationManager().location?
            .coordinate.latitude
        latitudeText = "\(latitude!)"
        let longitude = CLLocationManager().location?.coordinate.longitude
        longitudeText = "\(longitude!)"
        performSegue(withIdentifier: "coordinates", sender: self)
        gpsCoordinate = "Lat: \(latitude!)  Long: \(longitude!)"
        
        gpsValue.append(gpsCoordinate)
        
        let indexPath = IndexPath(row: gpsValue.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! DataPopupViewController
        vc.longText = self.longitudeText
        vc.latText = self.latitudeText
    }
    
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gpsValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gpsCell", for: indexPath)
        cell.textLabel?.text = gpsValue[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            gpsValue.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
    
}

extension MapViewController: CLLocationManagerDelegate{
    
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



