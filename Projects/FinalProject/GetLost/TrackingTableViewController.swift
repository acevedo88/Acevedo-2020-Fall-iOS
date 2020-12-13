//
//  TrackingTableViewController.swift
//  GetLost
//
//  Created by Alexander Acevedo on 12/12/20.
//

import UIKit
import CoreData

class TrackingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var runs: [Run] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do{
            fetchData()
            tableView.reloadData()
        }catch let err{
            print(err)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = runs[indexPath.row]
        let formatedDate = name.timestamp!
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.YYY"
        let date = formater.string(from: formatedDate)
        let newName = name.name!
        print(newName)
        cell.textLabel?.text = "Name:  \(newName)      Date: \(date)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            runs.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func fetchData(){
        let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            runs = try contex.fetch(Run.fetchRequest())
        }catch{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DataViewController
        let indexPath = tableView.indexPathForSelectedRow!
        destination.runs = runs[indexPath.row]
    }
    


}


