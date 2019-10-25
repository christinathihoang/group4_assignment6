//
//  QuestViewController.swift
//  group4_assignment6
//
//  Created by Christina Hoang on 10/21/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData

class QuestViewController: UIViewController {
    
    @IBOutlet weak var adventurerImage: UIImageView!
    @IBOutlet weak var adventurerName: UILabel!
    @IBOutlet weak var adventurerProfession: UILabel!
    @IBOutlet weak var adventurerLevel: UILabel!
    @IBOutlet weak var hpPoints: UILabel!
    @IBOutlet weak var attackPoints: UILabel!
    
    @IBOutlet weak var questLog: UITextView!
    
    var chosenAdventurer: NSManagedObject = NSManagedObject()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        adventurerName.text = chosenAdventurer.value(forKeyPath: "name") as? String
        let level:Int = chosenAdventurer.value(forKey: "level") as! Int
        adventurerLevel.text = String(level)
        adventurerProfession.text = chosenAdventurer.value(forKeyPath: "profession") as? String
        let attackModifier: Int = chosenAdventurer.value(forKeyPath: "attackModifier") as! Int
        attackPoints.text = String(attackModifier)
        let currentHP:Int = chosenAdventurer.value(forKeyPath: "currentHP") as! Int
        let totalHP:Int = chosenAdventurer.value(forKeyPath: "totalHP") as! Int
        hpPoints.text = String(currentHP) + "/" + String(totalHP)
        
        startQuestLog()
    }
    
    
    func startQuestLog() {
        questLog.text = "Beginning quest!\n"
        
        var adventurerTimer = Timer()
        var enemyTimer = Timer()
        
        var currentHP = Int(chosenAdventurer.value(forKey: "currentHP") as! Int)
        var currentLevel = Int(chosenAdventurer.value(forKey: "level") as! Int)
        let enemyCount = 0
        
        while currentHP > 0 {
            // find and attack an enemy
            let chosenEnemy = Enemy(name: "Enemy", level: 1, attackModifiers: 1, hitPoints: 1)
            
            if Int(chosenAdventurer.value(forKey: "currentHP") as! Int) <= 0 {
                return
            }
            else if chosenEnemy.hitPoints > 0 {
                questLog.text += "This is working\n"
                currentHP -= 1
                guard adventurerTimer == nil else { return }
                adventurerTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(arc4random_uniform(10)), repeats: true, block: {_ in self.attackEnemy(enemy: chosenEnemy, adventurer: self.chosenAdventurer)})
                guard enemyTimer == nil else {return}
                enemyTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(arc4random_uniform(10)), repeats: true, block: {_ in self.attackAdventurer(enemy: chosenEnemy, adventurer: self.chosenAdventurer)})
                }
                
            else if enemyCount > 2 {
                currentLevel += 1
                questLog.text += "Level Up!\n"
            }
            else if currentLevel >= 5 {
                questLog.text += "Adventurer has reached the end!\n"
                return
            }
            
        }

        }
    
    // pass in enemy and adventurer
    func attackEnemy(enemy: Enemy, adventurer: NSManagedObject) {
        let adventurerName = adventurer.value(forKey: "name") as! String
        let damage = Int(arc4random())*(adventurer.value(forKey: "attackModifier") as! Int)
        questLog.text += "\(adventurerName) attacks for \(damage) damage.\n"
        enemy.hitPoints -= damage
        if enemy.hitPoints <= 0 {
            questLog.text += "Enemy is defeated!\n"
        }
    }
    
    func attackAdventurer(enemy: Enemy, adventurer: NSManagedObject) {
        let adventurerName = adventurer.value(forKey: "name") as! String
        
        let currentLevel = Int(chosenAdventurer.value(forKey: "level") as! Int)
        var adventurerCurrentHP = adventurer.value(forKey: "currentHP") as! Int
        
        let damage = Int(arc4random())*Int(enemy.attackModifiers)
        questLog.text += "Enemy attacks for \(damage) damage.\n"
        adventurerCurrentHP -= damage
        updateData(chosenAdventurer: adventurer, currentLevel: currentLevel, currentHP: adventurerCurrentHP)
        if adventurerCurrentHP <= 0 {
            questLog.text += "\(adventurerName) has been defeated by the enemy!\n"
            updateData(chosenAdventurer: adventurer, currentLevel: currentLevel, currentHP: 0)
            return
        }
    }
    
    
    func updateData(chosenAdventurer:NSManagedObject, currentLevel:Int, currentHP: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            chosenAdventurer.setValue(currentLevel, forKey: "level")
            chosenAdventurer.setValue(currentHP, forKeyPath: "currentHP")
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
}
