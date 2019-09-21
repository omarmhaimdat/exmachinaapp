//
//  PaiementViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 07-09-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import SwiftEntryKit
import SPStorkController

class PaiementViewController: UIViewController, UIScrollViewDelegate {
    
    var color = UIColor()
    
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
    
    let imageHoraire: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "scolarite").resized(newSize: CGSize(width: 60, height: 60)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let labelPaiement: UILabel = {
        let label = UILabel()
        label.text = "Modalités de paiement\n"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-Medium", size: 28)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    let cheque: UITextView = {
        let textView = UITextView()
        textView.text = "Chèque barré non endossable à l'ordre de:"
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        
        textView.textColor = UIColor.white
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.font = UIFont(name: "Avenir-Heavy", size: 18)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let chequeText: UITextView = {
        let textView = UITextView()
        textView.text = "\u{2022} UIC\n\u{2022} UNIVERSITE INTERNATIONALE DE CASABLANCA"
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        
        textView.textColor = UIColor.white
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.font = UIFont(name: "Avenir", size: 16)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let virement: UITextView = {
        let textView = UITextView()
        textView.text = "Versement ou Virement bancaire:"
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        
        textView.textColor = UIColor.white
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.font = UIFont(name: "Avenir-Heavy", size: 18)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let labelNumCompte: UILabel = {
        let label = UILabel()
        label.text = "\u{2022} Numéro de compte:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir", size: 18)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    let numCompte: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        btn.addTarget(self, action: #selector(buttonToCopyNumCompte(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("0205 H 000000223", for: .normal)
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
        btn.layer.cornerRadius = 8
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        btn.layer.shadowOffset = CGSize(width: 1, height: 5)
        btn.layer.cornerRadius = 10
        btn.layer.shadowRadius = 8
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        
        return btn
    }()
    
    let labelRib: UILabel = {
        let label = UILabel()
        label.text = "\u{2022} R.I.B:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir", size: 20)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    let rib: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        btn.addTarget(self, action: #selector(buttonToCopyRIB(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("007 780 0002058000000223", for: .normal)
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 20)
        btn.layer.cornerRadius = 8
        btn.layer.shadowOpacity = 0.3
        btn.layer.shadowColor = UIColor.white.cgColor
        btn.layer.shadowOffset = CGSize(width: 1, height: 5)
        btn.layer.cornerRadius = 10
        btn.layer.shadowRadius = 8
        btn.layer.masksToBounds = true
        btn.clipsToBounds = false
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = self.color
        scrollView.backgroundColor = self.color
        scrollView.delegate = self
        setupScrollView()
        contentView.backgroundColor = self.color
        
        contentView.addSubview(imageHoraire)
        contentView.addSubview(labelPaiement)
        contentView.addSubview(cheque)
        contentView.addSubview(chequeText)
        contentView.addSubview(virement)
        contentView.addSubview(labelNumCompte)
        contentView.addSubview(numCompte)
        contentView.addSubview(labelRib)
        contentView.addSubview(rib)
        
        setupLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
    
    func setupLayout() {
        imageHoraire.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageHoraire.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40).isActive = true
        
        labelPaiement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelPaiement.topAnchor.constraint(equalTo: imageHoraire.bottomAnchor, constant: 20).isActive = true
        labelPaiement.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        cheque.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cheque.topAnchor.constraint(equalTo: labelPaiement.bottomAnchor, constant: 20).isActive = true
        cheque.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        chequeText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chequeText.topAnchor.constraint(equalTo: cheque.bottomAnchor, constant: 2).isActive = true
        chequeText.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        chequeText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        
        virement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        virement.topAnchor.constraint(equalTo: chequeText.bottomAnchor, constant: 20).isActive = true
        virement.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        labelNumCompte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelNumCompte.topAnchor.constraint(equalTo: virement.bottomAnchor, constant: 20).isActive = true
        labelNumCompte.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        numCompte.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        numCompte.topAnchor.constraint(equalTo: labelNumCompte.bottomAnchor, constant: 20).isActive = true
        numCompte.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        numCompte.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        labelRib.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelRib.topAnchor.constraint(equalTo: numCompte.bottomAnchor, constant: 20).isActive = true
        labelRib.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        rib.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rib.topAnchor.constraint(equalTo: labelRib.bottomAnchor, constant: 20).isActive = true
        rib.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        rib.heightAnchor.constraint(equalToConstant: 60).isActive = true
        rib.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
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
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20).isActive = true
        
    }
    
    @objc func buttonToCopyRIB(_ sender: BtnPleinLarge) {
        let str = "007 780 0002058000000223"
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
        attributes.displayDuration = 1
        attributes.hapticFeedbackType = .success
        attributes.statusBar = .light
        generator.selectionChanged()
        let title = EKProperty.LabelContent(text: "Confirmation", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir-Heavy", size: 22)!, color: UIColor.black))
        let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "ok_black"), size: CGSize(width: 45, height: 45))
        let description = EKProperty.LabelContent(text: "Le R.I.B a été copier", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir", size: 14)!, color: .black))
        let simpleMessage =  EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    @objc func buttonToCopyNumCompte(_ sender: BtnPleinLarge) {
        let str = "0205 H 000000223"
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
        attributes.displayDuration = 1
        attributes.statusBar = .light
        attributes.hapticFeedbackType = .success
        generator.selectionChanged()
        let title = EKProperty.LabelContent(text: "Confirmation", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir-Heavy", size: 22)!, color: UIColor.black))
        let image = EKProperty.ImageContent(image: #imageLiteral(resourceName: "ok_black"), size: CGSize(width: 45, height: 45))
        let description = EKProperty.LabelContent(text: "Le numéro de compte a été copier", style: EKProperty.LabelStyle(font: UIFont(name: "Avenir", size: 14)!, color: .black))
        let simpleMessage =  EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
}

