//
//  ConfirmationViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 14-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import AppleWelcomeScreen

class ConfirmationViewController: UIViewController {
    
    var faculte = Faculte()
    var filiere = Filiere()
    var semestre = Semestre()
    
    let labelFaculte: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Avenir-Medium", size: 40)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        return label
    }()
    
    let labelFiliere: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Avenir-Medium", size: 40)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        return label
    }()
    
    let labelSemestre: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont(name: "Avenir-Medium", size: 40)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        return label
    }()
    
    let barreDonnees: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = CGFloat(exactly: 15)!
        
        return stackView
    }()
    
    let confirmation: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Confirmer", for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.layer.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 25)
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.layer.shadowOffset = CGSize(width: 1, height: 5)
        btn.layer.cornerRadius = 10
        btn.layer.shadowRadius = 8
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.addTarget(self, action: #selector(buttonToConfirm), for: .touchUpInside)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupLayout()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Confirmation"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupLayout() {
//        self.view.addSubview(labelFaculte)
//        self.view.addSubview(labelFiliere)
//        self.view.addSubview(labelSemestre)
        
        
        self.barreDonnees.addArrangedSubview(labelFaculte)
        self.barreDonnees.addArrangedSubview(labelFiliere)
        self.barreDonnees.addArrangedSubview(labelSemestre)
        self.view.addSubview(barreDonnees)
        self.view.addSubview(confirmation)
        
//        labelFaculte.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 50).isActive = true
//        labelFaculte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelFaculte.text = self.faculte.facId
//
//        labelFiliere.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        labelFiliere.topAnchor.constraint(equalTo: labelFaculte.bottomAnchor, constant: 50).isActive = true
        labelFiliere.text = self.filiere.fid
//
//        labelSemestre.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        labelSemestre.topAnchor.constraint(equalTo: labelFiliere.bottomAnchor, constant: 50).isActive = true
        labelSemestre.text = self.semestre.sid
        
        barreDonnees.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 80).isActive = true
        barreDonnees.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        barreDonnees.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        barreDonnees.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        confirmation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/5.5).isActive = true
        confirmation.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        confirmation.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    @objc func buttonToConfirm() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.updateChildValues(["ajoutFiliere": true])
        
        dismiss(animated: true, completion: nil)
    }
    
}
