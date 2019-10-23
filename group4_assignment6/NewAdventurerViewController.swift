//
//  ViewController.swift
//  group4_assignment6
//
//  Created by Geneivie Nguyen on 10/16/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData
import os.log

class AdventurerCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var adventurerImage: UIImageView!

}


class NewAdventurerViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //saves character
    @IBAction func saveButton(_ sender: UIButton) {
        if(nameTextField.text! != "" && classTextField.text! != "") {
            saveNewCharacter(name: nameTextField.text!, profession: classTextField.text!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    let characterImages = ["character1","character2","character3"]

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! AdventurerCollectionViewCell
        cell.adventurerImage?.image = UIImage(named: "character1")
    
        return cell
    }
    
    //creates and saves new character to Core Data
    func saveNewCharacter(name: String, profession: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Adventurer", in: managedContext)! 
        let character = NSManagedObject(entity: entity, insertInto: managedContext)
        
        //initializes attributes
        character.setValue(name, forKeyPath: "name")
        character.setValue(profession, forKeyPath: "profession")
        character.setValue(1, forKeyPath: "level")
        character.setValue(10, forKeyPath: "currentHP")
        character.setValue(10, forKeyPath: "totalHP")
        character.setValue(5, forKeyPath: "attackModifier")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
 
    
}

