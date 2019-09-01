//
//  FavorisCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import PDFKit
import FirebaseDatabase
import FirebaseAuth
import SwiftEntryKit

extension FavorisViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return self.filtered.count
        } else {
            return self.files.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavorisViewControllerCell
        
        if searchActive {
            cell.listNameLabel.text = self.filtered[indexPath.item].matiere
            cell.listDescriptionLabel.text = self.filtered[indexPath.item].titre
            cell.editButton.addTarget(self, action: #selector(buttonToMore(sender: )), for: .touchUpInside)
            cell.editButton.tag = indexPath.row
        } else {
            cell.listNameLabel.text = self.files[indexPath.item].matiere
            cell.listDescriptionLabel.text = self.files[indexPath.item].titre
            cell.editButton.addTarget(self, action: #selector(buttonToMore(sender: )), for: .touchUpInside)
            cell.editButton.tag = indexPath.row
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: round((view.frame.width - 40) / 2.0)*2, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.activityIndicatorView.startAnimating()
        
        guard let url = URL(string: self.files[indexPath.item].url) else { return }
        
        let pdfView = PDFView(frame: view.frame)
        pdfView.backgroundColor = .lightGray
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        
        
        self.run(after: 0.5) {
            DispatchQueue.main.async {
                let pdfDocument = PDFDocument(url: url)
                pdfView.document = pdfDocument
                let detailVC = PdfViewerViewController()
                detailVC.pdfView = pdfView
                self.navigationController?.pushViewController(detailVC, animated: true)
                self.activityIndicatorView.stopAnimating()
                
            }
        }
        
    }
    
    @objc func buttonToMore(sender: UIButton) {
        
        let alert = UIAlertController(title: "\(self.files[sender.tag].titre)", message: nil, preferredStyle: .actionSheet)
        
        let annulerAction = UIAlertAction(title: "Annuler", style: .cancel) { action -> Void in
            
        }
        
        let favorisAction = UIAlertAction(title: "Supprimer des favoris", style: .destructive) { (_) in
            print(sender.tag)
            let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).child("favoris")
            ref.child(self.files[sender.tag].fileId).removeValue()
            
            let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            var themeImage: EKPopUpMessage.ThemeImage?
            var attributes = EKAttributes()
            attributes.hapticFeedbackType = .success
            attributes.entryBackground = .color(color: UIColor(named: "exmachina")!)
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
            attributes.statusBar = .dark
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
            attributes.position = .bottom
            attributes.displayDuration = 3
            attributes.roundCorners = .all(radius: 15)
            
            if let image = UIImage(named: "ok_black") {
                themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
            }
            
            let title = EKProperty.LabelContent(text: "Confirmation", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: .black, alignment: .center))
            let description = EKProperty.LabelContent(text: "Le fichier a été supprimer de la liste des favoris", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black, alignment: .center))
            let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!)), backgroundColor: .black, highlightedBackgroundColor: UIColor(named: "exmachina")!)
            let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
                SwiftEntryKit.dismiss()
            }
            
            let contentView = EKPopUpMessageView(with: message)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
        
        let offlineAction = UIAlertAction(title: "Offline", style: .default) { (_) in
            guard let url = URL(string: self.files[sender.tag].url) else { return }
            
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            let downloadTask = urlSession.downloadTask(with: url)
            downloadTask.resume()
            
            let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
            var themeImage: EKPopUpMessage.ThemeImage?
            var attributes = EKAttributes()
            attributes.hapticFeedbackType = .success
            attributes.entryBackground = .color(color: UIColor(named: "exmachina")!)
            attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
            attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
            attributes.statusBar = .dark
            attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
            attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
            attributes.position = .bottom
            attributes.displayDuration = 3
            attributes.roundCorners = .all(radius: 15)
            
            if let image = UIImage(named: "ok_black") {
                themeImage = .init(image: .init(image: image, size: CGSize(width: 50, height: 50), contentMode: .scaleAspectFit))
            }
            
            let title = EKProperty.LabelContent(text: "Confirmation", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: .black, alignment: .center))
            let description = EKProperty.LabelContent(text: "Le fichier a été ajouter dans la liste des fichiers Offline", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black, alignment: .center))
            let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!)), backgroundColor: .black, highlightedBackgroundColor: UIColor(named: "exmachina")!)
            let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
                SwiftEntryKit.dismiss()
            }
            
            let contentView = EKPopUpMessageView(with: message)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
        
        alert.addAction(annulerAction)
        alert.addAction(favorisAction)
        alert.addAction(offlineAction)
        
        //Begin: Uniquement pour les iPads (UIAlertController n'existe pas sur iPad)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height / 2.5, width: 1, height: 1)
        }
        //End: Uniquement pour les iPads
        present(alert, animated: true, completion: nil)
        
    }
    
}
