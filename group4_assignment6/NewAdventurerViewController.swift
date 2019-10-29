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
    @IBOutlet weak var imageCollectionView: UICollectionView!
    

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
    
    let characterImages = ["character1","character2","character3","character4","character5","character6","character7"]

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characterImages.count
    }
    
    var selectedImage = 0
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! AdventurerCollectionViewCell
        cell.adventurerImage?.image = UIImage(named: characterImages[indexPath.row])
        
        if cell.isSelected {
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.borderWidth = 2.0
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 0.0
        }
        
        selectedImage = indexPath.row
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.blue.cgColor
        cell?.layer.borderWidth = 1
        cell?.isSelected = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
        cell?.layer.borderWidth = 1
        cell?.isSelected = false
    }
    
    
    
    //creates and saves new character to Core Data
    func saveNewCharacter(name: String, profession: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Adventurer", in: managedContext)! 
        let character = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let hp = Int.random(in: 1...200)
        let att = Double.random(in: 1...10)
        
        //initializes attributes
        character.setValue(name, forKeyPath: "name")
        character.setValue(profession, forKeyPath: "profession")
        character.setValue(1, forKeyPath: "level")
        character.setValue(hp, forKeyPath: "currentHP")
        character.setValue(hp, forKeyPath: "totalHP")
        character.setValue(att, forKeyPath: "attackModifier")
        
        character.setValue(characterImages[selectedImage], forKeyPath: "portrait")
        
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
 
    
}
