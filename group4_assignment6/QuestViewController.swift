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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up adventurer stats
        adventurerName.text = chosenAdventurer.value(forKeyPath: "name") as? String
        let level:Int = chosenAdventurer.value(forKey: "level") as! Int
        adventurerLevel.text = String(level)
        adventurerProfession.text = chosenAdventurer.value(forKeyPath: "profession") as? String
        let attackModifier: Int = chosenAdventurer.value(forKeyPath: "attackModifier") as! Int
        attackPoints.text = String(attackModifier)
        let currentHP:Int = chosenAdventurer.value(forKeyPath: "currentHP") as! Int
        let totalHP:Int = chosenAdventurer.value(forKeyPath: "totalHP") as! Int
        hpPoints.text = String(currentHP) + "/" + String(totalHP)
    }
    
    
    func startQuestLog() {
        questLog.text = "Beginning quest..."
        // select an enemy and attack
        let chosenEnemy = Enemy(name: "Enemy", level: 5, attackModifiers: 5, hitPoints: 5)
        // start timer
        //randomTimeInterval = Int(arc4random(4))
        let adventurerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in self.attackEnemy(enemy: chosenEnemy, adventurer: self.chosenAdventurer)
        }
        let enemyTime = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {_ in self.attackAdventurer(enemy: chosenEnemy, adventurer: self.chosenAdventurer)
        }
        
        
        }
        
    
    // pass in enemy and adventurer
    func attackEnemy(enemy: Enemy, adventurer: NSManagedObject) {
        let adventurerName = adventurer.value(forKey: "name") as! String
        let damage = Int(arc4random())*(adventurer.value(forKey: "attackModifier") as! Int)
        questLog.text += String(adventurerName) + "attacks for" + String(damage) + "damage"
        enemy.hitPoints -= damage
        if enemy.hitPoints <= 0 {
            questLog.text += "Enemy is defeated!"
        }
        
    }
    
    func attackAdventurer(enemy: Enemy, adventurer: NSManagedObject) {
        let enemyName = enemy.name
        let adventurerName = adventurer.value(forKey: "name") as! String
        let adventurerCurrentHP = adventurer.value(forKey: "currentHP") as! Int
        let damage = Int(arc4random())*Int(enemy.attackModifiers)
        questLog.text += String(enemyName) + "attacks for" + String(damage) + "damage"
        //Int(adventurer.value(forKey: "currentHP") as! Int) -= Int(damage)
        if adventurerCurrentHP <= 0 {
            questLog.text += String(adventurerName) + "has been defeated by the enemy!"
        }
        
    }
    
}
