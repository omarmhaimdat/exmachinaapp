//
//  ViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 29-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import SwiftyOnboard

class OnboardingViewController: UIViewController {

    var swiftyOnboard: SwiftyOnboard!
    let colors:[UIColor] = [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1),#colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)]
    var titleArray: [String] = ["Ex-Machina", "Par, pour les étudiants", "Au service des étudiants"]
    var subTitleArray: [String] = ["Club universitaire scientifique qui regroupe des étudiants de l’école d’ingénierie de l’université Internationale de Casablanca.", "Retrouvez tous les supports de cours", "L'application qui vous aide tout au long de votre cursus universitaire"]
    
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        
        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)
        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.layer.zPosition = -1
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    @objc func buttonToSignInView(sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
        let navController = UINavigationController(rootViewController: SignInViewController())
        self.present(navController, animated: true)
    }


}

extension OnboardingViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return 3
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()
        
        //Set the image on the page:
        view.imageView.image = UIImage(named: "onboard\(index)")
        
        //Set the font and color for the labels:
        view.title.font = UIFont(name: "Avenir-Heavy", size: 22)
        
        view.subTitle.font = UIFont(name: "Avenir", size: 14)
        
        //Set the text in the page:
        view.title.text = titleArray[index]
        view.title.sizeToFit()
        view.subTitle.text = subTitleArray[index]
        
        //Return the page for the given index:
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        
        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = UIFont(name: "Avenir", size: 16)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        overlay.continueButton.setTitle("Suivant", for: .normal)
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)
        
        
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Suivant", for: .normal)
            overlay.skipButton.setTitle("Passer", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Commencer", for: .normal)
            overlay.continueButton.addTarget(self, action: #selector(buttonToSignInView(sender:)), for: .touchUpInside)
            overlay.skipButton.isHidden = true
        }
    }
}


