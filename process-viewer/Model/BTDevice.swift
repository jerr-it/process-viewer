//
//  BTDevice.swift
//  process-viewer
//
//  Created by vmaster on 10/25/23.
//

import Foundation

let REGEX_TEMPLATE: String = "(?<=@: ).+"

class BTDevice : ObservableObject, Identifiable, Hashable {
    static func == (lhs: BTDevice, rhs: BTDevice) -> Bool {
        return lhs.mac == rhs.mac
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(mac)
    }
    
    @Published var connecting: Bool
    
    let id: UUID
    
    let mac: String
    
    let name: String
    let alias: String
    
    let dClass: String
    let icon: String
    
    @Published var paired: Bool
    @Published var bonded: Bool
    @Published var trusted: Bool
    @Published var blocked: Bool
    @Published var connected: Bool
    
    init(output: String, mac: String) {
        self.id = UUID()
        self.mac = mac
        self.connecting = false
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
