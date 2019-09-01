//
//  User.swift
//  exmachina
//
//  Created by M'haimdat omar on 06-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import Foundation

struct User {
    var uid: String
    var name: String
    var dateDeCreation: String
    var email: String
    var profileImageUrl: String
    var provider: String
    var filiere: Filiere
    var semestre: Semestre
    var faculte: Faculte
    var new: Bool
    var ajoutFaculte: Bool
    
    init() {
        self.uid = ""
        self.name = ""
        self.dateDeCreation = ""
        self.email = ""
        self.profileImageUrl = ""
        self.provider = ""
        self.filiere = Filiere()
        self.semestre = Semestre()
        self.faculte = Faculte()
        self.new = false
        self.ajoutFaculte = false
    }
    
}
