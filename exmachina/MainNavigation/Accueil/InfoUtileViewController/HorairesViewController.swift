//
//  HorairesViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 01-09-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import SPStorkController

class HorairesViewController: UIViewController, UIScrollViewDelegate {
    
    var color = UIColor()
    
    let contentView = UIView()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let imageHoraire: UIImageView = {
       let image = UIImageView(image: #imageLiteral(resourceName: "horaire-white").resized(newSize: CGSize(width: 60, height: 60)))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let labelHoraire: UILabel = {
        let label = UILabel()
        label.text = "Horaires"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-Medium", size: 40)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    let horaireText: UITextView = {
        let textView = UITextView()
        textView.text = "Lundi-Vendredi: 9h-12h30 14h-18h"
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
        textView.font = UIFont(name: "Avenir", size: 20)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let labelContact: UILabel = {
        let label = UILabel()
        label.text = "Contact"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont(name: "Avenir-Medium", size: 40)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.backgroundColor = UIColor.clear
        
        return label
    }()
    
    let tel: BtnPleinLarge = {
        let btn = BtnPleinLarge()
//        btn.addTarget(self, action: #selector(buttonToScolarite(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Téléphone", for: .normal)
        btn.layer.backgroundColor = UIColor.black.cgColor
        btn.layer.borderColor = UIColor.black.cgColor
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 24)
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
    
    let email: BtnPleinLarge = {
        let btn = BtnPleinLarge()
        //        btn.addTarget(self, action: #selector(buttonToScolarite(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Email", for: .normal)
        btn.layer.backgroundColor = UIColor.white.cgColor
        btn.layer.borderColor = UIColor.white.cgColor
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 24)
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
    
    let barreContact: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = CGFloat(exactly: 8)!
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = self.color
        scrollView.backgroundColor = self.color
        scrollView.delegate = self
        
        setupScrollView()
        contentView.backgroundColor = self.color
        
        barreContact.addArrangedSubview(tel)
        barreContact.addArrangedSubview(email)
        
        contentView.addSubview(imageHoraire)
        contentView.addSubview(labelHoraire)
        contentView.addSubview(horaireText)
        contentView.addSubview(labelContact)
        contentView.addSubview(barreContact)
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.labelContact.isHidden = true
        self.barreContact.isHidden = true
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
        
        labelHoraire.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelHoraire.topAnchor.constraint(equalTo: imageHoraire.bottomAnchor, constant: 20).isActive = true
        labelHoraire.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        horaireText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        horaireText.topAnchor.constraint(equalTo: labelHoraire.bottomAnchor, constant: 20).isActive = true
        horaireText.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        labelContact.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelContact.topAnchor.constraint(equalTo: horaireText.bottomAnchor, constant: 20).isActive = true
        labelContact.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        
        tel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        email.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        barreContact.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barreContact.topAnchor.constraint(equalTo: labelContact.bottomAnchor, constant: 20).isActive = true
        barreContact.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        barreContact.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
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
    
}
