//
//  FssScolariteViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 01-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import BLTNBoard
import FirebaseAuth
import MessageUI
import SwiftEntryKit

class FssScolariteViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private var demande = Demande()
    lazy var email = ScolariteEmail()
    
    let contentView = UIView()
    
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
    
    lazy var bulletinAttestationDeScolarite: BLTNItemManager = {
        let rootItem: BLTNItem = nomAttestationDeScolarite()
        let manager = BLTNItemManager(rootItem: rootItem)
        if #available(iOS 13.0, *) {
            manager.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            manager.backgroundColor = .white
        }
        return manager
    }()
    
    let responsable: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Responsable\nResponsable")
        cours.addTarget(self, action: #selector(buttonToResponsable(_:)), for: .touchUpInside)
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(12, 11))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(12, 11))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.6980392157, blue: 0.3843137255, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.6980392157, blue: 0.3843137255, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        cours.titleEdgeInsets.left = 30
        
        return cours
    }()
    
    let attestationDeScolarite: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToAttestionDeScolarite(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Attestation de scolarité\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 24))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(25, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 24))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(25, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.7254901961, blue: 0.4392156863, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.5411764706, green: 0.7254901961, blue: 0.4392156863, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        cours.titleEdgeInsets.left = 30
        
        return cours
    }()
    
    let attestationDeReussite: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToAttestionDeReussite(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Attestation de réussite\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 23))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(24, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 23))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(24, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.5803921569, green: 0.7490196078, blue: 0.4901960784, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.5803921569, green: 0.7490196078, blue: 0.4901960784, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        cours.titleEdgeInsets.left = 30
        
        return cours
    }()
    
    fileprivate func nomAttestationDeScolarite() -> NomTextFieldBulletinPage {
        let blt = NomTextFieldBulletinPage(title: "Nom au complet")
        blt.descriptionText = "Veuillez entrer votre nom et prénom"
        blt.actionButtonTitle = "Suivant"
        blt.appearance.actionButtonColor = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
        if #available(iOS 13.0, *) {
            blt.appearance.titleTextColor = .label
        } else {
            // Fallback on earlier versions
             blt.appearance.titleTextColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        }
        if #available(iOS 13.0, *) {
            blt.appearance.descriptionTextColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
            blt.appearance.descriptionTextColor = .black
        }
        let bltItem: BLTNItem = self.cinAttestationDeScolarite()
        blt.next = bltItem
        blt.actionHandler = { (item: BLTNActionItem) in
            self.demande.nomAuComplet = blt.textField.text!
            item.manager?.displayNextItem()
        }
        blt.alternativeButtonTitle = "Pas maintenant"
        blt.appearance.alternativeButtonTitleColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
        blt.alternativeHandler = { (item: BLTNActionItem) in
            item.manager?.dismissBulletin(animated: true)
        }
        return blt
    }
    
    fileprivate func cinAttestationDeScolarite() -> TextFieldBulletinPage {
        let blt = TextFieldBulletinPage(title: "C.I.N")
        blt.descriptionText = "Numéro de carte d'identité"
        blt.actionButtonTitle = "Suivant"
        blt.appearance.actionButtonColor = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
        if #available(iOS 13.0, *) {
            blt.appearance.titleTextColor = .label
        } else {
            // Fallback on earlier versions
             blt.appearance.titleTextColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        }
        if #available(iOS 13.0, *) {
            blt.appearance.descriptionTextColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
            blt.appearance.descriptionTextColor = .black
        }
        let bltItem: BLTNItem = self.dateAttestationDeScolarite()
        blt.next = bltItem
        blt.actionHandler = { (item: BLTNActionItem) in
            if blt.textField.text != "" {
                self.demande.cin = blt.textField.text!
                item.manager?.displayNextItem()
            } else {
                blt.descriptionLabel!.textColor = .red
                blt.descriptionLabel!.text = "Vous devez entrer une valeur."
                blt.textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            }
        }
        blt.alternativeButtonTitle = "Précedent"
        blt.appearance.alternativeButtonTitleColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
        blt.alternativeHandler = { (item: BLTNActionItem) in
            item.manager?.popItem()
        }
        return blt
    }
    
    fileprivate func dateAttestationDeScolarite() -> DatePickerBLTNItem {
        let blt = DatePickerBLTNItem(title: "Date de naissance")
        blt.descriptionText = "Veuillez saisir la date de naissance"
        blt.actionButtonTitle = "Suivant"
        blt.appearance.actionButtonColor = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
        if #available(iOS 13.0, *) {
            blt.appearance.titleTextColor = .label
        } else {
            // Fallback on earlier versions
             blt.appearance.titleTextColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        }
        if #available(iOS 13.0, *) {
            blt.appearance.descriptionTextColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
            blt.appearance.descriptionTextColor = .black
        }
        let bltItem: BLTNItem = self.numberAttestationDeScolarite()
        blt.next = bltItem
        blt.actionHandler = { (item: BLTNActionItem) in
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = DateFormatter.Style.medium
            timeFormatter.dateFormat = "dd-MM-yyyy"
            print("----- Selected:  \(timeFormatter.string(from: blt.datePicker.date)) -------")
            self.demande.dateDeNaissance = "\(timeFormatter.string(from: blt.datePicker.date))"
            item.manager?.displayNextItem()
        }
        blt.alternativeButtonTitle = "Précedent"
        blt.appearance.alternativeButtonTitleColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
        blt.alternativeHandler = { (item: BLTNActionItem) in
            item.manager?.popItem()
        }
        return blt
    }
    
    fileprivate func numberAttestationDeScolarite() -> NumberPickerBLTNItem {
        let blt = NumberPickerBLTNItem(title: "Quantité")
        blt.descriptionText = "Nombre d'exemplaire"
        blt.actionButtonTitle = "Envoyer"
        blt.appearance.actionButtonColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        if #available(iOS 13.0, *) {
            blt.appearance.titleTextColor = .label
        } else {
            // Fallback on earlier versions
             blt.appearance.titleTextColor = #colorLiteral(red: 0.568627451, green: 0.5647058824, blue: 0.5725490196, alpha: 1)
        }
        if #available(iOS 13.0, *) {
            blt.appearance.descriptionTextColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
            blt.appearance.descriptionTextColor = .black
        }
        blt.actionHandler = { (item: BLTNActionItem) in
            self.demande.nombreExemplaire = "\(blt.selected)"
            
            item.manager?.dismissBulletin(animated: true)
            self.sendEmail(demande: self.demande)
        }
        blt.alternativeButtonTitle = "Précedent"
        blt.appearance.alternativeButtonTitleColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
        blt.alternativeHandler = { (item: BLTNActionItem) in
            item.manager?.popItem()
        }
        return blt
    }
    
    let attestationDeInsciption: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToAttestionDeInsciption(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Attestation d'inscription\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 25))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(26, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 25))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(26, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.631372549, green: 0.7803921569, blue: 0.5490196078, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.631372549, green: 0.7803921569, blue: 0.5490196078, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        cours.titleEdgeInsets.left = 30
        
        return cours
    }()
    
    let attestationDeReussiteAuDiplome: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToAttestionDeReussiteAuDiplome(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Attestation de réussite au diplôme\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 34))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(35, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 34))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(35, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.7254901961, green: 0.8352941176, blue: 0.662745098, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.7254901961, green: 0.8352941176, blue: 0.662745098, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        cours.titleEdgeInsets.left = 30
        
        return cours
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupScrollView()
        contentView.addSubview(responsable)
        contentView.addSubview(attestationDeScolarite)
        contentView.addSubview(attestationDeReussite)
        contentView.addSubview(attestationDeInsciption)
        contentView.addSubview(attestationDeReussiteAuDiplome)
        setupLayout()
        
        let str = NSMutableAttributedString(string: "Responsable\n\(self.email.responsable)")
        let size = self.email.responsable.count
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(12, size))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(12, size))
        str.setLineSpacing(8)
        responsable.setAttributedTitle(str, for: .normal)
    }
    
    func setupTabBar() {
        self.navigationItem.title = "FSS"
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
    
    func setupLayout() {
        responsable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        responsable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        responsable.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        responsable.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        attestationDeScolarite.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        attestationDeScolarite.topAnchor.constraint(equalTo: responsable.bottomAnchor, constant: 20).isActive = true
        attestationDeScolarite.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        attestationDeScolarite.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        attestationDeReussite.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        attestationDeReussite.topAnchor.constraint(equalTo: attestationDeScolarite.bottomAnchor, constant: 20).isActive = true
        attestationDeReussite.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        attestationDeReussite.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        attestationDeInsciption.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        attestationDeInsciption.topAnchor.constraint(equalTo: attestationDeReussite.bottomAnchor, constant: 20).isActive = true
        attestationDeInsciption.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        attestationDeInsciption.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        attestationDeReussiteAuDiplome.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        attestationDeReussiteAuDiplome.topAnchor.constraint(equalTo: attestationDeInsciption.bottomAnchor, constant: 20).isActive = true
        attestationDeReussiteAuDiplome.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        attestationDeReussiteAuDiplome.heightAnchor.constraint(equalToConstant: 100).isActive = true
        attestationDeReussiteAuDiplome.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
    }
    
    func setupScrollView() {
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        
    }
    
    func sendEmail(demande: Demande) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            switch demande.type {
            case .Inscription?:
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.email.responsableEmail)"])
                mail.setSubject("Demande d'Attestion d'inscription")
                mail.setMessageBody("<p>Bonjour Monsieur/Madame,</p>Je souhaiterai demander une attestation d'inscription, voici mes informations personnelles :<p><b>Nom au complet:</b> \(self.demande.nomAuComplet)</p><p><b>CIN:</b> \(self.demande.cin)</p><p><b>Date de naissance:</b> \(self.demande.dateDeNaissance)</p><p><b>Nombre d'exemplaire:</b> \(self.demande.nombreExemplaire)</p><p>Bien à vous,</p>", isHTML: true)
            case .Reussite?:
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.email.responsableEmail)"])
                mail.setSubject("Demande d'Attestion de Réussite")
                mail.setMessageBody("<p>Bonjour Monsieur/Madame,</p>Je souhaiterai demander une attestation de réussite, voici mes informations personnelles :<p><b>Nom au complet:</b> \(self.demande.nomAuComplet)</p><p><b>CIN:</b> \(self.demande.cin)</p><p><b>Date de naissance:</b> \(self.demande.dateDeNaissance)</p><p><b>Nombre d'exemplaire:</b> \(self.demande.nombreExemplaire)</p><p>Bien à vous,</p>", isHTML: true)
            case .ReussiteDiplome?:
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.email.responsableEmail)"])
                mail.setSubject("Demande d'Attestion de Réussite au Diplôme")
                mail.setMessageBody("<p>Bonjour Monsieur/Madame,</p>Je souhaiterai demander une attestation de réussite au diplôme, voici mes informations personnelles :<p><b>Nom au complet:</b> \(self.demande.nomAuComplet)</p><p><b>CIN:</b> \(self.demande.cin)</p><p><b>Date de naissance:</b> \(self.demande.dateDeNaissance)</p><p><b>Nombre d'exemplaire:</b> \(self.demande.nombreExemplaire)</p><p>Bien à vous,</p>", isHTML: true)
            case .Scolarite?:
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.email.responsableEmail)"])
                mail.setSubject("Demande d'Attestion de Scolarité")
                mail.setMessageBody("<p>Bonjour Monsieur/Madame,</p>Je souhaiterai demander une attestation de scolarité, voici mes informations personnelles :<p><b>Nom au complet:</b> \(self.demande.nomAuComplet)</p><p><b>CIN:</b> \(self.demande.cin)</p><p><b>Date de naissance:</b> \(self.demande.dateDeNaissance)</p><p><b>Nombre d'exemplaire:</b> \(self.demande.nombreExemplaire)</p><p>Bien à vous,</p>", isHTML: true)
            case .Responsable?:
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.email.responsable)"])
            case .none:
                print("Fail !!!! hard")
            }
            
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func buttonToResponsable(_ sender: BtnPleinLarge) {
        
        let alert = UIAlertController(title: "Responsable", message: nil, preferredStyle: .actionSheet)
        
        let annulerAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
            
        }
        
        let appeler = UIAlertAction(title: "Copier l'email", style: .default) { action -> Void in
            let str = self.email.responsableEmail
            UIPasteboard.general.string = str
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
            attributes.displayDuration = 0.5
            attributes.statusBar = .light
            generator.selectionChanged()
            let title = EKProperty.LabelContent(text: "Confirmation", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir-Heavy", size: 22)!, color: UIColor.black))
            let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "ok_black"), size: CGSize(width: 45, height: 45))
            let description = EKProperty.LabelContent(text: "L'émail a été copier", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir", size: 14)!, color: .black))
            let simpleMessage =  EKSimpleMessage(image: image, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
        
        let email = UIAlertAction(title: "Contacter par email", style: .default) { action -> Void in
            if MFMailComposeViewController.canSendMail() {
                self.demande.type = .Responsable
                self.sendEmail(demande: self.demande)
            } else {
                // show failure alert
            }
        }
        
        
        
        alert.addAction(annulerAction)
        alert.addAction(appeler)
        alert.addAction(email)
        
        //Begin: Uniquement pour les iPads (UIAlertController n'existe pas sur iPad)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2.5, width: 1, height: 1)
        }
        //End: Uniquement pour les iPads
        present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonToAttestionDeScolarite(_ sender: BtnPleinLarge) {
        self.bulletinAttestationDeScolarite.backgroundViewStyle = .blurredDark
        self.bulletinAttestationDeScolarite.showBulletin(above: self)
        self.demande.type = .Scolarite
    }
    
    @objc func buttonToAttestionDeReussite(_ sender: BtnPleinLarge) {
        self.bulletinAttestationDeScolarite.backgroundViewStyle = .blurredDark
        self.bulletinAttestationDeScolarite.showBulletin(above: self)
        self.demande.type = .Reussite
    }
    
    @objc func buttonToAttestionDeInsciption(_ sender: BtnPleinLarge) {
        self.bulletinAttestationDeScolarite.backgroundViewStyle = .blurredDark
        self.bulletinAttestationDeScolarite.showBulletin(above: self)
        self.demande.type = .Inscription
    }
    
    @objc func buttonToAttestionDeReussiteAuDiplome(_ sender: BtnPleinLarge) {
        self.bulletinAttestationDeScolarite.backgroundViewStyle = .blurredDark
        self.bulletinAttestationDeScolarite.showBulletin(above: self)
        self.demande.type = .ReussiteDiplome
    }
    
}

