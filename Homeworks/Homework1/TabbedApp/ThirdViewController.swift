//
//  ThirdViewController.swift
//  TabbedApp
//
//  Created by Alexander Acevedo on 9/8/20.
//  Copyright © 2020 Stasis. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var startButton: UIButton!
    
    var hours = 0
    var seconds = 0
    var minutes = 0
    var lappedTime:[String] = []
    
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
    }
    
    func resetTimer(){
        
        hours = 0
        seconds = 0
        minutes = 0
        lappedTime = []
        timer.invalidate()
        secondLabel.text = "00"
        minLabel.text = "00"
        hourLabel.text = "00"
        tableView.reloadData()
        
    }

    @IBAction func startTapped(_ sender: Any) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func count(){
        
        seconds += 1
        
        if seconds == 60{
            minutes += 1
            seconds = 0
        }

        if minutes == 60{
            minutes = 0
            seconds = 0
            hours += 1
        }
        
        if hours == 24{
            resetTimer()
        }
        
        secondLabel.text = "\(seconds)"
        minLabel.text = minutes == 0 ? "00" : "\(minutes)"
        hourLabel.text = hours == 0 ? "00" : "\(hours)"
    }
    
    @IBAction func pauseTapped(_ sender: Any) {
        
        timer.invalidate()
        
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        
        resetTimer()
        
    }
    @IBAction func lapTapped(_ sender: Any) {
        
        let currentTime = "\(hours): \(minutes):\(seconds)"
        lappedTime.append(currentTime)
        
        let indexPath = IndexPath(row: lappedTime.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        
    }
    
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lappedTime.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapCell", for: indexPath)
        cell.textLabel?.text = lappedTime[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            lappedTime.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}
