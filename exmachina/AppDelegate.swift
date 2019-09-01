//
//  AppDelegate.swift
//  exmachina
//
//  Created by M'haimdat omar on 29-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications
import FBSDKLoginKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, LoginButtonDelegate, UNUserNotificationCenterDelegate {
    
    var uid: String = ""
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var profileImageUrl: String = ""
    var provider: String = ""
    var dateDeCreation: String = ""

    var window: UIWindow?
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("Facebook failed to log in ", error)
            return
        }else{
            print("Facebook successfully logged in with facebook")
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if let error = error {
                print("Impossible de creer un utilisateur avec Facebook (AppDelegate)", error)
                return
            }else{
                print("Succes de l'ajout d'un utilisateur firebase avec facebook (AppDelegate)")
                self.saveUserIntoFirebaseDatabase()
            }
        })
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Facebook authentication with Firebase error: ", error)
                return
            }
            print("User signed in!")
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
        return
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Google failed to log in", error)
            return
        }else{
            print("Successfully signed in to google", user!)
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            
            if let error = error {
                
                print("Echec lors de la creation de l'utilisateur avec le google sign-in (AppDelegate)", error)
                return
            } else {
                self.saveUserIntoFirebaseDatabase()
            }
            
            UserDefaults().set(true, forKey: "userSignedIn")
            UserDefaults().synchronize()
            
            guard let user = user?.user.uid else { return }
            print("L'utilisateur s'est bien connecte avec en etant un utilisateur Google (AppDelegate)", user)
            
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        
    }
    
    ///Implemente la methode qui permet de gerer le lien que les services de google vont envoyés
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            let handledFacebook = ApplicationDelegate.shared.application(application, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            
            return handledFacebook
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        if Auth.auth().currentUser != nil && !Auth.auth().currentUser!.isAnonymous {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.makeKeyAndVisible()
//            let mainViewController = MainTabBarController()
//            window?.rootViewController = mainViewController
//        } else if Auth.auth().currentUser == nil {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.makeKeyAndVisible()
//            let onBoarding = OnboardingViewController()
//            window?.rootViewController = onBoarding
//            print("Hello onboarding")
//        } else if Auth.auth().currentUser != nil && Auth.auth().currentUser!.isAnonymous {
//            window = UIWindow(frame: UIScreen.main.bounds)
//            window?.makeKeyAndVisible()
//            let anonymousViewController = AnonymousTabBarController()
//            window?.rootViewController = anonymousViewController
//        }
        
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            if user != nil && !Auth.auth().currentUser!.isAnonymous {
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.makeKeyAndVisible()
//                let mainViewController = MainTabBarController()
//                self.window?.rootViewController = mainViewController
//            } else if user == nil {
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.makeKeyAndVisible()
//                let onBoarding = SignInViewController()
//                self.window?.rootViewController = onBoarding
//                print("Hello onboarding")
//            } else if user != nil && Auth.auth().currentUser!.isAnonymous {
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.makeKeyAndVisible()
//                let anonymousViewController = AnonymousTabBarController()
//                self.window?.rootViewController = anonymousViewController
//            }
//        }
//
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil && !Auth.auth().currentUser!.isAnonymous {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                let mainViewController = MainTabBarController()
                var options = UIWindow.TransitionOptions()
                options.direction = .toTop
                options.duration = 0.3
                options.style = .easeIn
                self.window?.setRootViewController(mainViewController, options: options)
            } else if user == nil {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                let signIn = OnboardingViewController()
                var options = UIWindow.TransitionOptions()
                options.direction = .toRight
                options.duration = 0.3
                options.style = .easeIn
                self.window?.setRootViewController(signIn, options: options)
            } else if user != nil && Auth.auth().currentUser!.isAnonymous {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.makeKeyAndVisible()
                let anonymousViewController = AnonymousTabBarController()
                var options = UIWindow.TransitionOptions()
                options.direction = .toTop
                options.duration = 0.3
                options.style = .easeIn
                self.window?.setRootViewController(anonymousViewController, options: options)
            }
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
        
        print(deviceToken.description)
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
        }
        UserDefaults.standard.setValue(token, forKey: "ApplicationIdentifier")
        UserDefaults.standard.synchronize()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    fileprivate func saveUserIntoFirebaseDatabase() {
        
        uid = Auth.auth().currentUser!.uid
        name = (Auth.auth().currentUser?.displayName)!
        email = (Auth.auth().currentUser?.email)!
        profileImageUrl = (Auth.auth().currentUser?.photoURL!.absoluteString)!
        provider = Auth.auth().currentUser?.providerData[0].providerID ?? "provider"
        let dateToday = DateFormatter()
        dateToday.locale = Locale(identifier: "fr_FR")
        dateToday.setLocalizedDateFormatFromTemplate("MM yyyy")
        dateDeCreation = dateToday.string(from: Date())
        let ref = Database.database().reference()
        
        ref.child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists() == false {
                ref.child("users").child(self.uid).setValue(["faculte": "Sélectionner la faculté",
                                                             "filiere": "Sélectionner la filière",
                                                             "semestre": "Sélectionner le semestre",
                                                             "new": true,
                                                             "uid": self.uid,
                                                             "name": self.name,
                                                             "email": self.email,
                                                             "profileImageUrl": self.profileImageUrl,
                                                             "provider": self.provider,
                                                             "dateDeCreation": self.dateDeCreation
                                                             ])
            }
        }, withCancel: nil)
    }

}

