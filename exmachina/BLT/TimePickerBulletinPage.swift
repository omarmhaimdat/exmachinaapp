//
//  TimePickerBulletinPage.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import BLTNBoard

/**
 * A bulletin item that demonstrates how to integrate a date picker inside a bulletin item.
 */

class TimePickerBLTNItem: BLTNPageItem {
    
    lazy var datePicker = UIDatePicker()
    
    /**
     * Display the date picker under the description label.
     */
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        datePicker.datePickerMode = .dateAndTime
        datePicker.minuteInterval = 30
        if #available(iOS 13.0, *) {
            datePicker.tintColor = .systemYellow
//            datePicker.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.3)
        } else {
            // Fallback on earlier versions
            datePicker.tintColor = #colorLiteral(red: 0.8352941176, green: 0.7568627451, blue: 0, alpha: 1)
        }
        return [datePicker]
    }
    
}
