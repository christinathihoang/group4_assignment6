//
//  QuestViewController.swift
//  group4_assignment6
//
//  Created by Christina Hoang on 10/21/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {
    @IBOutlet weak var adventurerImage: UIImageView!
    @IBOutlet weak var adventurerName: UILabel!
    @IBOutlet weak var adventurerProfession: UILabel!
    @IBOutlet weak var adventurerLevel: UILabel!
    @IBOutlet weak var hpPoints: UILabel!
    @IBOutlet weak var attackPoints: UILabel!
    
    @IBOutlet weak var questLog: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func startQuestLog() {
        questLog.text = "Beginning quest..."
        // select an enemy and attack
        let enemy = Enemy(name: "Enemy", level: 5, attackModifiers: 5, hitPoints: 5)
        // start timer
        //timer = Timer.scheduledTimer(timeInterval: [time interval], target: self, selector: attackEnemy(), userInfo: nil, repeats: true)
        
        
        // if enemy defeated, then level up
    }
    
    // pass in enemy and adventurer
    func attackEnemy(enemy: Enemy, adventurer: String) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is QuestViewController {
            
        }
    }
}
