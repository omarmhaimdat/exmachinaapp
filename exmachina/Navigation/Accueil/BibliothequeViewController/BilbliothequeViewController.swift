//
//  BilbliothequeViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import MessageUI
import BLTNBoard

class BibliothequeViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private var demande = Demande()
    
    let contentView = UIView()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    lazy var bulletinAttestationDeScolarite: BLTNItemManager = {
        let rootItem: BLTNItem = nomAttestationDeScolarite()
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    let responsable: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Responsable\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(12, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(12, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.7333333333, green: 0.3058823529, blue: 0.09019607843, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.7333333333, green: 0.3058823529, blue: 0.09019607843, alpha: 1).cgColor
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
    
    let reserverUneSalle: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToAttestionDeScolarite(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Attestation de scolarité\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 24))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(25, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 24))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(25, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.7882352941, green: 0.4431372549, blue: 0.2705882353, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.7882352941, green: 0.4431372549, blue: 0.2705882353, alpha: 1).cgColor
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
        
        blt.actionHandler = { (item: BLTNActionItem) in
            self.demande.nombreExemplaire = "\(blt.selected)"
            
            item.manager?.dismissBulletin(animated: true)
            self.sendEmail()
        }
        blt.alternativeButtonTitle = "Précedent"
        blt.appearance.alternativeButtonTitleColor = UIColor(red:0.78, green:0.78, blue:0.78, alpha:1.0)
        blt.alternativeHandler = { (item: BLTNActionItem) in
            item.manager?.popItem()
        }
        return blt
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupScrollView()
        contentView.addSubview(responsable)
        contentView.addSubview(reserverUneSalle)
        setupLayout()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "ING"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupLayout() {
        responsable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        responsable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        responsable.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        responsable.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        reserverUneSalle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        reserverUneSalle.topAnchor.constraint(equalTo: responsable.bottomAnchor, constant: 20).isActive = true
        reserverUneSalle.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        reserverUneSalle.heightAnchor.constraint(equalToConstant: 100).isActive = true
        reserverUneSalle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
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
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["piecesing@uic.ac.ma"])
            mail.setSubject("Demande d'Attestion de Scolarité")
            mail.setMessageBody("<p>Bonjour Monsieur/Madame,</p>Je souhaiterai demander une attestation de scolarité, voici mes informations personnelles :<p><b>Nom au complet:</b> \(self.demande.nomAuComplet)</p><p><b>CIN:</b> \(self.demande.cin)</p><p><b>Date de naissance:</b> \(self.demande.dateDeNaissance)</p><p><b>Nombre d'exemplaire:</b> \(self.demande.nombreExemplaire)</p><p>Bien à vous,</p>", isHTML: true)
            
            self.present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc func buttonToAttestionDeScolarite(_ sender: BtnPleinLarge) {
        self.bulletinAttestationDeScolarite.backgroundViewStyle = .blurredDark
        self.bulletinAttestationDeScolarite.showBulletin(above: self)
    }
}
