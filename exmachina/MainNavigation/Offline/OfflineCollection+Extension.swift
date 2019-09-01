//
//  OfflineCollection+Extension.swift
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

extension OfflineViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OfflineFileCollectionCell
        
        if searchActive {
            cell.listNameLabel.text = self.filtered[indexPath.item].titre
            cell.editButton.addTarget(self, action: #selector(buttonToMore(sender: )), for: .touchUpInside)
            cell.editButton.tag = indexPath.row
        } else {
            cell.listNameLabel.text = self.files[indexPath.item].titre
            cell.editButton.addTarget(self, action: #selector(buttonToMore(sender: )), for: .touchUpInside)
            cell.editButton.tag = indexPath.row
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 40, height: 80)
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
        
        let offlineAction = UIAlertAction(title: "Supprimer de la liste", style: .destructive) { (_) in
            do {
                let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
                var filePath = ""
                if dirs.count > 0 {
                    let dir = dirs[0] //documents directory
                    filePath = dir.appendingFormat("/" + self.files[sender.tag].titre + ".pdf")
                    print("Local path = \(filePath)")
                    
                } else {
                    print("Could not find local directory to store file")
                    return
                }
                let fileManager = FileManager.default
                print(fileManager)
                
                // Check if file exists
                if fileManager.fileExists(atPath: filePath) {
                    // Delete file
                    try fileManager.removeItem(atPath: filePath)
                    self.newCollection.reloadData()
                    self.getAllOfflineFiles()
                    if self.files.count == 0 {
                        self.newCollection.removeFromSuperview()
                        self.setupNoOffline()
                    }
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
                    let description = EKProperty.LabelContent(text: "Le fichier a été supprimer du téléphone", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black, alignment: .center))
                    let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!)), backgroundColor: .black, highlightedBackgroundColor: UIColor(named: "exmachina")!)
                    let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
                        SwiftEntryKit.dismiss()
                    }
                    
                    let contentView = EKPopUpMessageView(with: message)
                    SwiftEntryKit.display(entry: contentView, using: attributes)
                } else {
                    print("File does not exist")
                }
                
            }
            catch let error as NSError {
                print("An error took place: \(error)")
            }
            
        }
        
        alert.addAction(annulerAction)
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
