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
    var filieres = [Filiere]()
    
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
        getFilieres()
        setupLoadingControl()
        setupCollection()
        setupCollectionView()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Choisir la faculte"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
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
    
    private func remplirFaculte() {
        var ING = Faculte()
        var FSS = Faculte()
        var FCG = Faculte()
        
        ING.facId = "ING"
        ING.titre = "Ingénierie"
        
        FSS.facId = "FSS"
        FSS.titre = "Sciences de la santé"
        
        FCG.facId = "FCG"
        FCG.titre = "Commerce et gestion"
        
        self.facultes.append(ING)
        self.facultes.append(FSS)
        self.facultes.append(FCG)
    }
    
    func getFilieres() {
        
        let ref = Database.database().reference()
        self.filieres.removeAll()
        ref.child("facultes").child("liste").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var filiere = Filiere()
                filiere.titre = (dictionary["titre"] as! String?)!
                filiere.fid = (dictionary["fid"] as! String?)!
                
                if filiere.fid == "CPI-1" {
                    filiere.colorOne = #colorLiteral(red: 0.3843137255, green: 0.4470588235, blue: 0.4823529412, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "CPI-2" {
                    filiere.colorOne = #colorLiteral(red: 0.5058823529, green: 0.6117647059, blue: 0.662745098, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GC-1" {
                    filiere.colorOne = #colorLiteral(red: 0.6117647059, green: 0.4705882353, blue: 0.4235294118, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.2509803922, green: 0.1411764706, blue: 0.1019607843, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GC-2" {
                    filiere.colorOne = #colorLiteral(red: 0.7450980392, green: 0.6117647059, blue: 0.568627451, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3725490196, green: 0.262745098, blue: 0.2235294118, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GIND-1" {
                    filiere.colorOne = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.262745098, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.8470588235, green: 0.262745098, blue: 0.08235294118, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GIND-2" {
                    filiere.colorOne = #colorLiteral(red: 1, green: 0.5176470588, blue: 0.2980392157, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.9568627451, green: 0.3176470588, blue: 0.1176470588, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GINF-1" {
                    filiere.colorOne = #colorLiteral(red: 0.3764705882, green: 0.6784313725, blue: 0.368627451, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.1803921569, green: 0.4901960784, blue: 0.1960784314, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GINF-2" {
                    filiere.colorOne = #colorLiteral(red: 0.5215686275, green: 0.7333333333, blue: 0.3607843137, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3333333333, green: 0.5450980392, blue: 0.1843137255, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "MIAGE-1" {
                    filiere.colorOne = #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3176470588, green: 0.1764705882, blue: 0.6588235294, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "MIAGE-2" {
                    filiere.colorOne = #colorLiteral(red: 0.8196078431, green: 0.768627451, blue: 0.9137254902, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.4862745098, green: 0.3019607843, blue: 1, alpha: 1)
                    self.filieres.append(filiere)
                } else {
                    filiere.colorOne = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
                    self.filieres.append(filiere)
                }
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                    self.activityIndicatorView.stopAnimating()
                })
            }
        }, withCancel: nil)
    }
    
}
