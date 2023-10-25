//
//  BTDevice.swift
//  process-viewer
//
//  Created by vmaster on 10/25/23.
//

import Foundation

let REGEX_TEMPLATE: String = "/@: (.+)/"

struct BTDevice : Identifiable, Hashable {
    let id: UUID
    
    var name: String
    var alias: String
    
    var dClass: String
    var icon: String
    
    var paired: Bool
    var bonded: Bool
    var trusted: Bool
    var blocked: Bool
    var connected: Bool
    
    init(output: String) {
        self.id = UUID()
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Name"), options: .regularExpression) {
            self.name = String(output[range])
        } else { self.name = "" }
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Alias"), options: .regularExpression) {
            self.alias = String(output[range])
        }else { self.alias = "" }
        
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Class"), options: .regularExpression) {
            self.dClass = String(output[range])
        }else { self.dClass = "" }
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Icon"), options: .regularExpression) {
            self.icon = String(output[range])
        }else { self.icon = "" }
        
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Paired"), options: .regularExpression) {
            self.paired = String(output[range]) == "yes"
        }else { self.paired = false }
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Bonded"), options: .regularExpression) {
            self.bonded = String(output[range]) == "yes"
        }else { self.bonded = false }
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Trusted"), options: .regularExpression) {
            self.trusted = String(output[range]) == "yes"
        }else { self.trusted = false }
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Blocked"), options: .regularExpression) {
            self.blocked = String(output[range]) == "yes"
        }else { self.blocked = false }
        if let range = output.range(of: REGEX_TEMPLATE.replacingOccurrences(of: "@", with: "Connected"), options: .regularExpression) {
            self.connected = String(output[range]) == "yes"
        }else { self.connected = false }
    }
}
