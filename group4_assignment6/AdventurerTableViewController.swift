//
//  AdventurerTableViewController.swift
//  group4_assignment6
//
//  Created by Geneivie Nguyen on 10/18/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData
import os.log


class AdventurerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adventurerImage: UIImageView!
    @IBOutlet weak var adventurerName: UILabel!
    @IBOutlet weak var adventurerProfession: UILabel!
    @IBOutlet weak var adventurerLevel: UILabel!
    @IBOutlet weak var hpPoints: UILabel!
    @IBOutlet weak var attackPoints: UILabel!
    
}

var adventurers: [NSManagedObject] = []

class AdventurerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        do {
            adventurers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return adventurers.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventurer = adventurers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdventurerCell", for: indexPath) as! AdventurerTableViewCell
        
        cell.adventurerName?.text = adventurer.value(forKeyPath: "name") as? String
        cell.adventurerLevel?.text = adventurer.value(forKeyPath: "level") as? String
        cell.adventurerProfession?.text = adventurer.value(forKeyPath: "profession") as? String
        cell.attackPoints?.text = adventurer.value(forKeyPath: "attackModifier") as? String
        cell.hpPoints?.text = adventurer.value(forKeyPath: "currentHP") as? String //+ "/" + adventurers.value(forKeyPath: "totalHP") as? String
        //cell.adventurerImage?.image = adventurer.value(forKeyPath: "portrait") as? UIImage

        return cell
    }
    
    // MARK - Formatting
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addMemberSegue"
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 */
    
    
    @IBAction func unwindToAdventurersTableView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewAdventurerViewController {
            let person = sourceViewController.newPerson!
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: adventurers.count, section: 0)
            
            adventurers.append(person)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
}
