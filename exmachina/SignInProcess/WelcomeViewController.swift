//
//  WelcomeViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 16-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var isFirstOpen = true
    
    var configuration = AWSConfigOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // === Set up configuration === //
        
        configuration.appName = "Ex-Machina"
        configuration.appDescription = "Great new tools for notes synced to your iCloud account."
        configuration.tintColor = UIColor(named: "exmachina")!
        
        var item1 = AWSItem()
        item1.image = UIImage(named: "item1")
        item1.title = "Add almost anything"
        item1.description = "Capture documents, photos, maps, and more for a richer Notes experience."
        
        var item2 = AWSItem()
        item2.image = UIImage(named: "item2")
        item2.title = "Note to self, or with anyone"
        item2.description = "Invite others to view or make changes to a note."
        
        var item3 = AWSItem()
        item3.image = UIImage(named: "item3")
        item3.title = "Sketch your thoughts"
        item3.description = "Draw using just your finger."
        
        configuration.items = [item1, item2, item3]
        
        configuration.continueButtonAction = {
            self.dismiss(animated: true)
        }
    }
    
    @objc func showWelcomeScreen() {
        let vc = AWSViewController()
        vc.configuration = configuration
        self.present(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.isFirstOpen {
            self.showWelcomeScreen()
            self.isFirstOpen = true
        }
        
    }
}
