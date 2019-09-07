//
//  SignInViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import SwiftWebVC
import GoogleSignIn
import Firebase
import FirebaseAuth
import FirebaseDatabase
import JGProgressHUD
import FBSDKCoreKit
import FBSDKLoginKit
import Reachability
import SwiftEntryKit

class SignInViewController: UIViewController, GIDSignInUIDelegate, LoginButtonDelegate {
    
    private let reachability = Reachability(hostname: "www.ex-machina.ma")
    
    var ref = Database.database().reference()
    
    var uid: String = ""
    var name: String = ""
    var username: String = ""
    var email: String = ""
    var profileImageUrl: String = ""
    var provider: String = ""
    var dateDeCreation: String = ""
    var isInTheDataBase = false
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("Facebook failed to log in ", error)
            return
        } else if result!.isCancelled {
            print("L'utilisateur a annulé son login avec facebook")
            return
        } else {
            print("Facebook successfully logged in with facebook")
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                print("Facebook authentication with Firebase error: ", error)
                return
            }
            
            print("User signed in!")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("The user did logout of facebook")
        return
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if let error = error {
            print("Google failed to log in (controller)", error)
            return
        }else {
            print("Successfully signed in to google", user!)
        }
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential, completion: {(user, error) in
            if let error = error {
                print("Echec lors de la creation de l'utilisateur avec le google sign-in (SignInUIViewController)", error)
                
                return
            } else {
                self.saveUserIntoFirebaseDatabase()
            }
            
            UserDefaults().set(true, forKey: "isLoggedIn")
            UserDefaults().synchronize()
            
            
            guard let user = user?.user.uid else { return }
            print("L'utilisateur s'est bien connecte avec en etant un utilisateur Google (SignInUIViewController)", user)
            
        })
    }
    
    let nameLogo: UITextView = {
        let textView = UITextView()
        textView.text = "Bienvenue"
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        textView.textColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.8)
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.font = UIFont(name: "Avenir-Heavy", size: screenHeight/15)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let logoImage: UIImageView = {
       let image = UIImageView(image: #imageLiteral(resourceName: "logo_sign_in"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let textPourCGU: UITextView = {
        let textView = UITextView()
        textView.text = "En continuant, vous reconnaissez avoir lu et accepté les"
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        
        textView.textColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.6)
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.font = UIFont(name: "Avenir", size: screenHeight/60)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let btnCGU: UIButton = {
        let btnCGULink = UIButton()
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        btnCGULink.translatesAutoresizingMaskIntoConstraints = false
        btnCGULink.contentHorizontalAlignment = .center
        
        var attrs = [
            NSAttributedString.Key.font : UIFont(name: "Avenir", size: screenHeight/60) as Any,
            NSAttributedString.Key.foregroundColor : UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.6),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
        var attributedString = NSMutableAttributedString(string:"")
        
        let buttonTitleStr = NSMutableAttributedString(string:"Conditions générales d'utilisation", attributes:attrs)
        attributedString.append(buttonTitleStr)
        btnCGULink.setAttributedTitle(attributedString, for: .normal)
        btnCGULink.addTarget(self, action: #selector(openLinkCGU(sender:)), for: .touchUpInside)
        return btnCGULink
    }()
    
    let textCredit: UITextView = {
        let textView = UITextView()
        let year = Calendar.current.component(.year, from: Date())
        textView.text = "© Ex-Machina Inc. \(year)"
        textView.translatesAutoresizingMaskIntoConstraints = false
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let atributes = [NSAttributedString.Key.paragraphStyle: style ]
        textView.attributedText = NSAttributedString(string: textView.text, attributes: atributes)
        textView.textColor = UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.6)
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.font = UIFont(name: "Avenir-bold", size: screenHeight/50)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    let googleSignInButton: BtnGoogleSignIn = {
        let btnGoogle = BtnGoogleSignIn()
        btnGoogle.translatesAutoresizingMaskIntoConstraints = false
        btnGoogle.setTitle("Se connecter avec google", for: .normal)
        btnGoogle.contentHorizontalAlignment = .center
        btnGoogle.addTarget(self, action: #selector(handleCustomGoogleButton), for: .touchUpInside)
        
        return btnGoogle
    }()
    
    let facebookSignInButton: BtnFacebookSignIn = {
        let btnFacebook = BtnFacebookSignIn()
        btnFacebook.translatesAutoresizingMaskIntoConstraints = false
        btnFacebook.setTitle("Se connecter avec facebook", for: .normal)
        btnFacebook.contentHorizontalAlignment = .center
        btnFacebook.addTarget(self, action: #selector(handleCustomFacebookButton), for: .touchUpInside)
        
        return btnFacebook
    }()
    
    let anonymousSignInButton: BtnAnonymousSignIn = {
        let btnFacebook = BtnAnonymousSignIn()
        btnFacebook.translatesAutoresizingMaskIntoConstraints = false
        btnFacebook.setTitle("Se connecter anonymement", for: .normal)
        btnFacebook.contentHorizontalAlignment = .center
        btnFacebook.addTarget(self, action: #selector(handleCustomAnonymous), for: .touchUpInside)
        
        return btnFacebook
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(googleSignInButton)
        view.addSubview(anonymousSignInButton)
        view.addSubview(facebookSignInButton)
        view.addSubview(nameLogo)
        view.addSubview(logoImage)
        view.addSubview(textPourCGU)
        view.addSubview(btnCGU)
        view.addSubview(textCredit)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
//        Auth.auth().addStateDidChangeListener() { auth, user in
//            if user != nil && !Auth.auth().currentUser!.isAnonymous {
//                DispatchQueue.main.async {
//                    let viewController = MainTabBarController()
//                    UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
//                    print("pushViewController depuis SignInViewController \(Auth.auth().currentUser?.displayName ?? "Nom de l'utilisateur")")
//                }
//            } else if user != nil && Auth.auth().currentUser!.isAnonymous {
//                DispatchQueue.main.async {
//                    let viewController = AnonymousTabBarController()
//                    UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
//                    print("pushViewController depuis SignInViewController \(Auth.auth().currentUser?.displayName ?? "Nom de l'utilisateur")")
//                }
//            } else {
//                print("User logged out (From SignInViewController)")
//            }
//        }
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.layer.zPosition = -1
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        view.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isToolbarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.layer.zPosition = -1
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    private func setupLayout() {
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        if UIDevice().userInterfaceIdiom == .pad {
            
            anonymousSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            anonymousSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/3.8).isActive = true
            anonymousSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
            anonymousSignInButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            googleSignInButton.bottomAnchor.constraint(equalTo: anonymousSignInButton.bottomAnchor, constant: -100).isActive = true
            googleSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
            googleSignInButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

            facebookSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            facebookSignInButton.bottomAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: -110).isActive = true
            facebookSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 100).isActive = true
            facebookSignInButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            textCredit.topAnchor.constraint(equalTo: btnCGU.bottomAnchor, constant: screenHeight/18).isActive = true
            textCredit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            textCredit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        }
        
        if UIDevice().userInterfaceIdiom == .phone {
            
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                anonymousSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                anonymousSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/3.8).isActive = true
                anonymousSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
                anonymousSignInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                googleSignInButton.bottomAnchor.constraint(equalTo: anonymousSignInButton.bottomAnchor, constant: -60).isActive = true
                googleSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
                googleSignInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                facebookSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                facebookSignInButton.bottomAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: -60).isActive = true
                facebookSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
                facebookSignInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                textCredit.topAnchor.constraint(equalTo: btnCGU.bottomAnchor, constant: screenHeight/16).isActive = true
                textCredit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                textCredit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            default:
                anonymousSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                anonymousSignInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height/3.8).isActive = true
                anonymousSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
                anonymousSignInButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
                
                googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                googleSignInButton.bottomAnchor.constraint(equalTo: anonymousSignInButton.bottomAnchor, constant: -75).isActive = true
                googleSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
                googleSignInButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
                
                facebookSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                facebookSignInButton.bottomAnchor.constraint(equalTo: googleSignInButton.bottomAnchor, constant: -75).isActive = true
                facebookSignInButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
                facebookSignInButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
                
                textCredit.topAnchor.constraint(equalTo: btnCGU.bottomAnchor, constant: screenHeight/16).isActive = true
                textCredit.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
                textCredit.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            }
        }
            
            
        
        nameLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/15).isActive = true
        nameLogo.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        nameLogo.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        logoImage.topAnchor.constraint(equalTo: nameLogo.bottomAnchor, constant: 10).isActive = true
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        logoImage.widthAnchor.constraint(equalToConstant: screenHeight/5.2).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: screenHeight/5.2).isActive = true
        
        textPourCGU.topAnchor.constraint(equalTo: anonymousSignInButton.bottomAnchor, constant: screenHeight/20).isActive = true
        textPourCGU.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        textPourCGU.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        btnCGU.topAnchor.constraint(equalTo: textPourCGU.bottomAnchor, constant: 0).isActive = true
        btnCGU.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        btnCGU.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
    }
    
    @objc func openLinkCGU(sender: UIButton) {
        let webVC = SwiftModalWebVC(urlString: "https://courses.ex-machina.ma", theme: .lightBlue, dismissButtonStyle: .cross)
        self.present(webVC, animated: true, completion: nil)
        print("CGU PRESSED !")
    }
    
    @objc func handleCustomGoogleButton() {
        
        self.hud.textLabel.text = "Connection avec google....."
        self.hud.show(in: self.view, animated: true)
        
        GIDSignIn.sharedInstance()?.signIn()
        
        self.hud.dismiss(afterDelay: 5, animated: true)
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func handleCustomAnonymous() {
        
        self.hud.textLabel.text = "Connection anonyme....."
        self.hud.show(in: self.view, animated: true)
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            // ...
        }
        
        self.hud.dismiss(afterDelay: 5, animated: true)
        
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        UserDefaults.standard.synchronize()
        
    }
    
    fileprivate func saveUserIntoFirebaseDatabase() {
        
        uid = Auth.auth().currentUser?.uid ?? "uid"
        name = (Auth.auth().currentUser?.displayName)!
        email = (Auth.auth().currentUser?.email)!
        profileImageUrl = Auth.auth().currentUser?.photoURL?.absoluteString ?? "photoURL"
        provider = Auth.auth().currentUser?.providerData[0].providerID ?? "provider"
        let dateToday = DateFormatter()
        dateToday.locale = Locale(identifier: "fr_FR")
        dateToday.dateStyle = .long
        dateToday.setLocalizedDateFormatFromTemplate("d MMMM yyyy")
        dateDeCreation = dateToday.string(from: Date())
        
        self.ref.child("users").child(uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if snapshot.exists() == false {
                self.isInTheDataBase = true
                self.ref.child("users").child(self.uid).setValue(["uid": self.uid,
                                                                  "name": self.name,
                                                                  "email": self.email,
                                                                  "profileImageUrl": self.profileImageUrl,
                                                                  "provider": self.provider,
                                                                  "dateDeCreation": self.dateDeCreation,
                                                                  "faculte": "Sélectionner la faculté",
                                                                  "filiere": "Sélectionner la filière",
                                                                  "semestre": "Sélectionner le semestre",
                                                                  "new": true,
                                                                  "ajoutFiliere": false])
            }
        }, withCancel: nil)
        print("HElo il est dans la database: \(isInTheDataBase)")
        
        
    }
    
    @objc func handleCustomFacebookButton() {
        
        self.hud.textLabel.text = "Connection avec facebook....."
        self.hud.show(in: self.view, animated: true)
        
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) {
            (result, err) in
            if err != nil {
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.indicatorView?.tintColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.8)
                self.hud.textLabel.text = "Échec de la connexion !"
                self.hud.dismiss(afterDelay: 1, animated: true)
                print("Custom FB Login failed:", err as Any)
                return
            }else if result!.isCancelled {
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.indicatorView?.tintColor = UIColor(red: 252/255, green: 102/255, blue: 0, alpha: 0.8)
                self.hud.textLabel.text = "Annulée !"
                self.hud.dismiss(afterDelay: 1, animated: true)
                print("l'utilisateur a annulé son inscription avec facebook")
                return
            } else {
                self.hud.textLabel.text = "Succès !"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.indicatorView?.tintColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.8)
                self.hud.dismiss(afterDelay: 2, animated: true)
                print("Le bouton Facebook marche parfaitement et l'utilisateur a reussi à se connecter")
            }
            
            self.showEmailAddressFacebook()
            
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("Facebook authentication with Firebase error: ", error)
                    return
                } else {
                    self.saveUserIntoFirebaseDatabase()
                }
                print("User signed in!")
                
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func showEmailAddressFacebook() {
        GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"]).start(completionHandler: { (connection, resultat, error) in
            if error != nil {
                print("Probleme à faire une demande du graphe de facebook ", error as Any)
                return
            }
            print(resultat as Any)
        })
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            self.promptNotification()
        }
    }
    
    private func promptNotification() {
        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        var themeImage: EKPopUpMessage.ThemeImage?
        var attributes = EKAttributes()
        attributes.hapticFeedbackType = .error
        attributes.entryBackground = .color(color: .black)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
        attributes.position = .bottom
        attributes.displayDuration = .infinity
        attributes.roundCorners = .all(radius: 15)
        
        if let image = UIImage(named: "no_connection") {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 100, height: 100), contentMode: .scaleAspectFit))
        }
        
        let title = EKProperty.LabelContent(text: "Pas de connection", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: UIColor(named: "exmachina")!, alignment: .center))
        let description = EKProperty.LabelContent(text: "Le signal internet est trop faible", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black)), backgroundColor: UIColor(named: "exmachina")!, highlightedBackgroundColor: .black)
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }

}

extension SignInViewController: SwiftWebVCDelegate {
    
    func didStartLoading() {
        print("Started loading.")
    }
    
    func didFinishLoading(success: Bool) {
        print("Finished loading. Success: \(success).")
    }
    
}

extension UIApplication {
    class func topViewController(viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(viewController: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(viewController: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(viewController: presented)
        }
        return viewController
    }
}
