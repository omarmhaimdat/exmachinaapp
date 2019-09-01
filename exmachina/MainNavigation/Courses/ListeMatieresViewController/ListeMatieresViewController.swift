//
//  ListeMatieresViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 31-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import BouncyLayout

class ListeMatieresViewController: UIViewController {
    
    let cellId = "cellId"
    var matieres = [Matiere]()
    var filiere = Filiere()
    var semestre = Semestre()
    
    let newCollection: UICollectionView = {
        
        let layout = BouncyLayout(style: .regular)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMatiere()
        setupTabBar()
        setupCollection()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "\(self.filiere.fid) | \(self.semestre.sid)"
        //        self.navigationController?.navigationBar.tintColor = UIColor(named: "exmachina")
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        //        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "exmachina")!]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func setupCollection() {
        
        self.view.addSubview(newCollection)
        
        newCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newCollection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        newCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        newCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    fileprivate func setupCollectionView() {
        newCollection.backgroundColor = .white
        newCollection.register(CoursesFacultyViewCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    fileprivate func getMatiere() {
        
        let ref = Database.database().reference().child("facultes").child("liste").child(self.filiere.fid).child("liste").child(self.semestre.sid).child("liste")
        self.matieres.removeAll()
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var matiere = Matiere()
                matiere.titre = (dictionary["titre"] as! String?)!
                matiere.mid = (dictionary["mid"] as! String?)!
                
                self.matieres.append(matiere)
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                })
                
            }
        }, withCancel: nil)
    }
}
