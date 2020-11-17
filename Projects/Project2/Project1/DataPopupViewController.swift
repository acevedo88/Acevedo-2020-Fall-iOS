//
//  DataPopupViewController.swift
//  Project1
//
//  Created by Alexander Acevedo on 11/16/20.
//

import UIKit
import DropDown
import CoreData

class DataPopupViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dropDownMenu: UITextField!
    @IBOutlet weak var mapNameTextField: UITextField!
    @IBOutlet weak var waypointTextField: UITextField!
    @IBOutlet weak var latitiudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    var longText = ""
    var latText = ""
    var mapTypeText = ""
    var mapNameText = ""
    var waypointText = ""
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Hiking",
            "Hunting",
            "Biking",
            "Camping",
        ]
        return menu
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myView = dropDownMenu
        menu.anchorView = myView
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapItem))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        myView?.addGestureRecognizer(gesture)
        
        menu.selectionAction = {index, title in
            self.dropDownMenu.text = "\(title)"
        }
        
        latitiudeTextField.text = latText
        longitudeTextField.text = longText
        
        
    }
    
    @objc func didTapItem(){
        menu.show()
    }
    
    
    
    @IBAction func saveDataButton(_ sender: Any) {
        
        let managedObjectContainer = DatabaseController.managedObjectContainer()
        let map = Map(context: managedObjectContainer.viewContext)
        let waypoint = Waypoint(context: managedObjectContainer.viewContext)
        let location = Location(context: managedObjectContainer.viewContext)
        
        map.mapType = self.dropDownMenu.text
        mapTypeText = map.mapType!
        map.mapName = ""
        waypoint.waypointName = ""
        if let mapNameText = mapNameTextField.text, mapNameText != ""{
            map.mapName = mapNameTextField.text
            self.mapNameText = map.mapName!
        }else{
            let alertController = UIAlertController(title: "Map Name Error", message: "You must enter a Map Name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
        if let waypointText = waypointTextField.text, waypointText != ""{
            waypoint.waypointName = waypointTextField.text
            self.waypointText = waypoint.waypointName!
        }else{
            let alertController = UIAlertController(title: "Waypoint Name Error", message: "You must enter a Waypoint Name", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            self.present(alertController, animated: true, completion: nil)
        }
        location.latitude = self.latText
        location.longitude = self.longText
        
        print(map.mapType!)
        print(map.mapName!)
        print(waypoint.waypointName!)
        print(location.latitude!)
        print(location.longitude!)
        
        dismiss(animated: true)
        
    }
    
}
