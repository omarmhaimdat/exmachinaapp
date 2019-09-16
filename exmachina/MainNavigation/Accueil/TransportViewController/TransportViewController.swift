//
//  TransportViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseDatabase
import PDFKit

class TransportViewController: UIViewController {
    
    let contentView = UIView()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()
    
    let circuits: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToCircuit(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Circuits\nHoraires des circuits")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 8))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(9, 21))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 8))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(9, 21))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.462745098, green: 0.4549019608, blue: 0.8666666667, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.462745098, green: 0.4549019608, blue: 0.8666666667, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.462745098, green: 0.4549019608, blue: 0.8666666667, alpha: 1).cgColor
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
    
    let navette: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToNavette(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Navette\nHoraires des navettes")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 7))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(8, 21))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 7))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(8, 21))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        cours.backgroundColor = #colorLiteral(red: 0.5803921569, green: 0.5764705882, blue: 0.8941176471, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.5803921569, green: 0.5764705882, blue: 0.8941176471, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.5803921569, green: 0.5764705882, blue: 0.8941176471, alpha: 1).cgColor
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
        contentView.addSubview(circuits)
        contentView.addSubview(navette)
        setupLayout()
        setupLoadingControl()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Transport"
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
        circuits.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circuits.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        circuits.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        circuits.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        navette.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navette.topAnchor.constraint(equalTo: circuits.bottomAnchor, constant: 20).isActive = true
        navette.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        navette.heightAnchor.constraint(equalToConstant: 100).isActive = true
        navette.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -60).isActive = true
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
    
    func setupLoadingControl() {
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc func buttonToCircuit(_ sender: BtnPleinLarge) {
        
        self.activityIndicatorView.startAnimating()
        
        let ref = Database.database().reference().child("data").child("transport")
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                guard let url = URL(string: dictionary["circuits"] as? String ?? "") else { return }
                
                let pdfView = PDFView(frame: self.view.frame)
                pdfView.backgroundColor = .lightGray
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                
                self.run(after: 0.5) {
                    DispatchQueue.main.async {
                        let pdfDocument = PDFDocument(url: url)
                        pdfView.document = pdfDocument
                        let detailVC = PdfViewerViewController()
                        detailVC.pdfView = pdfView
                        detailVC.fileName = "Circuits"
                        self.navigationController?.pushViewController(detailVC, animated: true)
                        self.activityIndicatorView.stopAnimating()
                        
                    }
                }
            }
        }, withCancel: nil)
        
    }
    
    @objc func buttonToNavette(_ sender: BtnPleinLarge) {
        
        self.activityIndicatorView.startAnimating()
        
        let ref = Database.database().reference().child("data").child("transport")
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                guard let url = URL(string: dictionary["navette"] as? String ?? "") else { return }
                
                let pdfView = PDFView(frame: self.view.frame)
                pdfView.backgroundColor = .lightGray
                pdfView.displayMode = .singlePageContinuous
                pdfView.autoScales = true
                pdfView.displayDirection = .vertical
                
                self.run(after: 0.5) {
                    DispatchQueue.main.async {
                        let pdfDocument = PDFDocument(url: url)
                        pdfView.document = pdfDocument
                        let detailVC = PdfViewerViewController()
                        detailVC.pdfView = pdfView
                        detailVC.fileName = "Navette"
                        self.navigationController?.pushViewController(detailVC, animated: true)
                        self.activityIndicatorView.stopAnimating()
                        
                    }
                }
            }
        }, withCancel: nil)
        
    }
    
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
}
