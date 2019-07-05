//
//  NumberPickerBulletinPage.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import BLTNBoard

/**
 * A bulletin item that demonstrates how to integrate a picker inside a bulletin item.
 */

class NumberPickerBLTNItem: BLTNPageItem {
    
    lazy var numberPicker = UIPickerView()
    lazy var tabNumber = ["01", "02", "03", "04", "05"]
    lazy var selected = "01"
    
    /**
     * Display the picker under the description label.
     */
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        numberPicker.tintColor = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
        numberPicker.dataSource = self
        numberPicker.delegate = self
        return [numberPicker]
    }
    
}

extension NumberPickerBLTNItem: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tabNumber.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tabNumber[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected = tabNumber[row]
    }
}
