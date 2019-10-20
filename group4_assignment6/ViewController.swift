//
//  ViewController.swift
//  group4_assignment6
//
//  Created by Geneivie Nguyen on 10/16/19.
//  Copyright © 2019 cs329e. All rights reserved.
//

import UIKit
import CoreData

class AdventurerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var adventurerImage: UIImageView!
}


class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(adventurers)
        
    }

    //saves character
    @IBAction func saveButton(_ sender: UIButton) {
        
        if(nameTextField.text! != "" && classTextField.text! != "") {
            
            self.save(name: nameTextField.text!, profession: classTextField.text!)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as IndexPath) as! AdventurerCollectionViewCell
        
        
        
        return cell
    }
    
    //creates character
    func save(name: String, profession: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Adventurer", in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        //initializes attributes
        person.setValue(name, forKeyPath: "name")
        person.setValue(profession, forKeyPath: "profession")
        person.setValue(1, forKeyPath: "level")
        person.setValue(10, forKeyPath: "currentHP")
        person.setValue(10, forKeyPath: "totalHP")
        person.setValue(5, forKeyPath: "attackModifier")
        
        do {
            try managedContext.save()
            adventurers.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    
}

