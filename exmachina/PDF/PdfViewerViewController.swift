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
        view.backgroundColor = UIColor.white
        if let name = fileName {
            navigationItem.title = "\(name)"
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButtonItemClicked(_:)))
    }
    
    func setupLayout() {
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pdfView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        pdfView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
    }
    
    @objc func shareBarButtonItemClicked(_ sender: UIBarButtonItem) {
        guard let items = [self.pdfView.document?.documentURL as Any] as? [Any] else { return }
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
