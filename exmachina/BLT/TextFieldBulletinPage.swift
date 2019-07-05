//
//  TextFieldBulletinPage.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import BLTNBoard
import FirebaseAuth

class TextFieldBulletinPage: FeedbackPageBLTNItem {
    
    @objc public var textField: UITextField!
    
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "CIN", returnKey: .done, delegate: self)
        return [textField]
    }
    
    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
    
}

// MARK: - UITextFieldDelegate
extension TextFieldBulletinPage: UITextFieldDelegate {
    
    @objc open func isInputValid(text: String?) -> Bool {
        
        if text == nil || text!.isEmpty {
            return false
        }
        
        return true
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if isInputValid(text: textField.text) {
            textInputHandler?(self, textField.text)
        } else {
            descriptionLabel!.textColor = .red
            descriptionLabel!.text = "Vous devez entrer une valeur."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        }
        
    }
    
}

