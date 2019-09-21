//
//  ChoisirFaculteViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 14-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView
import BouncyLayout

class ChoisirFaculteViewController: UIViewController {
    
    var facultes = [Faculte]()
    var filieresING = [Filiere]()
    var filieresFSS = [Filiere]()
    var filieresFCG = [Filiere]()
    
    let cellId = "cellId"
    
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
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        remplirFaculte()
//        getFilieres()
        setupLoadingControl()
        setupCollection()
        setupCollectionView()
    }
    
    func setupTabBar() {
        navigationItem.title = "Choisir la faculte"
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = UIColor.white
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.isHidden = false
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.barTintColor = .systemBackground
             navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.barTintColor = .lightText
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.label]
        } else {
            navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        }
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.backgroundColor = .white
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func setupLoadingControl() {
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    fileprivate func setupCollection() {
        
        self.view.addSubview(newCollection)
        if #available(iOS 13.0, *) {
            newCollection.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            newCollection.backgroundColor = UIColor.white
        }
        
        newCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newCollection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        newCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        newCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    fileprivate func setupCollectionView() {
        newCollection.register(CoursesFacultyViewCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    private func remplirFaculte() {
        var ING = Faculte()
        var FSS = Faculte()
        var FCG = Faculte()
        
        ING.facId = "ING"
        ING.titre = "Ingénierie"
        self.getFilieres(facId: ING.facId)
        
        FSS.facId = "FSS"
        FSS.titre = "Sciences de la santé"
        self.getFilieres(facId: FSS.facId)
        
        FCG.facId = "FCG"
        FCG.titre = "Commerce et gestion"
        self.getFilieres(facId: FCG.facId)
        
        self.facultes.append(ING)
        self.facultes.append(FSS)
        self.facultes.append(FCG)
    }
    
    func getFilieres(facId: String) {
        
        let ref = Database.database().reference()
//        self.filieresING.removeAll()
//        self.filieresFSS.removeAll()
//        self.filieresFCG.removeAll()
        ref.child("faculte").child("liste").child(facId).child("liste").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var filiere = Filiere()
                filiere.titre = dictionary["titre"] as? String ?? ""
                filiere.fid = dictionary["fid"] as? String ?? ""
                filiere.colorOne = UIColor(hexString: (dictionary["colorOne"] as? String ?? "#d5c100"))
                filiere.colorTwo = UIColor(hexString: (dictionary["colorTwo"] as? String ?? "#d5c100"))
                
                if facId == "ING" {
                    self.filieresING.append(filiere)
                } else if facId == "FSS" {
                    self.filieresFSS.append(filiere)
                } else {
                    self.filieresFCG.append(filiere)
                }
                
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                    self.activityIndicatorView.stopAnimating()
                })
            }
        }, withCancel: nil)
    }
    
}
