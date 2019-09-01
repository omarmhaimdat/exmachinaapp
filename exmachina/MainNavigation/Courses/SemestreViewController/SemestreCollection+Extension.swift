//
//  SemestreCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 31-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension SemestreViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.semestres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoursesFacultyViewCell
        
        cell.listNameLabel.text = self.semestres[indexPath.item].sid
        cell.listDescriptionLabel.text = self.semestres[indexPath.item].titre
        cell.editButton.isHidden = true
        
        cell.contentView.setGradientBackgroundColor(colorOne: self.filiere.colorOne, colorTow: self.filiere.colorTwo)
        
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
        filiere = self.filiere
        let semestre: Semestre
        semestre = self.semestres[indexPath.item]
        let controller = ListeMatieresViewController()
        controller.filiere = filiere
        controller.semestre = semestre
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
