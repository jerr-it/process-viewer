//
//  Server.swift
//  process-viewer
//
//  Created by jerr-it on 10/17/23.
//

import Foundation

class Server : Identifiable, Hashable {
    static func == (lhs: Server, rhs: Server) -> Bool {
        return lhs.host == rhs.host
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.host)
        hasher.combine(self.port)
    }
    
    var host: String
    var port: UInt16
    
    init(host: String = "", port: UInt16 = 22) {
        self.host = host
        self.port = port
    }
}
