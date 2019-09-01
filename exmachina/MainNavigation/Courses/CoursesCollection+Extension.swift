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
        return self.filieres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoursesFacultyViewCell
        
        cell.editButton.isHidden = true
        cell.listNameLabel.text = self.filieres[indexPath.item].fid
        cell.listDescriptionLabel.text = self.filieres[indexPath.item].titre
//        cell.contentView.setGradientBackgroundColor(colorOne: self.filieres[indexPath.item].colorOne, colorTow: self.filieres[indexPath.item].colorTwo)
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
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
