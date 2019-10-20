//
//  AdventurerTableViewController.swift
//  group4_assignment6
//
//  Created by Geneivie Nguyen on 10/18/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData

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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Adventurer")
        
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


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let adventurer = adventurers[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "AdventurerCell", for: indexPath) as! AdventurerTableViewCell
        
        cell.adventurerName?.text = adventurer.value(forKeyPath: "name") as? String
        cell.adventurerLevel?.text = adventurer.value(forKeyPath: "level") as? String
        cell.adventurerProfession?.text = adventurer.value(forKeyPath: "profession") as? String
        cell.attackPoints?.text = adventurer.value(forKeyPath: "attackModifier") as? String
        cell.hpPoints?.text = adventurer.value(forKeyPath: "currentHP") as? String //+ "/" + adventurers.value(forKeyPath: "totalHP") as? String
        cell.adventurerImage?.image = adventurer.value(forKeyPath: "portrait") as? UIImage

        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
