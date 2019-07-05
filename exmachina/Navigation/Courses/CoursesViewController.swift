//
//  CoursesViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NVActivityIndicatorView
import BouncyLayout
import LBTAComponents
import FirebaseAuth

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

class CoursesViewController: UIViewController {
    
//    private let imageView = UIImageView(image: UIImage(named: "test"))
    
    let cellId = "cellId"
    var matieres = [Matiere]()
    var filieres = [Filiere]()
    
    lazy var imageView: CachedImageView = {
        let profileImageViewHeight: CGFloat = 56
        var iv = CachedImageView()
        iv.backgroundColor = UIColor.darkGray
        iv.contentMode = .scaleAspectFill
        iv.layer.borderWidth = 0
        iv.layer.borderColor = UIColor.black.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = profileImageViewHeight / 2
        var photoProfile: String = Auth.auth().currentUser?.photoURL?.absoluteString ?? "Profile"
        let photoProvider = Auth.auth().currentUser?.providerData
        print(photoProfile)
        for userInfo in photoProvider! {
            switch userInfo.providerID {
            case "facebook.com":
                photoProfile = photoProfile + "?height=500"
                print(photoProfile)
            case "google.com":
                photoProfile = photoProfile.replacingOccurrences(of: "/s96-c/photo.jpg", with: "/s400-c/photo.jpg")
                print(photoProfile)
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
    
    let newCollection: UICollectionView = {
        
        let layout = BouncyLayout(style: .regular)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.showsVerticalScrollIndicator = false
        
        return collection
    }()
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupCollection()
        setupCollectionView()
//        getFilieres()
        setupLoadingControl()
        activityIndicatorView.startAnimating()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
        getFilieres()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.removeFromSuperview()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Courses"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.shadowImage = UIImage()
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
        return .default
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func setupLoadingControl() {
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    fileprivate func setupCollection() {
        
        self.view.addSubview(newCollection)
        
        newCollection.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        newCollection.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        newCollection.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        newCollection.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        newCollection.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        newCollection.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
    }
    
    fileprivate func setupCollectionView() {
        newCollection.backgroundColor = .white
        newCollection.register(CoursesFacultyViewCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    func getFilieres() {
        
        let ref = Database.database().reference()
        self.filieres.removeAll()
        ref.child("facultes").child("liste").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var filiere = Filiere()
                filiere.titre = (dictionary["titre"] as! String?)!
                filiere.fid = (dictionary["fid"] as! String?)!
                
                if filiere.fid == "CPI-1" {
                    filiere.colorOne = #colorLiteral(red: 0.3843137255, green: 0.4470588235, blue: 0.4823529412, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.2156862745, green: 0.2784313725, blue: 0.3098039216, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "CPI-2" {
                    filiere.colorOne = #colorLiteral(red: 0.5058823529, green: 0.6117647059, blue: 0.662745098, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3294117647, green: 0.431372549, blue: 0.4784313725, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GC-1" {
                    filiere.colorOne = #colorLiteral(red: 0.6117647059, green: 0.4705882353, blue: 0.4235294118, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.2509803922, green: 0.1411764706, blue: 0.1019607843, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GC-2" {
                    filiere.colorOne = #colorLiteral(red: 0.7450980392, green: 0.6117647059, blue: 0.568627451, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3725490196, green: 0.262745098, blue: 0.2235294118, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GIND-1" {
                    filiere.colorOne = #colorLiteral(red: 1, green: 0.4588235294, blue: 0.262745098, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.8470588235, green: 0.262745098, blue: 0.08235294118, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GIND-2" {
                    filiere.colorOne = #colorLiteral(red: 1, green: 0.5176470588, blue: 0.2980392157, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.9568627451, green: 0.3176470588, blue: 0.1176470588, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GINF-1" {
                    filiere.colorOne = #colorLiteral(red: 0.3764705882, green: 0.6784313725, blue: 0.368627451, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.1803921569, green: 0.4901960784, blue: 0.1960784314, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "GINF-2" {
                    filiere.colorOne = #colorLiteral(red: 0.5215686275, green: 0.7333333333, blue: 0.3607843137, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3333333333, green: 0.5450980392, blue: 0.1843137255, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "MIAGE-1" {
                    filiere.colorOne = #colorLiteral(red: 0.4039215686, green: 0.2274509804, blue: 0.7176470588, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.3176470588, green: 0.1764705882, blue: 0.6588235294, alpha: 1)
                    self.filieres.append(filiere)
                } else if filiere.fid == "MIAGE-2" {
                    filiere.colorOne = #colorLiteral(red: 0.8196078431, green: 0.768627451, blue: 0.9137254902, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.4862745098, green: 0.3019607843, blue: 1, alpha: 1)
                    self.filieres.append(filiere)
                } else {
                    filiere.colorOne = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
                    filiere.colorTwo = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
                    self.filieres.append(filiere)
                }
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                    self.activityIndicatorView.stopAnimating()
                })
            }
        }, withCancel: nil)
    }
    
    @objc func singleTapping(_ recognizer: UIGestureRecognizer) {
        let controller = ProfileViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }
    
}
