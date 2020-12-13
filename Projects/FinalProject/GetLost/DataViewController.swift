//
//  DataViewController.swift
//  GetLost
//
//  Created by Alexander Acevedo on 12/12/20.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var trackTimeLabel: UILabel!
    
    
    var runs: Run!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = runs.name
        distanceLabel.text = "Distance: " + FormatDisplay.distance(runs.distance)
        let bestDistance = Measurement(value: runs.distance, unit: UnitLength.meters)
        let bestPace = FormatDisplay.pace(distance: bestDistance,
                                          seconds: Int(runs.duration),
                                          outputUnit: UnitSpeed.minutesPerMile)
        let time = FormatDisplay.time(Int(runs.duration))
        
        paceLabel.text = "Pace: " + bestPace
        
        trackTimeLabel.text = "Time: " + time

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
