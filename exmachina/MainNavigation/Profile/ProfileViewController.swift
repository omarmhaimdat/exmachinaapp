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
import SwiftWebVC
import MessageUI
import SwiftEntryKit

class ProfileViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    var user = User()
    var filieres = [Filiere]()
    var semestres = [Semestre]()
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
    
    let parametres: BtnPleinLarge = {
        let buttonDeconnecte = BtnPleinLarge()
        buttonDeconnecte.addTarget(self, action: #selector(buttonToSignOutView(sender:)), for: .touchUpInside)
        buttonDeconnecte.translatesAutoresizingMaskIntoConstraints = false
        buttonDeconnecte.setTitle("Paramètres", for: .normal)
        buttonDeconnecte.backgroundColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0)
        buttonDeconnecte.layer.borderColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0).cgColor
        buttonDeconnecte.layer.shadowOpacity = 0.3
        buttonDeconnecte.layer.shadowColor = UIColor(red:0.56, green:0.56, blue:0.58, alpha:1.0).cgColor
        buttonDeconnecte.layer.shadowOffset = CGSize(width: 1, height: 2)
        buttonDeconnecte.layer.cornerRadius = 14
        buttonDeconnecte.layer.shadowRadius = 5
        buttonDeconnecte.layer.masksToBounds = true
        buttonDeconnecte.clipsToBounds = false
        buttonDeconnecte.contentHorizontalAlignment = .left
        buttonDeconnecte.setTitleColor(.white, for: .normal)
        let icon = UIImage(named: "parametres")?.resized(newSize: CGSize(width: 25, height: 25))
        buttonDeconnecte.setImage( icon, for: .normal)
        buttonDeconnecte.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        buttonDeconnecte.layoutIfNeeded()
        buttonDeconnecte.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        buttonDeconnecte.titleEdgeInsets.left = 35
        
        
        return buttonDeconnecte
    }()
    
    let feedback: BtnPleinLarge = {
        let feedback = BtnPleinLarge()
        feedback.addTarget(self, action: #selector(buttonToFeedback(sender:)), for: .touchUpInside)
        feedback.translatesAutoresizingMaskIntoConstraints = false
        feedback.setTitle("Feedback", for: .normal)
        feedback.backgroundColor = .white
        feedback.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        feedback.layer.shadowOpacity = 0.3
        feedback.layer.shadowColor = #colorLiteral(red: 0.8341107965, green: 0.7586194277, blue: 0, alpha: 1)
        feedback.layer.shadowOffset = CGSize(width: 1, height: 2)
        feedback.layer.cornerRadius = 14
        feedback.layer.shadowRadius = 5
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
        notifications.layer.shadowOffset = CGSize(width: 1, height: 2)
        notifications.layer.cornerRadius = 14
        notifications.layer.shadowRadius = 5
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
        general.layer.shadowOffset = CGSize(width: 1, height: 2)
        general.layer.cornerRadius = 14
        general.layer.shadowRadius = 5
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
        profileEdit.setTitle("\(Auth.auth().currentUser?.displayName ?? "Anonyme")", for: .normal)
        profileEdit.backgroundColor = .white
        profileEdit.layer.borderColor = UIColor.white.cgColor
        profileEdit.layer.shadowOpacity = 0.3
        profileEdit.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        profileEdit.layer.shadowOffset = CGSize(width: 1, height: 2)
        profileEdit.layer.cornerRadius = 14
        profileEdit.layer.shadowRadius = 5
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
        changerDeFiliere.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        changerDeFiliere.layer.shadowOpacity = 0.3
        changerDeFiliere.layer.shadowColor = #colorLiteral(red: 0.8341107965, green: 0.7586194277, blue: 0, alpha: 1)
        changerDeFiliere.layer.shadowOffset = CGSize(width: 1, height: 2)
        changerDeFiliere.layer.cornerRadius = 14
        changerDeFiliere.layer.shadowRadius = 5
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
    
    let instagram: BtnPleinLarge = {
        let infos = BtnPleinLarge()
        infos.addTarget(self, action: #selector(buttonToInstagram), for: .touchUpInside)
        infos.translatesAutoresizingMaskIntoConstraints = false
        infos.setTitle("Instagram", for: .normal)
        infos.backgroundColor = .white
        infos.layer.borderColor = UIColor.black.cgColor
        infos.layer.shadowOpacity = 0.3
        infos.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        infos.layer.shadowOffset = CGSize(width: 1, height: 2)
        infos.layer.cornerRadius = 14
        infos.layer.shadowRadius = 5
        infos.layer.masksToBounds = true
        infos.clipsToBounds = false
        infos.contentHorizontalAlignment = .left
        infos.setTitleColor(.black, for: .normal)
        let icon = UIImage(named: "instagram")?.resized(newSize: CGSize(width: 25, height: 25))
        infos.setImage( icon, for: .normal)
        infos.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        infos.layoutIfNeeded()
        infos.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        infos.titleEdgeInsets.left = 35
        
        return infos
    }()
    
    let facebook: BtnPleinLarge = {
        let infos = BtnPleinLarge()
        infos.addTarget(self, action: #selector(buttonToFacebook), for: .touchUpInside)
        infos.translatesAutoresizingMaskIntoConstraints = false
        infos.setTitle("Facebook", for: .normal)
        infos.backgroundColor = .white
        infos.layer.borderColor = UIColor(red: 24/255, green: 119/255, blue: 242/255, alpha:1.0).cgColor
        infos.layer.shadowOpacity = 0.3
        infos.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        infos.layer.shadowOffset = CGSize(width: 1, height: 2)
        infos.layer.cornerRadius = 14
        infos.layer.shadowRadius = 5
        infos.layer.masksToBounds = true
        infos.clipsToBounds = false
        infos.contentHorizontalAlignment = .left
        infos.setTitleColor(UIColor(red: 24/255, green: 119/255, blue: 242/255, alpha:1.0), for: .normal)
        let icon = UIImage(named: "fb")?.resized(newSize: CGSize(width: 25, height: 25))
        infos.setImage( icon, for: .normal)
        infos.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
        infos.layoutIfNeeded()
        infos.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
        infos.titleEdgeInsets.left = 35
        
        return infos
    }()
    
    let copyright: BtnPleinLarge = {
        let copyright = BtnPleinLarge()
        copyright.addTarget(self, action: #selector(buttonToExMachina(sender:)), for: .touchUpInside)
        copyright.translatesAutoresizingMaskIntoConstraints = false
        copyright.setTitle("Ex-Machina", for: .normal)
        copyright.backgroundColor = UIColor(named: "exmachina")
        copyright.layer.borderColor = UIColor(named: "exmachina")?.cgColor
        copyright.layer.shadowOpacity = 0.3
        copyright.layer.shadowColor = UIColor(named: "exmachina")?.cgColor
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
        contentView.addSubview(parametres)
        contentView.addSubview(feedback)
        contentView.addSubview(profileEdit)
        contentView.addSubview(changerDeFiliere)
        contentView.addSubview(instagram)
        contentView.addSubview(facebook)
        contentView.addSubview(copyright)
        setupTabBar()
        setupLayout()
        setupLogOut()
        getCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser!.isAnonymous {
            changerDeFiliere.isEnabled = false
            changerDeFiliere.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            changerDeFiliere.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
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
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Profil"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
//        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        let addButton: UIBarButtonItem = UIBarButtonItem(title: "Fermer", style: .done, target: self, action: #selector(buttonToDismiss))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupLayout() {
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            profileEdit.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileEdit.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
            profileEdit.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            profileEdit.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            changerDeFiliere.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            changerDeFiliere.topAnchor.constraint(equalTo: profileEdit.bottomAnchor, constant: 20).isActive = true
            changerDeFiliere.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            changerDeFiliere.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            feedback.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            feedback.topAnchor.constraint(equalTo: changerDeFiliere.bottomAnchor, constant: 50).isActive = true
            feedback.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            feedback.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            
            instagram.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            instagram.topAnchor.constraint(equalTo: feedback.bottomAnchor, constant: 50).isActive = true
            instagram.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            instagram.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            facebook.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            facebook.topAnchor.constraint(equalTo: instagram.bottomAnchor, constant: 20).isActive = true
            facebook.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            facebook.heightAnchor.constraint(equalToConstant: 60).isActive = true

            
            copyright.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            copyright.topAnchor.constraint(equalTo: facebook.bottomAnchor, constant: 50).isActive = true
            copyright.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            copyright.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            parametres.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            parametres.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
            parametres.topAnchor.constraint(equalTo: copyright.bottomAnchor, constant: 20).isActive = true
            parametres.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
            parametres.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        if UIDevice().userInterfaceIdiom == .pad {
            
            profileEdit.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profileEdit.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
            profileEdit.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            profileEdit.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            changerDeFiliere.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            changerDeFiliere.topAnchor.constraint(equalTo: profileEdit.bottomAnchor, constant: 20).isActive = true
            changerDeFiliere.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            changerDeFiliere.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            feedback.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            feedback.topAnchor.constraint(equalTo: changerDeFiliere.bottomAnchor, constant: 60).isActive = true
            feedback.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            feedback.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            instagram.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            instagram.topAnchor.constraint(equalTo: feedback.bottomAnchor, constant: 60).isActive = true
            instagram.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            instagram.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            facebook.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            facebook.topAnchor.constraint(equalTo: instagram.bottomAnchor, constant: 20).isActive = true
            facebook.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            facebook.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            
            
            copyright.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            copyright.topAnchor.constraint(equalTo: facebook.bottomAnchor, constant: 60).isActive = true
            copyright.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            copyright.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            parametres.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            parametres.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
            parametres.topAnchor.constraint(equalTo: copyright.bottomAnchor, constant: 20).isActive = true
            parametres.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
            parametres.heightAnchor.constraint(equalToConstant: 80).isActive = true
        }
    }
    
    func setupLogOut() {
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            if user == nil {
//                let viewController = SignInViewController()
//                self.navigationController?.pushViewController(viewController, animated: true)
//                self.navigationController?.viewControllers.removeFirst()
//            } else {
//
//            }
//        }
    }
    
    @objc func buttonToFeedback(sender: BtnPleinLarge) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["contact@ex-machina.ma"])
                mail.setSubject("Feedback | Application iOS")
            self.present(mail, animated: true)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
        if result == .sent {
            let generator = UISelectionFeedbackGenerator()
            let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            var attributes = EKAttributes.topFloat
            attributes.entryBackground = .gradient(gradient: .init(colors: [#colorLiteral(red: 0.8345173001, green: 0.7508397102, blue: 0, alpha: 1), #colorLiteral(red: 0.8345173001, green: 0.7508397102, blue: 0, alpha: 1)], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
            attributes.statusBar = .dark
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge), height: .intrinsic)
            attributes.position = .top
            attributes.displayDuration = 1
            attributes.statusBar = .light
            generator.selectionChanged()
            let title = EKProperty.LabelContent(text: "Confirmation", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir-Heavy", size: 22)!, color: UIColor.black))
            let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "ok_black"), size: CGSize(width: 45, height: 45))
            let description = EKProperty.LabelContent(text: "L'émail a bien été envoyé", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir", size: 14)!, color: .black))
            let simpleMessage =  EKSimpleMessage(image: image, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    @objc func buttonToExMachina(sender: BtnPleinLarge) {
        let webVC = SwiftModalWebVC(urlString: "https://courses.ex-machina.ma", theme: .dark, dismissButtonStyle: .cross)
        self.present(webVC, animated: true, completion: nil)
    }
    
    @objc func buttonToSignOutView(sender: BtnPleinLarge) {
        let controller = ParametresViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func getCurrentUser() {
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
                user.new = dictionary["new"] as? Bool ?? false
                self.user = user
                self.getFilieres()
                
            }
        }, withCancel: nil)
    }
    
    func getFilieres() {
        self.filieres.removeAll()
        if self.user.faculte.facId != "Sélectionner la faculté" || self.user.faculte.facId != "Selectionner la faculté" {
            let ref = Database.database().reference().child("data").child("faculte").child(self.user.faculte.facId).child("liste")
            ref.observe(DataEventType.childAdded, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        var filiere = Filiere()
                        filiere.titre = dictionary["titre"] as? String ?? ""
                        filiere.fid = dictionary["fid"] as? String ?? ""
                        
                        self.filieres.append(filiere)
                    }
            }, withCancel: nil)
            self.getSemestres()
        }
        
    }
    
    func getSemestres() {
        self.semestres.removeAll()
        
        if self.user.filiere.fid != "Sélectionner la filière" || self.user.filiere.fid != "Selectionner la filière" {
            let ref = Database.database().reference().child("data").child("faculte").child(self.user.faculte.facId).child("liste").child(self.user.filiere.fid).child("liste")
            ref.observe(DataEventType.childAdded, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    
                    var semestre = Semestre()
                    semestre.titre = dictionary["titre"] as? String ?? ""
                    semestre.sid = dictionary["sid"] as? String ?? ""
                    
                    self.semestres.append(semestre)
                }
                
            }, withCancel: nil)
        }
        
    }
    
    @objc func buttonToChangerDeFiliere() {
        
        let controller = ChoisirFiliereViewController()
        controller.user = self.user
        controller.filieres = self.filieres
        controller.semestres = self.semestres
        let index2 = self.semestres.firstIndex(where: { (item) -> Bool in
            item.sid == self.user.semestre.sid
        })

        controller.index2 = index2
        let index = self.filieres.firstIndex(where: { (item) -> Bool in
            item.fid == self.user.filiere.fid
        })
        controller.index = index
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToInstagram() {
        let instagramHooks = "instagram://user?username=uic.ex.machina"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "http://instagram.com/uic.ex.machina")! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func buttonToFacebook() {
        let instagramHooks = "fb://profile/1897417980510375"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.open(instagramUrl! as URL, options: [:], completionHandler: nil)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "http://facebook.com/uic.ex.machina")! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc func buttonToDismiss() {
        dismiss(animated: true, completion: nil)
    }

}

extension ProfileViewController: SwiftWebVCDelegate {
    
    func didStartLoading() {
        print("Started loading.")
    }
    
    func didFinishLoading(success: Bool) {
        print("Finished loading. Success: \(success).")
    }
    
}
