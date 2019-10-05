//
//  MesCoursViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 09-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import BouncyLayout
import FirebaseAuth
import NVActivityIndicatorView
import SwiftEntryKit

class MesCoursViewController: UIViewController {
    
    internal var user = User()
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
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ajouter la filiere dans la page profile"
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .center
        label.numberOfLines = 2
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        setupTabBar()
        setupCollection()
        setupCollectionView()
        setupLoadingControl()
        activityIndicatorView.startAnimating()
        
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
        navigationItem.title = "Mes cours"
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
        return .lightContent
    }
    
    func filiereNotConfigured() {
        self.view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
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
    
    private func getCurrentUser() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var user = User()
                user.dateDeCreation = dictionary["dateDeCreation"] as? String ?? ""
                user.email = dictionary["email"] as? String ?? ""
                user.name = dictionary["name"] as? String ?? ""
                user.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
                user.provider = dictionary["provider"] as? String ?? ""
                user.filiere.fid = dictionary["filiere"] as? String ?? ""
                user.semestre.sid = dictionary["semestre"] as? String ?? ""
                user.faculte.facId = dictionary["faculte"] as? String ?? ""
                user.ajoutFaculte = dictionary["ajoutFiliere"] as? Bool ?? true
                user.new = dictionary["newUser"] as? Bool ?? false
                self.user = user
                self.getFiliere()
            }

        }, withCancel: nil)
    }
    
    private func getFiliere() {
        let ref = Database.database().reference().child("faculte").child("liste").child(self.user.faculte.facId).child("liste").child(self.user.filiere.fid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    var filiere = Filiere()
                    filiere.titre = dictionary["titre"] as? String ?? ""
                    filiere.fid = dictionary["fid"] as? String ?? ""
                    filiere.colorOne = UIColor(hexString: (dictionary["colorOne"] as? String ?? "#d5c100"))
                    filiere.colorTwo = UIColor(hexString: (dictionary["colorTwo"] as? String ?? "#d5c100"))

                    self.filiere = filiere
                    self.getMatiere()
                    print("exists filiere")
                }
            } else {
                let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                var themeImage: EKPopUpMessage.ThemeImage?
                var attributes = EKAttributes()
                attributes.hapticFeedbackType = .error
                attributes.entryBackground = .color(color: .black)
                attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributes.statusBar = .dark
                attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
                attributes.position = .bottom
                attributes.displayDuration = .infinity
                attributes.roundCorners = .all(radius: 15)
                
                if let image = UIImage(named: "error_exmachina") {
                    themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
                }
                
                let title = EKProperty.LabelContent(text: "Pas de contenu", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: UIColor(named: "exmachina")!, alignment: .center))
                let description = EKProperty.LabelContent(text: "Cours indisponibles", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!, alignment: .center))
                let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black)), backgroundColor: UIColor(named: "exmachina")!, highlightedBackgroundColor: .black)
                let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
                    SwiftEntryKit.dismiss()
                }
                
                let contentView = EKPopUpMessageView(with: message)
                SwiftEntryKit.display(entry: contentView, using: attributes)
            }
        }, withCancel: nil)
    }
    
    fileprivate func getMatiere() {
        
        let ref = Database.database().reference().child("faculte").child("liste").child(self.user.faculte.facId).child("liste").child(self.user.filiere.fid).child("liste").child(self.user.semestre.sid).child("liste")
        self.matieres.removeAll()
        print(ref)
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            if snapshot.exists() {
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    var matiere = Matiere()
                    matiere.titre = dictionary["titre"] as? String ?? ""
                    matiere.mid = dictionary["mid"] as? String ?? ""
                    
                    self.matieres.append(matiere)
                    DispatchQueue.main.async(execute: {
                        self.activityIndicatorView.stopAnimating()
                        self.newCollection.reloadData()
                    })
                    
                }
            } else {
                let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                var themeImage: EKPopUpMessage.ThemeImage?
                var attributes = EKAttributes()
                attributes.hapticFeedbackType = .error
                attributes.entryBackground = .color(color: .black)
                attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributes.statusBar = .dark
                attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
                attributes.position = .bottom
                attributes.displayDuration = .infinity
                attributes.roundCorners = .all(radius: 15)
                
                if let image = UIImage(named: "error_exmachina") {
                    themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
                }
                
                let title = EKProperty.LabelContent(text: "Pas de contenu", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: UIColor(named: "exmachina")!, alignment: .center))
                let description = EKProperty.LabelContent(text: "Cours indisponibles", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!, alignment: .center))
                let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black)), backgroundColor: UIColor(named: "exmachina")!, highlightedBackgroundColor: .black)
                let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
                    SwiftEntryKit.dismiss()
                }
                
                let contentView = EKPopUpMessageView(with: message)
                SwiftEntryKit.display(entry: contentView, using: attributes)
            
                
            }
        }, withCancel: nil)
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
}

