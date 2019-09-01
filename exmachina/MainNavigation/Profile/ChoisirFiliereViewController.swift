//
//  ChoisirFiliereViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 06-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ChoisirFiliereViewController: UIViewController {
    
    var user = User()
    
    var facultes = [Faculte]()
    var filieres = [Filiere]()
    var semestres = [Semestre]()
    
    var faculteSelected = Faculte()
    var filiereSelected = Filiere()
    var semestreSelected = Semestre()
    
    let faculteLabel: UILabel = {
        let label = UILabel()
        label.text = "Faculté"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir-Heavy", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let faculteTextField: UITextField = {
       let text = UITextField()
        text.text = "Sélectionner la faculté"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor.black
        text.font = UIFont(name: "Avenir", size: 24)
        text.textColor = UIColor(named: "exmachina")
    
        return text
    }()
    
    let facultePicker: UIPickerView = {
       let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .black
        
        return picker
    }()
    
    let filiereLabel: UILabel = {
        let label = UILabel()
        label.text = "Filière"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir-Heavy", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let filiereTextField: UITextField = {
        let text = UITextField()
        text.text = "Sélectionner la filière"
        text.textColor = UIColor.black
        text.font = UIFont(name: "Avenir", size: 24)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor(named: "exmachina")
        
        
        return text
    }()
    
    let filierePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .black
        
        return picker
    }()
    
    let semestreLabel: UILabel = {
        let label = UILabel()
        label.text = "Semestre"
        label.textColor = UIColor.black
        label.font = UIFont(name: "Avenir-Heavy", size: 24)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let semestreTextField: UITextField = {
        let text = UITextField()
        text.text = "Sélectionner le semestre"
        text.textColor = UIColor.black
        text.font = UIFont(name: "Avenir", size: 24)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor(named: "exmachina")
        
        return text
    }()
    
    let semestrePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .black
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        faculteTextField.text = user.faculte.facId
        filiereTextField.text = user.filiere.fid
        semestreTextField.text = user.semestre.sid
        getFacultes()
        setupTabBar()
        setupLayout()
        facultePicker.delegate = self
        filierePicker.delegate = self
        semestrePicker.delegate = self
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Choix de la filière"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupLayout() {
        
        self.view.addSubview(faculteLabel)
        self.view.addSubview(faculteTextField)
        self.view.addSubview(filiereLabel)
        self.view.addSubview(filiereTextField)
        self.view.addSubview(semestreLabel)
        self.view.addSubview(semestreTextField)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = .blackTranslucent
        toolbar.tintColor = .white
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(ChoisirFiliereViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        
        faculteLabel.topAnchor.constraint(equalTo: self.view.safeTopAnchor, constant: 30).isActive = true
        faculteLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        faculteTextField.topAnchor.constraint(equalTo: self.faculteLabel.bottomAnchor, constant: 30).isActive = true
        faculteTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        faculteTextField.inputView = facultePicker
        faculteTextField.inputAccessoryView = toolbar
        
        filiereLabel.topAnchor.constraint(equalTo: self.faculteTextField.bottomAnchor, constant: 30).isActive = true
        filiereLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        filiereTextField.topAnchor.constraint(equalTo: self.filiereLabel.bottomAnchor, constant: 30).isActive = true
        filiereTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        filiereTextField.inputView = filierePicker
        filiereTextField.inputAccessoryView = toolbar
        
        semestreLabel.topAnchor.constraint(equalTo: self.filiereTextField.bottomAnchor, constant: 30).isActive = true
        semestreLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        semestreTextField.topAnchor.constraint(equalTo: self.semestreLabel.bottomAnchor, constant: 30).isActive = true
        semestreTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        semestreTextField.inputView = semestrePicker
        semestreTextField.inputAccessoryView = toolbar
        
    }
    
    func getFacultes() {
        self.facultes.removeAll()
        let ref = Database.database().reference().child("data").child("faculte")
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var faculte = Faculte()
                faculte.titre = (dictionary["titre"] as! String?)!
                faculte.facId = (dictionary["facId"] as! String?)!
                
                self.facultes.append(faculte)
            }
        }, withCancel: nil)
        
    }
    
    func getFilieres() {
        self.filieres.removeAll()
        let ref = Database.database().reference().child("data").child("faculte").child(faculteSelected.facId).child("liste")
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var filiere = Filiere()
                filiere.titre = (dictionary["titre"] as! String?)!
                filiere.fid = (dictionary["fid"] as! String?)!
                
                self.filieres.append(filiere)
            }
        }, withCancel: nil)
    }
    
    func getSemestres() {
        self.semestres.removeAll()
        let ref = Database.database().reference().child("data").child("faculte").child(faculteSelected.facId).child("liste").child(filiereSelected.fid).child("liste")
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var semestre = Semestre()
                semestre.titre = (dictionary["titre"] as! String?)!
                semestre.sid = (dictionary["sid"] as! String?)!
                
                self.semestres.append(semestre)
            }
        }, withCancel: nil)
    }
    
    func saveFaculte() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
         ref.updateChildValues(["faculte": faculteSelected.facId])
    }
    
    func saveFiliere() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.updateChildValues(["filiere": filiereSelected.fid])
    }
    
    func saveSemestre() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.updateChildValues(["semestre": semestreSelected.sid])
    }
}
