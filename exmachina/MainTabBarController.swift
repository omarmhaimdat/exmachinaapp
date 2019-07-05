//
//  MainTabBarController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTabBar()
        tabBar.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 0.1)
        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.isTranslucent = true
    }
    
    func setupTabBar() {
        
        let AccueilController = UINavigationController(rootViewController: AccueilViewController())
        AccueilController.tabBarItem.image = UIImage(named: "accueil_glyph")
        AccueilController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        AccueilController.tabBarItem.title = "Accueil"
        
        let CoursesController = UINavigationController(rootViewController: CoursesViewController())
        CoursesController.tabBarItem.image = UIImage(named: "icons8-books")
        CoursesController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        CoursesController.tabBarItem.title = "Courses"
        
        let FavorisController = UINavigationController(rootViewController: FavorisViewController())
        FavorisController.tabBarItem.image = UIImage(named: "icons8-add-to-favorites")
        FavorisController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        FavorisController.tabBarItem.title = "Favoris"
        
        let OfflineController = UINavigationController(rootViewController: OfflineViewController())
        OfflineController.tabBarItem.image = UIImage(named: "icons8-below")
        OfflineController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
        OfflineController.tabBarItem.title = "Offline"
        
        viewControllers = [AccueilController, CoursesController, FavorisController, OfflineController]
        
        UITabBar.appearance().tintColor = UIColor(named: "exmachina")
        let navigation = UINavigationBar.appearance()

        let navigationFont = UIFont(name: "Avenir", size: 20)
        let navigationLargeFont = UIFont(name: "Avenir-Heavy", size: 34)
       

        navigation.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationFont!]

        if #available(iOS 11, *) { 
            navigation.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationLargeFont!]
        }
    }
}
