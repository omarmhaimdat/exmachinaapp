//
//  ChoisirFaculteCollection+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 14-08-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

extension ChoisirFaculteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            self.getFilieres(facId: "ING")
        } else if self.facultes[indexPath.item].facId == "FSS" {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.4980392157, green: 0.6980392157, blue: 0.3843137255, alpha: 1)
            self.getFilieres(facId: "FSS")
        } else {
            cell.contentView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.3450980392, blue: 0.2862745098, alpha: 1)
            self.getFilieres(facId: "FCG")
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
        faculte = self.facultes[indexPath.row]
        let controller = ChoisirFilieresViewController()
        controller.filieres = self.filieres
        controller.faculte = faculte
        let ref = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
        ref.updateChildValues(["faculte": faculte.facId])
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
