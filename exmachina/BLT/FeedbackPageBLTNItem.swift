//
//  FeedbackPageBLTNItem.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit
import BLTNBoard

class FeedbackPageBLTNItem: BLTNPageItem {
    
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func actionButtonTapped(sender: UIButton) {
        
        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
        
        // Call super
        super.actionButtonTapped(sender: sender)
        
    }
    
    override func alternativeButtonTapped(sender: UIButton) {
        
        // Play an haptic feedback
        feedbackGenerator.prepare()
        feedbackGenerator.selectionChanged()
        
        // Call super
        super.alternativeButtonTapped(sender: sender)
        
    }
    
}
