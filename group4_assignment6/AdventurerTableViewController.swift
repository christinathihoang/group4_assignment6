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
var adventurer: NSManagedObject = NSManagedObject()

class AdventurerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetch core data here
        fetchData()
   

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adventurers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let adventurer = adventurers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdventurerCell", for: indexPath) as! AdventurerTableViewCell
        
        cell.adventurerName?.text = adventurer.value(forKeyPath: "name") as? String
        let level:Int = adventurer.value(forKey: "level") as! Int
        cell.adventurerLevel?.text = String(level)
        cell.adventurerProfession?.text = adventurer.value(forKeyPath: "profession") as? String
        let attackModifier: Int = adventurer.value(forKeyPath: "attackModifier") as! Int
        cell.attackPoints?.text = String(attackModifier)
        let currentHP:Int = adventurer.value(forKeyPath: "currentHP") as! Int
        let totalHP:Int = adventurer.value(forKeyPath: "totalHP") as! Int
        cell.hpPoints?.text = String(currentHP) + "/" + String(totalHP)
        //cell.adventurerImage?.image = adventurer.value(forKeyPath: "portrait") as? UIImage

        return cell
    }
    
    // MARK - function to fetch core data
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)
            adventurers = fetchedResults
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func fetchAdventurer(name:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToSelect:NSManagedObject = test[0]
            adventurer = objectToSelect
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteAdventurer(name:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0]
            managedContext.delete(objectToDelete)
            do {
                try managedContext.save()
            } catch { print(error)
                
            }
        } catch {
            print (error)
        }
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let presenter = segue.destination as? QuestViewController {
            let selectedCharacter = tableView.indexPathForSelectedRow!.row
            presenter.chosenAdventurer = adventurers[selectedCharacter]
        }
    }
    
    
    @IBAction func unwindToAdventurerTableView(sender: UIStoryboardSegue) {
        //tableView.reloadData()
    }
 
    
}
