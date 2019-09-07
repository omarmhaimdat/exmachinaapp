//
//  ParametresViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 07-09-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import GoogleSignIn
import FBSDKLoginKit
import SwiftWebVC

class ParametresViewController: UIViewController {
    
    var myError: Error?
    
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
    
    let CGU: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        btn.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Conditions générale d'utilisation", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        btn.layer.shadowOffset = CGSize(width: 1, height: 2)
        btn.layer.cornerRadius = 14
        btn.layer.shadowRadius = 5
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "cgu")?.resized(newSize: CGSize(width: 25, height: 25))
        btn.setImage( icon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        btn.layoutIfNeeded()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        btn.titleEdgeInsets.left = 35
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            btn.titleLabel?.font = UIFont(name: "Avenir", size: 14)
        default:
            btn.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        }
        
        return btn
    }()
    
    let privacy: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        btn.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Politique de confidentialité", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        btn.layer.shadowOffset = CGSize(width: 1, height: 2)
        btn.layer.cornerRadius = 14
        btn.layer.shadowRadius = 5
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "privacy")?.resized(newSize: CGSize(width: 25, height: 25))
        btn.setImage( icon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        btn.layoutIfNeeded()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        btn.titleEdgeInsets.left = 35
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            btn.titleLabel?.font = UIFont(name: "Avenir", size: 14)
        default:
            btn.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        }
        
        return btn
    }()
    
    let buttonDeconnecte: BtnPleinLarge = {
        let buttonDeconnecte = BtnPleinLarge()
        buttonDeconnecte.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        buttonDeconnecte.translatesAutoresizingMaskIntoConstraints = false
        buttonDeconnecte.setTitle("Se déconnecter", for: .normal)
        buttonDeconnecte.backgroundColor = #colorLiteral(red: 0.7803921569, green: 0.1176470588, blue: 0.1137254902, alpha: 1)
        buttonDeconnecte.layer.borderColor = #colorLiteral(red: 0.7784625888, green: 0.1167572811, blue: 0.1156655774, alpha: 1)
        buttonDeconnecte.layer.shadowOpacity = 0.3
        buttonDeconnecte.layer.shadowColor = #colorLiteral(red: 0.7784625888, green: 0.1167572811, blue: 0.1156655774, alpha: 1)
        buttonDeconnecte.layer.shadowOffset = CGSize(width: 1, height: 2)
        buttonDeconnecte.layer.cornerRadius = 14
        buttonDeconnecte.layer.shadowRadius = 5
        buttonDeconnecte.layer.masksToBounds = true
        buttonDeconnecte.clipsToBounds = false
        buttonDeconnecte.contentHorizontalAlignment = .left
        buttonDeconnecte.setTitleColor(.white, for: .normal)
        let icon = UIImage(named: "logout")?.resized(newSize: CGSize(width: 25, height: 25))
        buttonDeconnecte.setImage( icon, for: .normal)
        buttonDeconnecte.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        buttonDeconnecte.layoutIfNeeded()
        buttonDeconnecte.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        buttonDeconnecte.titleEdgeInsets.left = 35
        
        
        return buttonDeconnecte
    }()
    
    let deleteAccount: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        btn.addTarget(self, action: #selector(buttonToDelete), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Supprimer mon compte", for: .normal)
        btn.backgroundColor = .white
        btn.layer.borderColor = #colorLiteral(red: 0.7803921569, green: 0.1176470588, blue: 0.1137254902, alpha: 1)
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        btn.layer.shadowOffset = CGSize(width: 1, height: 2)
        btn.layer.cornerRadius = 14
        btn.layer.shadowRadius = 5
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.contentHorizontalAlignment = .left
        btn.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "delete")?.resized(newSize: CGSize(width: 25, height: 25))
        btn.setImage( icon, for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        btn.layoutIfNeeded()
        btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        btn.titleEdgeInsets.left = 35
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupScrollView()
        contentView.addSubview(buttonDeconnecte)
        contentView.addSubview(deleteAccount)
        contentView.addSubview(CGU)
        contentView.addSubview(privacy)
        setupLayout()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Paramètres"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupLayout() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            CGU.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            CGU.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
            CGU.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            CGU.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            privacy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            privacy.topAnchor.constraint(equalTo: CGU.bottomAnchor, constant: 20).isActive = true
            privacy.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            privacy.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            deleteAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            deleteAccount.topAnchor.constraint(equalTo: privacy.bottomAnchor, constant: 60).isActive = true
            deleteAccount.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            deleteAccount.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            buttonDeconnecte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonDeconnecte.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
            buttonDeconnecte.topAnchor.constraint(equalTo: deleteAccount.bottomAnchor, constant: 60).isActive = true
            buttonDeconnecte.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            buttonDeconnecte.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        if UIDevice().userInterfaceIdiom == .pad {
            
            CGU.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            CGU.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
            CGU.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            CGU.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            privacy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            privacy.topAnchor.constraint(equalTo: CGU.bottomAnchor, constant: 40).isActive = true
            privacy.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            privacy.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            deleteAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            deleteAccount.topAnchor.constraint(equalTo: privacy.bottomAnchor, constant: 80).isActive = true
            deleteAccount.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            deleteAccount.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            buttonDeconnecte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonDeconnecte.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
            buttonDeconnecte.topAnchor.constraint(equalTo: deleteAccount.bottomAnchor, constant: 80).isActive = true
            buttonDeconnecte.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            buttonDeconnecte.heightAnchor.constraint(equalToConstant: 80).isActive = true
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
    
    @objc func buttonToDelete() {
        let user = Auth.auth().currentUser
        
        let alert = UIAlertController(title: "Confirmation", message: nil, preferredStyle: .actionSheet)
        
        let annulerAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
        }
        
        let deconnecterAction = UIAlertAction(title: "Supprimer", style: .destructive) { (_) in
            user?.delete { error in
                if let error = error {
                    let alert = UIAlertController(title: "Erreur", message: "Une erreur est survenue", preferredStyle: .alert)
                    let erreur = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    }
                    alert.addAction(erreur)
                    self.myError = error
                } else {
                    let alert = UIAlertController(title: "Confirmation", message: "Votre compte a été supprimé", preferredStyle: .alert)
                    let confirmation = UIAlertAction(title: "Ok", style: .default) { action -> Void in
                    }
                    alert.addAction(confirmation)
                    self.myError = error
                }
            }
            if self.myError == nil {
                let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
                ref.removeValue()
                print("supprimer")
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
    
}
