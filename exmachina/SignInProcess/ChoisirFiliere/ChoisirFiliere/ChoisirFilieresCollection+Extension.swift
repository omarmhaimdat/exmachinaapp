//
//  ChoisirFiliereCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 14-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

extension ChoisirFilieresViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        
        let faculte: Faculte
        let filiere: Filiere
        faculte = self.faculte
        filiere = self.filieres[indexPath.row]
        let controller = ChoisirSemestreViewController()
        controller.faculte = faculte
        controller.filiere = filiere
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.updateChildValues(["filiere": filiere.fid])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
