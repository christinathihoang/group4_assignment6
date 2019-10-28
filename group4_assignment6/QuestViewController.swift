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
        let attackModifier: Double = chosenAdventurer.value(forKeyPath: "attackModifier") as! Double
        attackPoints.text = String(format: "%.2f", attackModifier)
        let currentHP:Int = chosenAdventurer.value(forKeyPath: "currentHP") as! Int
        let totalHP:Int = chosenAdventurer.value(forKeyPath: "totalHP") as! Int
        hpPoints.text = String(currentHP) + "/" + String(totalHP)
        adventurerImage.image = UIImage(named: chosenAdventurer.value(forKeyPath: "portrait") as! String)
        
        startQuestLog()
    }
    
    
    func startQuestLog() {
        questLog.text = "Beginning quest!\n"
        
        var adventurerTimer = Timer()
        var enemyTimer = Timer()
        
        var currentHP = Int(chosenAdventurer.value(forKey: "currentHP") as! Int)
        var currentLevel = Int(chosenAdventurer.value(forKey: "level") as! Int)
        let enemyCount = 0
        
        outerloop: while currentHP > 0 {
            
            // find and attack an enemy
            // i think this needs to go somewhere else
            let chosenEnemy = Enemy(name: "Enemy", level: 1, attackModifiers: 1, hitPoints: 1)
            
            innerloop: while chosenEnemy.hitPoints > 0 {
                
                guard adventurerTimer == nil else { return }
                adventurerTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(arc4random_uniform(10)), repeats: true, block: {_ in self.attackEnemy(enemy: chosenEnemy, currentHP: currentHP)})
                
                guard enemyTimer == nil else {return}
                enemyTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(arc4random_uniform(10)), repeats: true, block: {_ in self.attackAdventurer(enemy: chosenEnemy, currentHP: currentHP)})
                }
            if currentHP <= 0 {
                adventurerTimer.invalidate()
                enemyTimer.invalidate()
                break outerloop
            }
                
            else if enemyCount > 2 {
                currentLevel += 1
                questLog.text += "Level Up!\n"
            }
            else if currentLevel >= 5 {
                questLog.text += "Adventurer has reached the end!\n"
                adventurerTimer.invalidate()
                enemyTimer.invalidate()
                break outerloop
            }
            
        }

        }
    
    func attackEnemy(enemy: Enemy, currentHP: Int) {
        let adventurerName = chosenAdventurer.value(forKey: "name") as! String
        let damage = Int(Double.random(in: 1...30)*(chosenAdventurer.value(forKey: "attackModifier") as! Double))
        questLog.text += "\(adventurerName) attacks for \(damage) damage.\n"
        enemy.hitPoints -= damage
        if enemy.hitPoints <= 0 {
            questLog.text += "Enemy is defeated!\n"
        }
    }
    
    func attackAdventurer(enemy: Enemy, currentHP: Int) {
        let adventurerName = chosenAdventurer.value(forKey: "name") as! String
        let damage = Int(Double.random(in: 1...30)*Double(enemy.attackModifiers))
        questLog.text += "Enemy attacks for \(damage) damage.\n"
        var newCurrentHP = currentHP - damage
        if newCurrentHP <= 0 {
            questLog.text += "\(adventurerName) has been defeated by the enemy!\n"
            newCurrentHP = 0
        }
        //currentHP = newCurrentHP
    }
    
    
    
    func updateData(chosenAdventurer:NSManagedObject, currentLevel:Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        do {
            chosenAdventurer.setValue(currentLevel, forKey: "level")
            try managedContext.save()
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
    }
    
}
