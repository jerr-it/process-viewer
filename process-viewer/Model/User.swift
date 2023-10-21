//
//  User.swift
//  process-viewer
//
//  Created by jerr-it on 10/17/23.
//

import Foundation

class User : Identifiable, Hashable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name + lhs.password == rhs.name + rhs.password
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.password)
    }
    
    var name: String
    var password: String
    
    init(name: String = "", password: String = "") {
        self.name = name
        self.password = password
    }
}
