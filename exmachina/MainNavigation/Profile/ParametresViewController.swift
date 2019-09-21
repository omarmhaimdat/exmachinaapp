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
import SwiftEntryKit

class ParametresViewController: UIViewController {
    
    var myError: Error?
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = UIColor.white
        }
        
        return view
    }()
    
    let contentView = UIView()
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    let CGU_privacy: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToCGU(sender:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Conditions générale d'utilisation et\nPolitique de confidentialité")
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(0, 36))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(37, 28))
            if #available(iOS 13.0, *) {
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSMakeRange(0, 36))
            } else {
                // Fallback on earlier versions
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, 36))
            }
            if #available(iOS 13.0, *) {
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSMakeRange(37, 28))
            } else {
                // Fallback on earlier versions
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(37, 28))
            }
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        default:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(0, 36))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(37, 28))
            if #available(iOS 13.0, *) {
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSMakeRange(0, 36))
            } else {
                // Fallback on earlier versions
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(0, 36))
            }
            if #available(iOS 13.0, *) {
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: NSMakeRange(37, 28))
            } else {
                // Fallback on earlier versions
                str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSMakeRange(37, 28))
            }
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
            cours.titleEdgeInsets.left = 35
            cours.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 20)
        }
        
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "privacy")?.resized(newSize: CGSize(width: 35, height: 35))
        cours.setImage( icon, for: .normal)
        if #available(iOS 13.0, *) {
            cours.backgroundColor = .tertiarySystemBackground
        } else {
            // Fallback on earlier versions
            cours.backgroundColor = .white
        }
        cours.layer.borderColor = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.8341107965, green: 0.7586194277, blue: 0, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 14
        cours.layer.shadowRadius = 5
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        
        return cours
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
        if #available(iOS 13.0, *) {
            btn.backgroundColor = .tertiarySystemBackground
        } else {
            // Fallback on earlier versions
            btn.backgroundColor = .white
        }
        btn.layer.borderColor = #colorLiteral(red: 0.7803921569, green: 0.1176470588, blue: 0.1137254902, alpha: 1)
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = #colorLiteral(red: 0.7803921569, green: 0.1176470588, blue: 0.1137254902, alpha: 1)
        btn.layer.shadowOffset = CGSize(width: 1, height: 2)
        btn.layer.cornerRadius = 14
        btn.layer.shadowRadius = 5
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        btn.contentHorizontalAlignment = .left
        if #available(iOS 13.0, *) {
            btn.setTitleColor(.label, for: .normal)
        } else {
            // Fallback on earlier versions
            btn.setTitleColor(.black, for: .normal)
        }
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
        contentView.addSubview(CGU_privacy)
        setupLayout()
    }
    
    func setupTabBar() {
        navigationItem.title = "Paramètres"
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
            
            CGU_privacy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            CGU_privacy.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
            CGU_privacy.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            CGU_privacy.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            deleteAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            deleteAccount.topAnchor.constraint(equalTo: CGU_privacy.bottomAnchor, constant: 60).isActive = true
            deleteAccount.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            deleteAccount.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            buttonDeconnecte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            buttonDeconnecte.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
            buttonDeconnecte.topAnchor.constraint(equalTo: deleteAccount.bottomAnchor, constant: 60).isActive = true
            buttonDeconnecte.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            buttonDeconnecte.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        if UIDevice().userInterfaceIdiom == .pad {
            
            CGU_privacy.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            CGU_privacy.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
            CGU_privacy.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            CGU_privacy.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            deleteAccount.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            deleteAccount.topAnchor.constraint(equalTo: CGU_privacy.bottomAnchor, constant: 80).isActive = true
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
        
        let alert = UIAlertController(title: "Toutes vos données seront supprimées", message: nil, preferredStyle: .actionSheet)
        
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
                    self.myError = error
                }
            }
            if self.myError == nil {
                let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
                ref.removeValue()
                let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
                var themeImage: EKPopUpMessage.ThemeImage?
                var attributes = EKAttributes()
                attributes.hapticFeedbackType = .success
                attributes.entryBackground = .color(color: UIColor(named: "exmachina")!)
                attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributes.statusBar = .dark
                attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
                attributes.position = .bottom
                attributes.displayDuration = .infinity
                attributes.roundCorners = .all(radius: 15)
                
                if let image = UIImage(named: "ok_black") {
                    themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
                }
                
                let title = EKProperty.LabelContent(text: "Confirmation", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: .black, alignment: .center))
                let description = EKProperty.LabelContent(text: "Votre compte a été supprimé, vous recevrez un email de confirmation.", style: .init(font: UIFont(name: "Avenir-Medium", size: 16)!, color: .black, alignment: .center))
                let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!)), backgroundColor: .black, highlightedBackgroundColor: UIColor(named: "exmachina")!)
                let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
                    SwiftEntryKit.dismiss()
                }
                
                let contentView = EKPopUpMessageView(with: message)
                SwiftEntryKit.display(entry: contentView, using: attributes)
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
    
    @objc func buttonToCGU(sender: BtnPleinLarge) {
        let webVC = SwiftModalWebVC(urlString: "https://courses.ex-machina.ma/data/cgu.pdf", theme: .dark, dismissButtonStyle: .cross)
        self.present(webVC, animated: true, completion: nil)
        print("CGU PRESSED !")
    }
    
}

extension ParametresViewController: SwiftWebVCDelegate {
    
    func didStartLoading() {
        print("Started loading.")
    }
    
    func didFinishLoading(success: Bool) {
        print("Finished loading. Success: \(success).")
    }
    
}
