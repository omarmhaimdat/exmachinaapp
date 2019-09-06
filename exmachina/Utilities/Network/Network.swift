//
//  Network.swift
//  exmachina
//
//  Created by M'haimdat omar on 06-09-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import Foundation
import Reachability
import SwiftEntryKit

class Network: NSObject {
    
    private let reachability = Reachability()!
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            self.promptNotification()
        }
    }
    
    private func promptNotification() {
        let minEdge = min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        var themeImage: EKPopUpMessage.ThemeImage?
        var attributes = EKAttributes()
        attributes.hapticFeedbackType = .error
        attributes.entryBackground = .color(color: .black)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        attributes.positionConstraints.maxSize = .init(width: .constant(value: minEdge - 30), height: .intrinsic)
        attributes.position = .bottom
        attributes.displayDuration = .infinity
        attributes.roundCorners = .all(radius: 15)
        
        if let image = UIImage(named: "no_connection") {
            themeImage = .init(image: .init(image: image, size: CGSize(width: 100, height: 100), contentMode: .scaleAspectFit))
        }
        
        let title = EKProperty.LabelContent(text: "Pas de connection", style: .init(font: UIFont(name: "Avenir", size: 24)!, color: UIColor(named: "exmachina")!, alignment: .center))
        let description = EKProperty.LabelContent(text: "Le signal internet est trop faible", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: UIColor(named: "exmachina")!, alignment: .center))
        let button = EKProperty.ButtonContent(label: .init(text: "Ok", style: .init(font: UIFont(name: "Avenir", size: 16)!, color: .black)), backgroundColor: UIColor(named: "exmachina")!, highlightedBackgroundColor: .black)
        let message = EKPopUpMessage(themeImage: themeImage, title: title, description: description, button: button) {
            SwiftEntryKit.dismiss()
        }
        
        let contentView = EKPopUpMessageView(with: message)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    static func internetConnection(reachability: Reachability, observer: UIViewController) {
        NotificationCenter.default.addObserver(observer, selector: #selector(Network.reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
}
