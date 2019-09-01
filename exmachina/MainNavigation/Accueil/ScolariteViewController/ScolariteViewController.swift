//
//  ScolariteViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ScolariteViewController: UIViewController {
    
    var emailFCG = ScolariteEmail()
    var emailING = ScolariteEmail()
    var emailFSS = ScolariteEmail()
    
    let contentView = UIView()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let FCG: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToFcg(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "FCG\nFaculté de Commerce et Gestion")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 3))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(4, 30))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 3))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(4, 30))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.3450980392, blue: 0.2862745098, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.9309732318, green: 0.3448041677, blue: 0.2861674726, alpha: 1).cgColor
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
    
    let ING: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToIng(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "ING\nÉcole d'Ingénierie")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 3))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(4, 18))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 3))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(4, 18))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.3731170297, green: 0.283844918, blue: 0.6121758819, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.3731170297, green: 0.283844918, blue: 0.6121758819, alpha: 1).cgColor
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
    
    let FSS: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToFss(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "FSS\nFaculté des Sciences de la Santé")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 3))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(4, 32))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 3))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(4, 32))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.6980392157, blue: 0.3843137255, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.4964770675, green: 0.6988292336, blue: 0.3853608966, alpha: 1).cgColor
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
        getEmails()
        setupScrollView()
        contentView.addSubview(FCG)
        contentView.addSubview(ING)
        contentView.addSubview(FSS)
        setupLayout()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Scolarité"
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
        FCG.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        FCG.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        FCG.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        FCG.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        ING.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ING.topAnchor.constraint(equalTo: FCG.bottomAnchor, constant: 20).isActive = true
        ING.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        ING.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        FSS.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        FSS.topAnchor.constraint(equalTo: ING.bottomAnchor, constant: 20).isActive = true
        FSS.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        FSS.heightAnchor.constraint(equalToConstant: 100).isActive = true
        FSS.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
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
    
    private func getEmails() {
        let ref = Database.database().reference().child("data").child("scolarite")
        ref.child("FCG").observe(DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var email = ScolariteEmail()
                email.piece = (dictionary["piece"] as! String?)!
                email.responsable = (dictionary["responsable"] as! String?)!
                email.responsableEmail = (dictionary["responsableEmail"] as! String?)!
                self.emailFCG = email
            }
        }, withCancel: nil)
        
        ref.child("ING").observe(DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var email = ScolariteEmail()
                email.piece = (dictionary["piece"] as! String?)!
                email.responsable = (dictionary["responsable"] as! String?)!
                email.responsableEmail = (dictionary["responsableEmail"] as! String?)!
                self.emailING = email
            }
        }, withCancel: nil)
        
        ref.child("FSS").observe(DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var email = ScolariteEmail()
                email.piece = (dictionary["piece"] as! String?)!
                email.responsable = (dictionary["responsable"] as! String?)!
                email.responsableEmail = (dictionary["responsableEmail"] as! String?)!
                self.emailFSS = email
            }
        }, withCancel: nil)
    }
    
    @objc func buttonToIng(_ sender: BtnPleinLarge) {
        let controller = IngScolariteViewController()
        controller.email = self.emailING
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToFcg(_ sender: BtnPleinLarge) {
        let controller = FcgScolariteViewController()
        controller.email = self.emailFCG
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToFss(_ sender: BtnPleinLarge) {
        let controller = FssScolariteViewController()
        controller.email = self.emailFSS
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
