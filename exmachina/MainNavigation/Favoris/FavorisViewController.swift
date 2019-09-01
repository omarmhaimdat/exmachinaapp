//
//  FavorisViewController.swift
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


class FavorisViewController: UIViewController, UISearchControllerDelegate {
    
    let cellId = "cellId"
    var matieres = [Matiere]()
    var files = [File]()
    var filtered = [File]()
    var filiere = Filiere()
    var semestre = Semestre()
    var matiere = Matiere()
    var pdfURL: URL!
    var searchActive: Bool = false
    
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
    
    let newCollection: UICollectionView = {
        
        let layout = BouncyLayout(style: .regular)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.collectionViewLayout = layout
        layout.scrollDirection = .vertical
        collection.backgroundColor = UIColor.clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = true
        collection.showsVerticalScrollIndicator = false
        collection.collectionViewLayout.invalidateLayout()
        
        return collection
    }()
    
    let searchBar: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        return search
    }()
    
    
    let activityIndicatorView: NVActivityIndicatorView = {
        let AIV = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), type: .circleStrokeSpin, color: .black, padding: 100)
        AIV.color = UIColor(named: "exmachina")!
        AIV.translatesAutoresizingMaskIntoConstraints = false
        
        return AIV
    }()
    
    let imageNoFavorites: UIImageView = {
       let image = UIImageView(image: #imageLiteral(resourceName: "noFavorites"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let labelNoFavorites: UILabel = {
        let label = UILabel()
        label.text = "Ajouter des favoris\n ....\n...\n..\n."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 1
        
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        setupTabBar()
        setupUI()
        self.getFavoris()
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
            setupNoFavorites()
        } else {
            imageNoFavorites.removeFromSuperview()
            labelNoFavorites.removeFromSuperview()
            setupCollection()
            setupCollectionView()
            setupLoadingControl()
            self.activityIndicatorView.startAnimating()
        }
        self.getFavoris()
        self.newCollection.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageView.removeFromSuperview()
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func setupTabBar() {
        view.backgroundColor = UIColor.white
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Favoris | \(self.files.count)"
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
    
    private func setupNoFavorites() {
        self.view.addSubview(imageNoFavorites)
        self.view.addSubview(labelNoFavorites)
        
        imageNoFavorites.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 40).isActive = true
        imageNoFavorites.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        imageNoFavorites.heightAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        imageNoFavorites.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        labelNoFavorites.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelNoFavorites.topAnchor.constraint(equalTo: imageNoFavorites.bottomAnchor, constant: 30).isActive = true
        
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
        newCollection.register(FavorisViewControllerCell.self, forCellWithReuseIdentifier: cellId)
        newCollection.alwaysBounceVertical = true
        newCollection.delegate = self
        newCollection.dataSource = self
    }
    
    func setupLoadingControl() {
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    func getFavoris() {
        
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("favoris")
        self.files.removeAll()
        ref.queryOrdered(byChild: "timestamp").observe(DataEventType.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var file = File()
                file.titre = (dictionary["titre"] as! String?)!
                file.matiere = (dictionary["matiere"] as! String?)!
                file.url = (dictionary["url"] as! String?)!
                file.fileId = (dictionary["fid"] as! String?)!
                
                self.files.append(file)
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                     self.activityIndicatorView.stopAnimating()
                    self.navigationItem.title = "Favoris | \(self.files.count)"
                    if self.files.count != 0 {
                        self.setupCollection()
                        self.setupCollectionView()
                        self.setupLoadingControl()
                    }
                })
                
            }
        }, withCancel: nil)
        
        ref.observe(DataEventType.childRemoved, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var file = File()
                file.titre = (dictionary["titre"] as! String?)!
                file.matiere = (dictionary["matiere"] as! String?)!
                file.url = (dictionary["url"] as! String?)!
                file.fileId = (dictionary["fid"] as! String?)!
                
                self.files.removeAll(where: {$0.fileId == file.fileId})
                DispatchQueue.main.async(execute: {
                    self.newCollection.reloadData()
                    self.activityIndicatorView.stopAnimating()
                    self.navigationItem.title = "Favoris | \(self.files.count)"
                    if self.files.count == 0 {
                        self.setupNoFavorites()
                    }
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

extension FavorisViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            self.pdfURL = destinationURL
            print("NewDownloadUrl:", destinationURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
