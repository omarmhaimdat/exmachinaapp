//
//  Filiere.swift
//  exmachina
//
//  Created by M'haimdat omar on 31-05-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

struct Filiere {
    var titre: String
    var fid: String
    var colorOne: UIColor
    var colorTwo: UIColor
    
    init() {
        self.titre = ""
        self.fid = ""
        self.colorOne = UIColor(named: "exmachina")!
        self.colorTwo = UIColor(named: "exmachina")!
    }
}
