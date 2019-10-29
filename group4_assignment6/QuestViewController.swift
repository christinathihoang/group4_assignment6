//
//  QuestViewController.swift
//  group4_assignment6
//
//  Created by Christina Hoang on 10/21/19.
//  Copyright © 2019 cs329e. All rights reserved.
//


//NOT MINE
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
        //adventurerImage.image = UIImage(named: chosenAdventurer.value(forKeyPath: "portrait") as! String)
        
        startQuestLog()
    }
    
    lazy var currentHP = Int(chosenAdventurer.value(forKey: "currentHP") as! Int)
    lazy var currentLevel = Int(chosenAdventurer.value(forKey: "level") as! Int)
    var enemyCount = 0
    
    var adventurerTimer = Timer()
    var enemyTimer = Timer()
    
    var chosenEnemy = Enemy(name: "Enemy", level: Int(arc4random_uniform(5)), attackModifiers: Double.random(in: 1...10), hitPoints: Int.random(in: 1...200))
    
    func startQuestLog() {
        questLog.text = "Beginning quest!\n"
                
        guard adventurerTimer == nil else { return }
        adventurerTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(arc4random_uniform(10)), repeats: true, block: {_ in self.attackEnemy()})
            
        guard enemyTimer == nil else {return}
        enemyTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(arc4random_uniform(10)), repeats: true, block: {_ in self.attackAdventurer()})
        }
    
    
    func attackEnemy() {
        let adventurerName = chosenAdventurer.value(forKey: "name") as! String
        
        let damage = Int(Double.random(in: 1...5)*(chosenAdventurer.value(forKey: "attackModifier") as! Double))
        questLog.text += "\(adventurerName) attacks for \(damage) damage.\n"
        chosenEnemy.hitPoints -= damage
        
        if chosenEnemy.hitPoints <= 0 {
            enemyCount += 1
            questLog.text += "Enemy \(enemyCount) is defeated!\n"
            chosenEnemy = Enemy(name: "Enemy", level: Int(arc4random_uniform(5)), attackModifiers: Double.random(in: 1...10), hitPoints: Int.random(in: 1...200))
            enemyTimer.invalidate()
        }
        if enemyCount%2 == 0 {
            currentLevel += 1
            adventurerLevel.text = String(currentLevel)
            questLog.text += "Level Up!\n"
            updateData(chosenAdventurer: chosenAdventurer, currentLevel: currentLevel)
        }
        
        if currentLevel >= 10 {
            questLog.text += "Adventurer has reached the end!\n"
            adventurerTimer.invalidate()
            enemyTimer.invalidate()
        }
    }
    
       func attackAdventurer() {
        let adventurerName = chosenAdventurer.value(forKey: "name") as! String
        let damage = Int(Double.random(in: 1...5)*Double(chosenEnemy.attackModifiers))
        questLog.text += "Enemy attacks for \(damage) damage.\n"
        currentHP -= damage
        if currentHP <= 0 {
            questLog.text += "\(adventurerName) has been defeated by the enemy!\n End game!"
            hpPoints.text = "0"
            adventurerTimer.invalidate()
            enemyTimer.invalidate()
        }
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
