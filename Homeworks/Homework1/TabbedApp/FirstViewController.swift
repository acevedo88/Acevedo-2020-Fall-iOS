//
//  FirstViewController.swift
//  TabbedApp
//
//  Created by Alexander Acevedo on 9/7/20.
//  Copyright © 2020 Stasis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    @IBOutlet weak var labelOutlet: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func concatButtonTapped(_ sender: Any) {
        let concatString = "Hello \(firstNameOutlet.text!) \(lastNameOutlet.text!), welcome to the App!"
        
        labelOutlet.text = concatString
    }
    
}

