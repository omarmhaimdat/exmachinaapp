//
//  FilieresCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-10-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension FiliereViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filieres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoursesFacultyViewCell
        
        cell.editButton.isHidden = true
        cell.listNameLabel.text = self.filieres[indexPath.item].fid
        cell.listDescriptionLabel.text = self.filieres[indexPath.item].titre
        cell.contentView.backgroundColor = self.filieres[indexPath.item].colorTwo
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 40, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filiere: Filiere
        filiere = filieres[indexPath.row]
        let controller = SemestreViewController()
        controller.filiere = filiere
        controller.faculte = self.faculte
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape,
            let layout = self.newCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = self.view.frame.width - 40
            layout.itemSize = CGSize(width: width - 16, height: 180)
            layout.invalidateLayout()
            print("Landscrape")
        } else if UIDevice.current.orientation.isPortrait,
            let layout = self.newCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = self.view.frame.width - 40
            layout.itemSize = CGSize(width: width - 16, height: 180)
            layout.invalidateLayout()
            print("Portrait")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newCollection.collectionViewLayout.invalidateLayout()
        newCollection.layoutIfNeeded()
    }

    
}
