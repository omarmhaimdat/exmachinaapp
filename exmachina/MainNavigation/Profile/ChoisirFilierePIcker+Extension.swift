//
//  ChoisirFilierePIcker+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 06-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension ChoisirFiliereViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.facultePicker {
            return self.facultes.count
        } else if pickerView == self.filierePicker {
            return self.filieres.count
        } else {
            return self.semestres.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.facultePicker {
            return facultes[row].titre
        } else if pickerView == self.filierePicker {
            return filieres[row].titre
        } else {
            return semestres[row].titre
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.facultePicker {
            faculteSelected = facultes[row]
            faculteTextField.text = faculteSelected.facId
            saveFaculte()
            filiereTextField.text = "Sélectionner la filière"
            semestreTextField.text = "Sélectionner le semestre"
            filiereTextField.textColor = .red
            semestreTextField.textColor = .red
            getFilieres(facId: faculteSelected.facId.isEmpty ? self.user.faculte.facId : faculteSelected.facId)
            self.semestres.removeAll()
        } else if pickerView == self.filierePicker {
            filiereSelected = filieres[row]
            filiereTextField.text = filiereSelected.fid
            saveFiliere()
            print(filiereSelected.fid.isEmpty)
            semestreTextField.text = "Sélectionner le semestre"
            semestreTextField.textColor = .red
            filiereTextField.textColor = UIColor.green
            getSemestres(fid: filiereSelected.fid.isEmpty ? self.user.filiere.fid : filiereSelected.fid, facId: faculteSelected.facId.isEmpty ? self.user.faculte.facId : faculteSelected.facId)
        } else {
            semestreSelected = semestres[row]
            semestreTextField.text = semestreSelected.sid
            semestreTextField.textColor = UIColor.green
            saveSemestre()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = UIColor(named: "exmachina")
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 28)
        
        if pickerView == self.facultePicker {
            label.text = facultes[row].titre
        } else if pickerView == self.filierePicker {
            label.text = filieres[row].fid
        } else {
            label.text = semestres[row].sid
        }
        
        return label
    }
    
}
