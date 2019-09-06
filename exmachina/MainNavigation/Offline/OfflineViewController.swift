//
//  OfflineViewController.swift
//  exmachina
//
//  Created by M'haimdat omar on 30-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import FirebaseAuth
import FirebaseDatabase
import BouncyLayout
import LBTAComponents

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

class OfflineViewController: UIViewController, UISearchControllerDelegate {
    
    let cellId = "cellId"
    var files = [File]()
    var favoris = [File]()
    var filtered = [File]()
    var searchActive: Bool = false
    
    let newCollection: UICollectionView = {
        
        let layout = BouncyLayout(style: .regular)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.collectionViewLayout.invalidateLayout()
        
        return collection
    }()
    
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
    
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()
    
    let searchBar: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        return search
    }()
    
    let imageNoOffline: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "noOffline"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let labelNoOffline: UILabel = {
        let label = UILabel()
        label.text = "Téléchargez vos fichiers\n ....\n...\n..\n."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupSearchController()
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
        setupUI()
        
        if self.files.count == 0 {
            setupNoOffline()
            print("\(self.files.count)")
            print("IM not in")
        } else {
            print("IM in")
            imageNoOffline.removeFromSuperview()
            labelNoOffline.removeFromSuperview()
            setupCollection()
            setupCollectionView()
        }
        getAllOfflineFiles()
        self.newCollection.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.removeFromSuperview()
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Offline | \(self.files.count)"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = .lightText
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.navigationBar.barStyle = .default
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.searchController = searchBar
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func setupNoOffline() {
        self.view.addSubview(imageNoOffline)
        self.view.addSubview(labelNoOffline)
        
        imageNoOffline.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 40).isActive = true
        imageNoOffline.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        imageNoOffline.heightAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        imageNoOffline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        labelNoOffline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelNoOffline.topAnchor.constraint(equalTo: imageNoOffline.bottomAnchor, constant: 30).isActive = true
        
        if UIDevice().userInterfaceIdiom == .pad {
            
            imageNoOffline.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 100).isActive = true
            imageNoOffline.widthAnchor.constraint(equalToConstant: view.frame.width - 250).isActive = true
            imageNoOffline.heightAnchor.constraint(equalToConstant: view.frame.width - 250).isActive = true
            imageNoOffline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            labelNoOffline.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            labelNoOffline.topAnchor.constraint(equalTo: imageNoOffline.bottomAnchor, constant: 100).isActive = true
            
        }
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.newCollection.collectionViewLayout.invalidateLayout()
    }
    
    fileprivate func setupCollectionView() {
        newCollection.backgroundColor = .white
        newCollection.register(OfflineFileCollectionCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    func setupSearchController() {
        searchBar.delegate = self
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.delegate = self
        searchBar.searchBar.becomeFirstResponder()
        searchBar.dimsBackgroundDuringPresentation = false
        searchBar.searchBar.sizeToFit()
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.definesPresentationContext = true
    }
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
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
    
    func getAllOfflineFiles() {
        self.files.removeAll()
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(directoryContents)
            
            // if you want to filter the directory contents you can do like this:
            let pdfFile = directoryContents.filter{ $0.pathExtension == "pdf" }
            print("pdf urls:", pdfFile)
            let pdfFileNames = pdfFile.map{ $0.deletingPathExtension().lastPathComponent }
            print("pdf list:", pdfFileNames)
            
            let n = pdfFile.count
            
            for x in 0..<n {
                var f = File()
                f.url = pdfFile[x].absoluteString
                f.titre = pdfFileNames[x]
                self.files.append(f)
                self.newCollection.reloadData()
            }
            if self.files.count != 0 {
                self.setupCollection()
                self.setupCollectionView()
            }
            navigationItem.title = "Offline | \(self.files.count)"
            
        } catch {
            print(error)
        }
    }
    
    fileprivate func getFavoris() {
        
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("favoris")
        ref.observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var file = File()
                file.titre = (dictionary["titre"] as! String?)!
                file.matiere = (dictionary["matiere"] as! String?)!
                file.url = (dictionary["url"] as! String?)!
                
                self.favoris.append(file)
                
            }
        }, withCancel: nil)
    }

    
    @objc func singleTapping(_ recognizer: UIGestureRecognizer) {
        let controller = ProfileViewController()
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
    }

}
