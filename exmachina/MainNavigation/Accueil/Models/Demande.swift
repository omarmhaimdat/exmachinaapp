//
//  Demande.swift
//  exmachina
//
//  Created by M'haimdat omar on 04-07-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import Foundation

enum typeDeDemande {
    case Scolarite
    case Reussite
    case Inscription
    case ReussiteDiplome
    case Responsable
}

struct Demande {
    
    var nomAuComplet: String
    var cin: String
    var dateDeNaissance: String
    var nombreExemplaire: String
    var type: typeDeDemande?
    
    init() {
        self.nomAuComplet = ""
        self.cin = ""
        self.dateDeNaissance = ""
        self.nombreExemplaire = ""
    }
}
