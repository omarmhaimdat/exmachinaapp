//
//  PdfViewerViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 31-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import PDFKit
import NVActivityIndicatorView

class PdfViewerViewController: UIViewController {
    
    var pdfView: PDFView!
    var fileName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        view.addSubview(pdfView)
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    
    func setupTabBar() {
        if let name = fileName {
            navigationItem.title = "\(name)"
        }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButtonItemClicked(_:)))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    func setupLayout() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pdfView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        pdfView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        if #available(iOS 13.0, *) {
            pdfView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            pdfView.backgroundColor = .white
        }
        
    }
    
    @objc func shareBarButtonItemClicked(_ sender: UIBarButtonItem) {
        guard let items = [self.pdfView.document?.documentURL as Any] as? [URL] else { return }
        let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        //If user on iPad
        if UIDevice.current.userInterfaceIdiom == .pad {
            if avc.responds(to: #selector(getter: UIViewController.popoverPresentationController)) {
                avc.popoverPresentationController?.barButtonItem = sender
            }
        }
        //Present the shareView on iPhone
        self.present(avc, animated: true, completion: nil)
    }

}
