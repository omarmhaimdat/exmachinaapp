//
//  ProfileViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import GoogleSignIn
import FBSDKLoginKit

class ProfileViewController: UIViewController {
    
    var user = User()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let contentView = UIView()
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    let buttonDeconnecte: BtnPleinLarge = {
        let buttonDeconnecte = BtnPleinLarge()
        buttonDeconnecte.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        buttonDeconnecte.translatesAutoresizingMaskIntoConstraints = false
        buttonDeconnecte.setTitle("Se déconnecter", for: .normal)
        buttonDeconnecte.backgroundColor = .white
        buttonDeconnecte.layer.borderColor = UIColor.white.cgColor
        buttonDeconnecte.layer.shadowOpacity = 0.3
        buttonDeconnecte.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        buttonDeconnecte.layer.shadowOffset = CGSize(width: 1, height: 5)
        buttonDeconnecte.layer.cornerRadius = 14
        buttonDeconnecte.layer.shadowRadius = 8
        buttonDeconnecte.layer.masksToBounds = true
        buttonDeconnecte.clipsToBounds = false
        buttonDeconnecte.contentHorizontalAlignment = .left
        buttonDeconnecte.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "logout")?.resized(newSize: CGSize(width: 25, height: 25))
        buttonDeconnecte.setImage( icon, for: .normal)
        buttonDeconnecte.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        buttonDeconnecte.layoutIfNeeded()
        buttonDeconnecte.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        buttonDeconnecte.titleEdgeInsets.left = 35
        
        
        return buttonDeconnecte
    }()
    
    let feedback: BtnPleinLarge = {
        let feedback = BtnPleinLarge()
//        feedback.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        feedback.translatesAutoresizingMaskIntoConstraints = false
        feedback.setTitle("Feedback", for: .normal)
        feedback.backgroundColor = .white
        feedback.layer.borderColor = UIColor.white.cgColor
        feedback.layer.shadowOpacity = 0.3
        feedback.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        feedback.layer.shadowOffset = CGSize(width: 1, height: 5)
        feedback.layer.cornerRadius = 14
        feedback.layer.shadowRadius = 8
        feedback.layer.masksToBounds = true
        feedback.clipsToBounds = false
        feedback.contentHorizontalAlignment = .left
        feedback.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "feedback")?.resized(newSize: CGSize(width: 25, height: 25))
        feedback.setImage( icon, for: .normal)
        feedback.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        feedback.layoutIfNeeded()
        feedback.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        feedback.titleEdgeInsets.left = 35
        
        
        return feedback
    }()
    
    let notifications: BtnPleinLarge = {
        let notifications = BtnPleinLarge()
        //        feedback.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        notifications.translatesAutoresizingMaskIntoConstraints = false
        notifications.setTitle("Notifications", for: .normal)
        notifications.backgroundColor = .white
        notifications.layer.borderColor = UIColor.white.cgColor
        notifications.layer.shadowOpacity = 0.3
        notifications.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        notifications.layer.shadowOffset = CGSize(width: 1, height: 5)
        notifications.layer.cornerRadius = 14
        notifications.layer.shadowRadius = 8
        notifications.layer.masksToBounds = true
        notifications.clipsToBounds = false
        notifications.contentHorizontalAlignment = .left
        notifications.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "notifications")?.resized(newSize: CGSize(width: 25, height: 25))
        notifications.setImage( icon, for: .normal)
        notifications.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        notifications.layoutIfNeeded()
        notifications.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        notifications.titleEdgeInsets.left = 35
        
        
        return notifications
    }()
    
    let general: BtnPleinLarge = {
        let general = BtnPleinLarge()
        //        feedback.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        general.translatesAutoresizingMaskIntoConstraints = false
        general.setTitle("Paramètres", for: .normal)
        general.backgroundColor = .white
        general.layer.borderColor = UIColor.white.cgColor
        general.layer.shadowOpacity = 0.2
        general.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        general.layer.shadowOffset = CGSize(width: 1, height: 5)
        general.layer.cornerRadius = 14
        general.layer.shadowRadius = 8
        general.layer.masksToBounds = true
        general.clipsToBounds = false
        general.contentHorizontalAlignment = .left
        general.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "general")?.resized(newSize: CGSize(width: 25, height: 25))
        general.setImage( icon, for: .normal)
        general.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        general.layoutIfNeeded()
        general.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        general.titleEdgeInsets.left = 35
        
        
        return general
    }()
    
    let profileEdit: BtnPleinLarge = {
        let profileEdit = BtnPleinLarge()
        //        feedback.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        profileEdit.translatesAutoresizingMaskIntoConstraints = false
        profileEdit.setTitle("\(Auth.auth().currentUser?.displayName ?? "Nom au complet")", for: .normal)
        profileEdit.backgroundColor = .white
        profileEdit.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        profileEdit.layer.shadowOpacity = 0.3
        profileEdit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        profileEdit.layer.shadowOffset = CGSize(width: 1, height: 5)
        profileEdit.layer.cornerRadius = 14
        profileEdit.layer.shadowRadius = 8
        profileEdit.layer.masksToBounds = true
        profileEdit.clipsToBounds = false
        profileEdit.contentHorizontalAlignment = .left
        profileEdit.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "profile_edit")?.resized(newSize: CGSize(width: 25, height: 25))
        profileEdit.setImage( icon, for: .normal)
        profileEdit.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        profileEdit.layoutIfNeeded()
        profileEdit.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        profileEdit.titleEdgeInsets.left = 35
        
        return profileEdit
    }()
    
    let changerDeFiliere: BtnPleinLarge = {
        let changerDeFiliere = BtnPleinLarge()
        changerDeFiliere.addTarget(self, action: #selector(buttonToChangerDeFiliere), for: .touchUpInside)
        changerDeFiliere.translatesAutoresizingMaskIntoConstraints = false
        changerDeFiliere.setTitle("Changer de filière", for: .normal)
        changerDeFiliere.backgroundColor = .white
        changerDeFiliere.layer.borderColor = UIColor.white.cgColor
        changerDeFiliere.layer.shadowOpacity = 0.3
        changerDeFiliere.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        changerDeFiliere.layer.shadowOffset = CGSize(width: 1, height: 5)
        changerDeFiliere.layer.cornerRadius = 14
        changerDeFiliere.layer.shadowRadius = 8
        changerDeFiliere.layer.masksToBounds = true
        changerDeFiliere.clipsToBounds = false
        changerDeFiliere.contentHorizontalAlignment = .left
        changerDeFiliere.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "edit")?.resized(newSize: CGSize(width: 25, height: 25))
        changerDeFiliere.setImage( icon, for: .normal)
        changerDeFiliere.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        changerDeFiliere.layoutIfNeeded()
        changerDeFiliere.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        changerDeFiliere.titleEdgeInsets.left = 35
        
        return changerDeFiliere
    }()
    
    let infos: BtnPleinLarge = {
        let infos = BtnPleinLarge()
        //        feedback.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        infos.translatesAutoresizingMaskIntoConstraints = false
        infos.setTitle("Informations", for: .normal)
        infos.backgroundColor = .white
        infos.layer.borderColor = UIColor.white.cgColor
        infos.layer.shadowOpacity = 0.3
        infos.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        infos.layer.shadowOffset = CGSize(width: 1, height: 5)
        infos.layer.cornerRadius = 14
        infos.layer.shadowRadius = 8
        infos.layer.masksToBounds = true
        infos.clipsToBounds = false
        infos.contentHorizontalAlignment = .left
        infos.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "infos")?.resized(newSize: CGSize(width: 25, height: 25))
        infos.setImage( icon, for: .normal)
        infos.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        infos.layoutIfNeeded()
        infos.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        infos.titleEdgeInsets.left = 35
        
        return infos
    }()
    
    let copyright: BtnPleinLarge = {
        let copyright = BtnPleinLarge()
        //        feedback.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        copyright.translatesAutoresizingMaskIntoConstraints = false
        copyright.setTitle("Ex-Machina", for: .normal)
        copyright.backgroundColor = UIColor(named: "exmachina")
        copyright.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        copyright.layer.shadowOpacity = 0.3
        copyright.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        copyright.layer.shadowOffset = CGSize(width: 1, height: 5)
        copyright.layer.cornerRadius = 14
        copyright.layer.shadowRadius = 8
        copyright.layer.masksToBounds = true
        copyright.clipsToBounds = false
        copyright.contentHorizontalAlignment = .left
        copyright.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "copyright")?.resized(newSize: CGSize(width: 25, height: 25))
        copyright.setImage( icon, for: .normal)
        copyright.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        copyright.layoutIfNeeded()
        copyright.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        copyright.titleEdgeInsets.left = 35
        
        return copyright
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        contentView.addSubview(buttonDeconnecte)
        contentView.addSubview(feedback)
        contentView.addSubview(notifications)
        contentView.addSubview(general)
        contentView.addSubview(profileEdit)
        contentView.addSubview(changerDeFiliere)
        contentView.addSubview(infos)
        contentView.addSubview(copyright)
        // Do any additional setup after loading the view.
        setupTabBar()
        setupLayout()
        setupLogOut()
        getCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    
    func setupScrollView() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Profile"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
//        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(buttonToDismiss))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupLayout() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            profileEdit.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileEdit.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
            profileEdit.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            profileEdit.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            changerDeFiliere.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            changerDeFiliere.topAnchor.constraint(equalTo: profileEdit.bottomAnchor, constant: 20).isActive = true
            changerDeFiliere.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            changerDeFiliere.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            general.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            general.topAnchor.constraint(equalTo: changerDeFiliere.bottomAnchor, constant: 20).isActive = true
            general.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            general.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            notifications.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            notifications.topAnchor.constraint(equalTo: general.bottomAnchor, constant: 20).isActive = true
            notifications.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            notifications.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            infos.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            infos.topAnchor.constraint(equalTo: notifications.bottomAnchor, constant: 20).isActive = true
            infos.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            infos.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            feedback.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            feedback.topAnchor.constraint(equalTo: infos.bottomAnchor, constant: 20).isActive = true
            feedback.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            feedback.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            buttonDeconnecte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonDeconnecte.topAnchor.constraint(equalTo: feedback.bottomAnchor, constant: 20).isActive = true
            buttonDeconnecte.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            buttonDeconnecte.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            copyright.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            copyright.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
            copyright.topAnchor.constraint(equalTo: buttonDeconnecte.bottomAnchor, constant: 20).isActive = true
            copyright.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            copyright.heightAnchor.constraint(equalToConstant: 70).isActive = true
        }
    }
    
    func setupLogOut() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user == nil {
                let viewController = SignInViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
                self.navigationController?.viewControllers.removeFirst()
            } else {
                
            }
        }
    }
    
    @objc func buttonToSignOutView(sender: BtnPleinLarge) {
        print("Logout button pressed")
        
        let utilisateur = Auth.auth().currentUser
        let nomUtilisateurCourant = utilisateur?.displayName
        
        let alert = UIAlertController(title: "\(nomUtilisateurCourant ?? "Nom de l'utilisateur")", message: nil, preferredStyle: .actionSheet)
        
        let annulerAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
        }
        
        let deconnecterAction = UIAlertAction(title: "Se déconnecter", style: .destructive) { (_) in
            
            self.hud.textLabel.text = "Déconnexion..."
            self.hud.show(in: self.view, animated: true)
            let firebaseAuth = Auth.auth()
            
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.synchronize()
            
            do {
                try firebaseAuth.signOut()
                GIDSignIn.sharedInstance()?.signOut()
                AccessToken.current = nil
                UserDefaults.standard.removeObject(forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
                print("Successfully signed out of google")
                self.hud.textLabel.text = "Succès de la déconnexion"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.dismiss(afterDelay: 5, animated: true)
                
            } catch let signOutError as NSError {
                self.hud.textLabel.text = "Échec de la déconnexion"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.dismiss(animated: true)
                print ("Error signing out: %@", signOutError)
            }
        }
        
        alert.addAction(annulerAction)
        alert.addAction(deconnecterAction)
        
        //Begin: Uniquement pour les iPads (UIAlertController n'existe pas sur iPad)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2.5, width: 1, height: 1)
        }
        //End: Uniquement pour les iPads
        present(alert, animated: true, completion: nil)
        
    }
    
    func getCurrentUser() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var user = User()
                user.dateDeCreation = (dictionary["dateDeCreation"] as! String?)!
                user.email = (dictionary["email"] as! String?)!
                user.name = (dictionary["name"] as! String?)!
                user.profileImageUrl = (dictionary["profileImageUrl"] as! String?)!
                user.provider = (dictionary["provider"] as! String?)!
                user.filiere.fid = (dictionary["filiere"] as! String?)!
                user.semestre.sid = (dictionary["semestre"] as! String?)!
                user.faculte.facId = (dictionary["faculte"] as! String?)!
                self.user = user
                
            }
        }, withCancel: nil)
    }
    
    @objc func buttonToChangerDeFiliere() {
        
        let controller = ChoisirFiliereViewController()
        controller.user = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToDismiss() {
        dismiss(animated: true, completion: nil)
    }

}
