//
//  CoursesCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 31-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension CoursesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.facultes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoursesFacultyViewCell
        
        cell.editButton.isHidden = true
        cell.listNameLabel.text = self.facultes[indexPath.item].facId
        cell.listDescriptionLabel.text = self.facultes[indexPath.item].titre
        
        if self.facultes[indexPath.item].facId == "ING" {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.3731170297, green: 0.283844918, blue: 0.6121758819, alpha: 1)
        } else if self.facultes[indexPath.item].facId == "FSS" {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.6980392157, blue: 0.3843137255, alpha: 1)
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.3450980392, blue: 0.2862745098, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 40, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let faculte: Faculte
        faculte = facultes[indexPath.row]
        let controller = FiliereViewController()
        controller.faculte = faculte
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
