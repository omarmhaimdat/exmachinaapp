//
//  InfoUtileViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//
import UIKit
import SPStorkController

class InfoUtileViewController: UIViewController {
    
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
    
    let paiement: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToPaiement(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Paiement\nModalités de paiement")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 8))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(9, 21))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 8))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(9, 21))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1).cgColor
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
    
    let biblio: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToBiblio(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Bibliothèque\nHoraires")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 12))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(13, 8))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 12))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(13, 8))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.2392156863, blue: 0, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.7098039216, green: 0.2392156863, blue: 0, alpha: 1).cgColor
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
    
    let scolarite: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToScolarite(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Scolarité\nHoraires")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 9))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(10, 8))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 8))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.1521916687, green: 0.6835762858, blue: 0.376893878, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.1521916687, green: 0.6835762858, blue: 0.376893878, alpha: 1).cgColor
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
        contentView.addSubview(paiement)
        contentView.addSubview(biblio)
        contentView.addSubview(scolarite)
        setupLayout()
    }
    
    func setupTabBar() {
        self.navigationItem.title = "Informations Utiles"
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
        paiement.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        paiement.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        paiement.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        paiement.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        biblio.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        biblio.topAnchor.constraint(equalTo: paiement.bottomAnchor, constant: 20).isActive = true
        biblio.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        biblio.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        scolarite.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scolarite.topAnchor.constraint(equalTo: biblio.bottomAnchor, constant: 20).isActive = true
        scolarite.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        scolarite.heightAnchor.constraint(equalToConstant: 100).isActive = true
        scolarite.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
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
    
    @objc func buttonToPaiement(_ sender: BtnPleinLarge) {
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        let controller = PaiementViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.customHeight = screenHeight/1.2
        transitionDelegate.tapAroundToDismissEnabled = true
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.translateForDismiss = 100
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        controller.color = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func buttonToBiblio(_ sender: BtnPleinLarge) {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        let controller = HorairesViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.customHeight = screenHeight/1.5
        transitionDelegate.tapAroundToDismissEnabled = true
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.translateForDismiss = 100
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        controller.color = #colorLiteral(red: 0.7098039216, green: 0.2392156863, blue: 0, alpha: 1)
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func buttonToScolarite(_ sender: BtnPleinLarge) {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        let controller = HorairesViewController()
        let transitionDelegate = SPStorkTransitioningDelegate()
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.showCloseButton = true
        transitionDelegate.customHeight = screenHeight/1.5
        transitionDelegate.tapAroundToDismissEnabled = true
        transitionDelegate.swipeToDismissEnabled = true
        transitionDelegate.translateForDismiss = 100
        transitionDelegate.hapticMoments = [.willPresent, .willDismiss]
        controller.transitioningDelegate = transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalPresentationCapturesStatusBarAppearance = true
        
        controller.color = #colorLiteral(red: 0.1521916687, green: 0.6835762858, blue: 0.376893878, alpha: 1)
        self.present(controller, animated: true, completion: nil)
    }
}
