//
//  User.swift
//  KUHAR
//
//  Created by Екатерина Горинова on 15.03.25.
//

import Foundation

struct NewUser: Identifiable {
    var id: String
    var name: String
    
    var representation: [String:Any]{
        
        var repres = [String:Any]()
        repres["id"] = self.id
        repres["name"] = self.name
        
        return repres
    }
}
