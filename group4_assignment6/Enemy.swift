//
//  Enemy.swift
//  group4_assignment6
//
//  Created by Christina Hoang on 10/21/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit

class Enemy {
    var name: String
    var level: Int
    var attackModifiers: Double
    var hitPoints: Int
    
    init (name:String, level: Int, attackModifiers: Double, hitPoints: Int) {
        self.name = name
        self.level = level
        self.attackModifiers = attackModifiers
        self.hitPoints = hitPoints
    }
    
}
