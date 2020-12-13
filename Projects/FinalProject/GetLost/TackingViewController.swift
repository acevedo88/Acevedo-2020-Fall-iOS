//
//  TackingViewController.swift
//  GetLost
//
//  Created by Alexander Acevedo on 12/12/20.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
import AVFoundation

class TrackingViewController: UIViewController {
    
    @IBOutlet weak var trackMapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    private var timer: Timer?
    private var seconds = 0;
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    let locationManager = CLLocationManager()
    private var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        trackMapView.showsUserLocation = true;
        configureView()

    }
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      locationManager.stopUpdatingLocation()
    }
    
    private func configureView() {
        let formatedDate = Date()
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.YYY"
        let date = formater.string(from: formatedDate)
        
        distanceLabel.text = "Distance: 0"
        timeLabel.text = "Time: 0"
        paceLabel.text = "Pace: 0"
        dateLabel.text = "Date: \(date)"
        
        stopButton.isHidden = true
        startButton.isHidden = false
    }
    
    @IBAction func StartButton(_ sender: Any) {
        stopButton.isHidden = false
        startButton.isHidden = true
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.eachSecond()
        }
        startLocationUpdates()
        trackMapView.showsUserLocation = true;
    }
    
    
    @IBAction func StopButton(_ sender: Any) {
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
          self.stopRun()
          self.saveRun()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
          self.stopRun()
          _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    }
    
    @IBAction func mapViewToggle(_ sender: Any) {
        switch trackMapView.mapType {
        case .standard:
            trackMapView.mapType = .hybrid
        default:
            trackMapView.mapType = .standard
        }
    }
    
    func eachSecond(){
        seconds += 1
        updateDisplay()
    }
    
    private func stopRun(){
        locationManager.stopUpdatingLocation()
    }
    
    private func saveRun(){
        var newName = ""
        let newRun = Run(context: CoreDataStack.context)
        
        let alert = UIAlertController(title: "Save Name",
            message: "Please give your save a name.",
            preferredStyle: .alert)
        
        // Submit button
        alert.addAction(UIAlertAction(title: "Submit", style: .default){_ in
            let textField = alert.textFields![0] as UITextField
            newName = textField.text ?? "Name"
            print(newName)
            newRun.name = newName
            newRun.distance = self.distance.value
            newRun.duration = Int16(self.seconds)
            newRun.timestamp = Date()
            
            for location in self.locationList {
              let locationObject = Location(context: CoreDataStack.context)
              locationObject.timestamp = location.timestamp
              locationObject.latitude = location.coordinate.latitude
              locationObject.longitude = location.coordinate.longitude
              newRun.addToLocations(locationObject)
            }
            
            CoreDataStack.saveContext()
            
            self.run = newRun
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
            
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        // Add textFields and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Save Name"
            textField.clearButtonMode = .whileEditing
        }
        //alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
       
    }
    
    private func startLocationUpdates() {
      locationManager.delegate = self
      locationManager.activityType = .fitness
      locationManager.distanceFilter = 10
      locationManager.startUpdatingLocation()
    }
    
    private func updateDisplay(){
        let formattedDistance = FormatDisplay.distance(distance)
        let formattedTime = FormatDisplay.time(seconds)
        let formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerMile)
        
        distanceLabel.text = "Distance:  \(formattedDistance)"
        timeLabel.text = "Time:  \(formattedTime)"
        paceLabel.text = "Pace:  \(formattedPace)"
        
    }
    
}

extension TrackingViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
        let coordinates = [lastLocation.coordinate, newLocation.coordinate]
        trackMapView.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
        let region = MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        trackMapView.setRegion(region, animated: true)
      }
      
      locationList.append(newLocation)
    }
  }
}

// MARK: - Map View Delegate

extension TrackingViewController: MKMapViewDelegate {
  func trackMapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolygonRenderer(overlay: polyline)
    renderer.strokeColor = UIColor.blue
    renderer.lineWidth = 3
    return renderer
  }
    

}
