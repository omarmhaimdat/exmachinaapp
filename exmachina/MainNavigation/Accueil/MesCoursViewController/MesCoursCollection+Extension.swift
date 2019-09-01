//
//  MesCoursCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 09-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension MesCoursViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.matieres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CoursesFacultyViewCell
        
        cell.listNameLabel.text = self.matieres[indexPath.item].titre
        cell.listDescriptionLabel.text = self.semestre.titre
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
        filiere = self.user.filiere
        let semestre: Semestre
        semestre = self.user.semestre
        let matiere: Matiere
        matiere = self.matieres[indexPath.item]
        let controller = ListeFilesViewController()
        controller.filiere = filiere
        controller.semestre = semestre
        controller.matiere = matiere
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
