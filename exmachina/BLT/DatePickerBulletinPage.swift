//
//  DatePickerBulletinPage.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import BLTNBoard

/**
 * A bulletin item that demonstrates how to integrate a date picker inside a bulletin item.
 */

class DatePickerBLTNItem: BLTNPageItem {
    
    lazy var datePicker = UIDatePicker()
    
    /**
     * Display the date picker under the description label.
     */
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        datePicker.datePickerMode = .date
        return [datePicker]
    }
    
}
