//
//  FavorisViewControllerCell.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class FavorisViewControllerCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            
            UIView.animate(withDuration: 0.27, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 1.0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
                self.contentView.alpha = self.isHighlighted ? 0.35 : 1
                self.transform = self.isHighlighted ? self.transform.scaledBy(x: 0.96, y: 0.96) : .identity
            })
        }
    }
    
    // MARK: UI
    let listNameLabel: UILabel = {
        let label = UILabel()
        label.text = "....."
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    let listDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "........................."
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    let icon: UIImageView = {
        let image = #imageLiteral(resourceName: "favoris").resized(newSize: CGSize(width: 25, height: 25))
        let icon = UIImageView(image: image)
        
        return icon
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .custom) as UIButton
        let icon = UIImage(named: "more_black")?.resized(newSize: CGSize(width: 20, height: 20))
        button.setImage(icon, for: UIControl.State.normal)
        return button
    }()
    
    // MARK: Setup Cell
    fileprivate func setupCell() {
        roundCorner()
        setCellShadow()
        self.addSubview(listNameLabel)
        self.addSubview(listDescriptionLabel)
        self.addSubview(editButton)
        self.addSubview(icon)
        icon.anchor(top: safeTopAnchor, left: safeLeftAnchor, bottom: nil, right: safeLeftAnchor, paddingTop: 27, paddingLeft: 15, paddingBottom: 0, paddingRight: -40)
        
        listNameLabel.anchor(top: safeTopAnchor, left: icon.rightAnchor, bottom: nil, right: safeRightAnchor, paddingTop: 15, paddingLeft: 15, paddingBottom: 0, paddingRight: 40)
        
        listDescriptionLabel.anchor(top: listNameLabel.bottomAnchor, left: icon.rightAnchor, bottom: nil, right: safeRightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 40)
        
        editButton.anchor(top: safeTopAnchor, left: nil, bottom: nil, right: safeRightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 36, height: 36)
    }
    
    // MARK: Methods
    func setCellShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 6.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 14
        self.clipsToBounds = false
    }
    func roundCorner() {
        self.contentView.layer.cornerRadius = 14
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderWidth = 3.0
        self.contentView.layer.borderColor = UIColor(red:1.00, green:0.73, blue:0.00, alpha:1.0).cgColor
        self.contentView.backgroundColor = .white
    }
    
}
