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
    var infoBiblio = ScolariteEmail()
    
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
        cours.addTarget(self, action: #selector(buttonToResponsable(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Responsable\nSonia BARNACHI")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(12, 14))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(12, 14))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.1254901961, green: 0.5607843137, blue: 1, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.1254901961, green: 0.5607843137, blue: 1, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.1254901961, green: 0.5607843137, blue: 1, alpha: 1)
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
        let str = NSMutableAttributedString(string: "Réserver une salle\n7 jours ouvrables")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 18))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(19, 17))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 18))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(19, 17))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.2980392157, green: 0.6470588235, blue: 1, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.2980392157, green: 0.6470588235, blue: 1, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.2980392157, green: 0.6470588235, blue: 1, alpha: 1)
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
        let bltItem: BLTNItem = self.heurettestationDeScolarite()
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
    
    fileprivate func heurettestationDeScolarite() -> TimePickerBLTNItem {
        let blt = TimePickerBLTNItem(title: "Date et Heure")
        blt.descriptionText = "Veuillez saisir la date et l'heure"
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
        blt.datePicker.datePickerMode = .dateAndTime
        blt.actionHandler = { (item: BLTNActionItem) in
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = DateFormatter.Style.medium
            timeFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            print("----- Selected:  \(timeFormatter.string(from: blt.datePicker.date)) -------")
            self.demande.dateDeNaissance = "\(timeFormatter.string(from: blt.datePicker.date))"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let str = NSMutableAttributedString(string: "Responsable\n\(self.infoBiblio.responsable)")
        let size = self.infoBiblio.responsable.count
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(12, size))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 11))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(12, size))
        str.setLineSpacing(8)
        responsable.setAttributedTitle(str, for: .normal)
    }
    
    func setupTabBar() {
        self.navigationItem.title = "Bibliothèque"
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
            mail.setToRecipients(["\(self.infoBiblio.responsableEmail)"])
            mail.setSubject("Réservation de Salle")
            mail.setMessageBody("<p>Bonjour Monsieur/Madame,</p>Je souhaiterai réserver une salle, voici mes informations personnelles et l'horaire:<p><b>Nom au complet:</b> \(self.demande.nomAuComplet)</p><p><b>CIN:</b> \(self.demande.cin)</p><p><b>Date et heure:</b> \(self.demande.dateDeNaissance)</p><p>Bien à vous,</p>", isHTML: true)
            
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
    
    @objc func buttonToResponsable(_ sender: BtnPleinLarge) {
        let alert = UIAlertController(title: "\(self.infoBiblio.responsable)", message: nil, preferredStyle: .actionSheet)
        
        let annulerAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
            
        }
        
        let appeler = UIAlertAction(title: "Contacter par téléphone", style: .default) { action -> Void in
            if let url = URL(string: "tel://\(self.infoBiblio.tel)"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // add error message here
            }
        }
        
        let email = UIAlertAction(title: "Contacter par email", style: .default) { action -> Void in
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["\(self.infoBiblio.responsableEmail)"])
                
                self.present(mail, animated: true)
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
    
}
