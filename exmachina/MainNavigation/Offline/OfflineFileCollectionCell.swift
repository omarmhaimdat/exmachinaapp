//
//  OfflineFileCollectionCell.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

class OfflineFileCollectionCell: UICollectionViewCell {
    
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
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.label
        } else {
            // Fallback on earlier versions
            label.textColor = UIColor.black
        }
        label.font = UIFont(name: "Avenir-Heavy", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 1
        
        return label
    }()
    
    let listDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "........................."
        if #available(iOS 13.0, *) {
            label.textColor = UIColor.systemGray2
        } else {
            // Fallback on earlier versions
            label.textColor = UIColor.gray
        }
        label.font = UIFont(name: "Avenir", size: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton(type: .custom) as UIButton
        let icon = UIImage(named: "more_black")?.resized(newSize: CGSize(width: 20, height: 20))
        button.setImage(icon, for: UIControl.State.normal)
        return button
    }()
    
    let icon: UIImageView = {
       let image = #imageLiteral(resourceName: "pdf_icon").resized(newSize: CGSize(width: 35, height: 35))
        let icon = UIImageView(image: image)
        
        return icon
    }()
    
    var speedLabel: UILabel!
    var progressView: UIProgressView!
    var isDownloading = false
    
    // MARK: Setup Cell
    fileprivate func setupCell() {
        roundCorner()
        setCellShadow()
        self.addSubview(listNameLabel)
        self.addSubview(editButton)
        self.addSubview(icon)
        
        icon.anchor(top: safeTopAnchor, left: safeLeftAnchor, bottom: nil, right: safeLeftAnchor, paddingTop: 22, paddingLeft: 20, paddingBottom: 0, paddingRight: -55)
        
        listNameLabel.anchor(top: safeTopAnchor, left: icon.rightAnchor, bottom: nil, right: safeRightAnchor, paddingTop: 30, paddingLeft: 15, paddingBottom: 0, paddingRight: 40)
        
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
        self.contentView.layer.borderColor = UIColor(red: 240/255, green: 16/255, blue: 28/255, alpha:1.0).cgColor
        if #available(iOS 13.0, *) {
            self.contentView.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            self.contentView.backgroundColor = .white
        }
    }
    
}
