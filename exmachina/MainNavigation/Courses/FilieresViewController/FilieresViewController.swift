//
//  FilieresViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView
import BouncyLayout
import LBTAComponents
import FirebaseAuth
import SystemConfiguration
import Reachability
import SwiftEntryKit

private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class FiliereViewController: UIViewController {
    
    private let reachability = Reachability(hostname: "www.ex-machina.ma")
    
    let cellId = "cellId"
    var matieres = [Matiere]()
    var filieres = [Filiere]()
    var faculte = Faculte()
    
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
        setupCollection()
        setupCollectionView()
        setupLoadingControl()
        activityIndicatorView.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
        getFilieres()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func setupTabBar() {
        navigationItem.title = "\(self.faculte.titre)"
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
        
        refreshControl.addTarget(self, action: #selector(refreshCardsData(_:)), for: .valueChanged)
        
    }
    
    fileprivate func setupCollectionView() {
        newCollection.register(CoursesFacultyViewCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    private let refreshControl = UIRefreshControl()
    @objc private func refreshCardsData(_ sender: Any) {
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = #colorLiteral(red: 0.8345173001, green: 0.7508397102, blue: 0, alpha: 1)
        refreshControl.beginRefreshing()
        getFilieres()
    }
    
    func getFilieres() {
        
        let ref = Database.database().reference()
        self.filieres.removeAll()
        ref.child("faculte").child("liste").child("\(self.faculte.facId)").child("liste").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var filiere = Filiere()
                filiere.titre = dictionary["titre"] as? String ?? ""
                filiere.fid = dictionary["fid"] as? String ?? ""
                filiere.colorOne = UIColor(hexString: (dictionary["colorOne"] as? String ?? "#d5c100"))
                filiere.colorTwo = UIColor(hexString: (dictionary["colorTwo"] as? String ?? "#d5c100"))

                self.filieres.append(filiere)
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                    self.activityIndicatorView.stopAnimating()
                })
                self.run(after: 1, closure: {
                    self.refreshControl.endRefreshing()
                })
            }
        }, withCancel: nil)
    }
    
    @objc func singleTapping(_ recognizer: UIGestureRecognizer) {
        let controller = ProfileViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            promptNotification()
        }
    }
    
    private func promptNotification() {
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
        
        if let image = UIImage(named: "no_connection") {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 100, height: 100), contentMode: .scaleAspectFit))
        }
        
        let title = EKProperty.LabelContent(text: "Pas de connection", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: UIColor(named: "exmachina")!, alignment: .center))
        let description = EKProperty.LabelContent(text: "Le signal internet est trop faible", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black)), backgroundColor: UIColor(named: "exmachina")!, highlightedBackgroundColor: .black)
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
}

