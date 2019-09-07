//
//  AccueilViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import NVActivityIndicatorView
import LBTAComponents
import LocalAuthentication
import AppleWelcomeScreen
import Reachability
import SwiftEntryKit

private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 32
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class AccueilViewController: UIViewController, UIScrollViewDelegate {
    
    private let reachability = Reachability(hostname: "www.ex-machina.ma")
    
    private var user = User()
    private var faculte = Faculte()
    private var filiere = Filiere()
    private var semestre = Semestre()
    private var isReady = false
    private var isMyCours = false
    
    lazy var imageView: CachedImageView = {
        let profileImageViewHeight: CGFloat = 56
        var iv = CachedImageView()
        iv.backgroundColor = #colorLiteral(red: 0.8380756974, green: 0.7628322244, blue: 0, alpha: 1)
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 0
        iv.layer.borderColor = UIColor.black.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = profileImageViewHeight / 2
        var photoProfile: String = Auth.auth().currentUser?.photoURL?.absoluteString ?? "Profile"
        let photoProvider = Auth.auth().currentUser?.providerData
        for userInfo in photoProvider! {
            switch userInfo.providerID {
            case "facebook.com":
                photoProfile = photoProfile + "?height=500"
            case "google.com":
                photoProfile = photoProfile.replacingOccurrences(of: "/s96-c/photo.jpg", with: "/s400-c/photo.jpg")
            default:
                print("Autre \(userInfo.providerID)")
            }
        }
        iv.loadImage(urlString: photoProfile)
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(singleTapping(_:)))
        singleTap.numberOfTapsRequired = 1
        iv.addGestureRecognizer(singleTap)
        
        return iv
    }()
    
    let mesCours: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToMesCours(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Mes cours\nTrouver vos cours personnalisés")
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(10, 31))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 31))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        default:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(10, 31))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 31))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "mesCours")?.resized(newSize: CGSize(width: 40, height: 40))
        cours.addRightImage(image: icon!, offset: 30)
        cours.backgroundColor = #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.titleEdgeInsets.left = 0
        
        return cours
    }()
    
    let Blog: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Blog\nDernières actualités du club")
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 4))
        str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(5, 28))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 4))
        str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(5, 28))
        str.setLineSpacing(8)
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "blog")?.resized(newSize: CGSize(width: 40, height: 40))
        cours.addRightImage(image: icon!, offset: 30)
        cours.backgroundColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0, green: 0.4793452024, blue: 0.9990863204, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.titleEdgeInsets.left = 0
        
        return cours
    }()
    
    let DemandeDeDocumentsScolarite: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToScolarite(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Scolarité\nProcédures et contacts")
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(10, 22))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 22))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        default:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(10, 22))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 22))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "scolarite")?.resized(newSize: CGSize(width: 40, height: 40))
        cours.addRightImage(image: icon!, offset: 30)
        cours.backgroundColor = #colorLiteral(red: 0.1521916687, green: 0.6835762858, blue: 0.376893878, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.1521916687, green: 0.6835762858, blue: 0.376893878, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.1521916687, green: 0.6835762858, blue: 0.376893878, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.titleEdgeInsets.left = 0
        
        return cours
    }()
    
    let InfoUtile: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToInfoUtile(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Informations utiles\nTrouver vos cours personnalisés")
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 19))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(20, 31))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 19))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(20, 31))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        default:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 19))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(20, 31))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 19))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(20, 31))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "info")?.resized(newSize: CGSize(width: 40, height: 40))
        cours.addRightImage(image: icon!, offset: 30)
        cours.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.9990773797, green: 0.2295021415, blue: 0.1888831556, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.titleEdgeInsets.left = 0
        
        return cours
    }()
    
    let transport: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Transport\nLes diffèrents circuits")
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(10, 23))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 23))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        default:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(10, 23))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 9))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(10, 23))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "bus")?.resized(newSize: CGSize(width: 40, height: 40))
        cours.addRightImage(image: icon!, offset: 30)
        cours.backgroundColor = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.3460007906, green: 0.3354875743, blue: 0.8400039077, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.3450980392, green: 0.337254902, blue: 0.8392156863, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.titleEdgeInsets.left = 0
        
        return cours
    }()
    
    let biblio: BtnPleinLarge = {
        let cours = BtnPleinLarge()
        cours.addTarget(self, action: #selector(buttonToBiblio(_:)), for: .touchUpInside)
        cours.translatesAutoresizingMaskIntoConstraints = false
        cours.titleLabel?.numberOfLines = 0
        let str = NSMutableAttributedString(string: "Bibliothèque\nRéservation de salles")
        
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 16)!, range: NSMakeRange(0, 12))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 12)!, range: NSMakeRange(13, 21))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 12))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(13, 21))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 20)
        default:
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir-Heavy", size: 20)!, range: NSMakeRange(0, 12))
            str.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Avenir", size: 14)!, range: NSMakeRange(13, 21))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(0, 12))
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSMakeRange(13, 21))
            str.setLineSpacing(8)
            cours.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        }
        
        cours.setAttributedTitle(str, for: .normal)
        let icon = UIImage(named: "biblio")?.resized(newSize: CGSize(width: 40, height: 40))
        cours.addRightImage(image: icon!, offset: 30)
        cours.backgroundColor = #colorLiteral(red: 0.7098039216, green: 0.2392156863, blue: 0, alpha: 1)
        cours.layer.borderColor = #colorLiteral(red: 0.7098039216, green: 0.2392156863, blue: 0, alpha: 1).cgColor
        cours.layer.shadowOpacity = 0.3
        cours.layer.shadowColor = #colorLiteral(red: 0.7098039216, green: 0.2392156863, blue: 0, alpha: 1)
        cours.layer.shadowOffset = CGSize(width: 1, height: 5)
        cours.layer.cornerRadius = 10
        cours.layer.shadowRadius = 8
        cours.layer.masksToBounds = true
        cours.clipsToBounds = false
        cours.contentHorizontalAlignment = .left
        cours.layoutIfNeeded()
        cours.titleEdgeInsets.left = 0
        
        return cours
    }()
    
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        
        return view
    }()
    
    let contentView = UIView()
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.Authenticate { (success) in
//            print(success)
//        }
        setupScrollView()
        contentView.addSubview(mesCours)
//        contentView.addSubview(Blog)
        contentView.addSubview(DemandeDeDocumentsScolarite)
        contentView.addSubview(InfoUtile)
        contentView.addSubview(transport)
        contentView.addSubview(biblio)
        setupLayout()
        setupLoadingControl()
        setupUI()
        scrollView.delegate = self
        Auth.auth().addStateDidChangeListener() { auth, user in
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        getCurrentUser()
        setupUI()
        if Auth.auth().currentUser!.isAnonymous {
            mesCours.isEnabled = false
            mesCours.backgroundColor = #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 0.4394306753)
            mesCours.layer.borderColor = UIColor.clear.cgColor
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability?.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.removeFromSuperview()
        
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    

    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Accueil"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    private func setupUI() {
        // Initial setup for image for Large NavBar state since the the screen always has Large NavBar once it gets opened
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                             constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                              constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
            ])
    }
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupLayout() {
        mesCours.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mesCours.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        mesCours.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        mesCours.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
//        Blog.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        Blog.topAnchor.constraint(equalTo: mesCours.bottomAnchor, constant: 20).isActive = true
//        Blog.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
//        Blog.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        DemandeDeDocumentsScolarite.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        DemandeDeDocumentsScolarite.topAnchor.constraint(equalTo: mesCours.bottomAnchor, constant: 20).isActive = true
        DemandeDeDocumentsScolarite.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        DemandeDeDocumentsScolarite.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        InfoUtile.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        InfoUtile.topAnchor.constraint(equalTo: DemandeDeDocumentsScolarite.bottomAnchor, constant: 20).isActive = true
        InfoUtile.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        InfoUtile.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        transport.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        transport.topAnchor.constraint(equalTo: InfoUtile.bottomAnchor, constant: 20).isActive = true
        transport.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        transport.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        biblio.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        biblio.topAnchor.constraint(equalTo: transport.bottomAnchor, constant: 20).isActive = true
        biblio.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        biblio.heightAnchor.constraint(equalToConstant: 110).isActive = true
        biblio.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80).isActive = true
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
    
    private func getCurrentUser() {
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var user = User()
                user.dateDeCreation = (dictionary["dateDeCreation"] as! String?)!
                user.email = (dictionary["email"] as! String?)!
                user.name = (dictionary["name"] as! String?)!
                user.profileImageUrl = (dictionary["profileImageUrl"] as! String?)!
                user.provider = (dictionary["provider"] as! String?)!
                user.filiere.fid = (dictionary["filiere"] as! String?)!
                user.semestre.sid = (dictionary["semestre"] as! String?)!
                user.faculte.facId = (dictionary["faculte"] as! String?)!
                user.ajoutFaculte = (dictionary["ajoutFiliere"] as! Bool?)!
                user.new = (dictionary["new"] as! Bool?)!
                print(user.new)
                self.user = user
                self.getFiliere()
                self.getSemestre()
                if !user.ajoutFaculte {
                    let controller = ChoisirFaculteViewController()
                    let navController = UINavigationController(rootViewController: controller)
                    self.present(navController, animated: true, completion: nil)
                }
                
                if user.new {
                    
                    var configuration = AWSConfigOptions()
                    configuration.appName = "Ex-Machina"
                    configuration.appDescription = "Club Scientifique de l'UIC"
                    configuration.tintColor = UIColor(named: "exmachina")!
                    
                    var item1 = AWSItem()
                    item1.image = UIImage(named: "item1")
                    item1.title = "COURSES"
                    item1.description = "Retrouvez tous les supports de cours"
                    
                    var item2 = AWSItem()
                    item2.image = UIImage(named: "sco")
                    item2.title = "Demandes à la scolarité"
                    item2.description = "Envoyer une demande d'attestation n'a jamais été aussi facile"
                    
//                    var item3 = AWSItem()
//                    item3.image = UIImage(named: "utile")
//                    item3.title = "Informations Utiles"
//                    item3.description = "Toutes les informations utiles sont à portée de main"
                    
                    var item4 = AWSItem()
                    item4.image = UIImage(named: "favoris")
                    item4.title = "Favoris"
                    item4.description = "Garder vos fichiers favoris à portée de main"
                    
                    var item5 = AWSItem()
                    item5.image = UIImage(named: "offline")
                    item5.title = "Offline"
                    item5.description = "Vous pouvez enregistrer des fichiers directement sur votre appareil"
                    
                    configuration.items = [item1, item2, item4, item5]
                    
                    configuration.continueButtonText = "Commencer"
                    
                    configuration.continueButtonAction = {
                        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
                        ref.updateChildValues(["new": false])
                        self.dismiss(animated: true)
                    }
                    
                    let vc = AWSViewController()
                    vc.configuration = configuration
                    self.present(vc, animated: true)
                    
                }
                
                
            }
        }, withCancel: nil)
    }
    
    private func getFiliere() {
        let ref = Database.database().reference().child("data").child("faculte").child(self.user.faculte.facId).child("liste").child(self.user.filiere.fid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var filiere = Filiere()
                filiere.titre = (dictionary["titre"] as! String?)!
                filiere.fid = (dictionary["fid"] as! String?)!
                
                if filiere.fid == "CPI-1" {
                    filiere.colorOne = #colorLiteral(red: 0.3843137255, green: 0.4470588235, blue: 0.4823529412, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1)
                } else if filiere.fid == "CPI-2" {
                    filiere.colorOne = #colorLiteral(red: 0.5058823529, green: 0.6117647059, blue: 0.662745098, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1)
                } else if filiere.fid == "GC-1" {
                    filiere.colorOne = #colorLiteral(red: 0.6117647059, green: 0.4705882353, blue: 0.4235294118, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.2509803922, green: 0.1411764706, blue: 0.1019607843, alpha: 1)
                } else if filiere.fid == "GC-2" {
                    filiere.colorOne = #colorLiteral(red: 0.7450980392, green: 0.6117647059, blue: 0.568627451, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3725490196, green: 0.262745098, blue: 0.2235294118, alpha: 1)
                } else if filiere.fid == "GIND-1" {
                    filiere.colorOne = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.262745098, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.8470588235, green: 0.262745098, blue: 0.08235294118, alpha: 1)
                } else if filiere.fid == "GIND-2" {
                    filiere.colorOne = #colorLiteral(red: 1, green: 0.5176470588, blue: 0.2980392157, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.9568627451, green: 0.3176470588, blue: 0.1176470588, alpha: 1)
                } else if filiere.fid == "GINF-1" {
                    filiere.colorOne = #colorLiteral(red: 0.3764705882, green: 0.6784313725, blue: 0.368627451, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.1803921569, green: 0.4901960784, blue: 0.1960784314, alpha: 1)
                } else if filiere.fid == "GINF-2" {
                    filiere.colorOne = #colorLiteral(red: 0.5215686275, green: 0.7333333333, blue: 0.3607843137, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3333333333, green: 0.5450980392, blue: 0.1843137255, alpha: 1)
                } else if filiere.fid == "MIAGE-1" {
                    filiere.colorOne = #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3176470588, green: 0.1764705882, blue: 0.6588235294, alpha: 1)
                } else if filiere.fid == "MIAGE-2" {
                    filiere.colorOne = #colorLiteral(red: 0.8196078431, green: 0.768627451, blue: 0.9137254902, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.4862745098, green: 0.3019607843, blue: 1, alpha: 1)
                } else {
                    filiere.colorOne = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
                }
                self.filiere = filiere
            }
        }, withCancel: nil)
    }
    
    private func getSemestre() {
        let ref = Database.database().reference().child("data").child("faculte").child(self.user.faculte.facId).child("liste").child(self.user.filiere.fid).child("liste").child(self.user.semestre.sid)
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var semestre = Semestre()
                semestre.titre = (dictionary["titre"] as! String?)!
                semestre.sid = (dictionary["sid"] as! String?)!
                
                self.semestre = semestre
                self.isReady = true
            }
        }, withCancel: nil)
    }
    
    @objc func buttonToMesCours(_ sender: BtnPleinLarge) {
        let controller = MesCoursViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToScolarite(_ sender: BtnPleinLarge) {
        let controller = ScolariteViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToBiblio(_ sender: BtnPleinLarge) {
        let controller = BibliothequeViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func buttonToInfoUtile(_ sender: BtnPleinLarge) {
        
        let controller = InfoUtileViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    @objc func singleTapping(_ recognizer: UIGestureRecognizer) {
        let controller = ProfileViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
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
