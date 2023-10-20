//
//  ServerConfigurator.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//

import Foundation
import SwiftUI

struct ServerConfigurator : View {
    @State private var hostname: String = ""
    
    @State private var port_str: String = ""
    @State private var port: UInt16 = 22
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Server")) {
                    TextField("Hostname", text: $hostname)
                    TextField("Port", text: $port_str)
                        .onSubmit {
                            port = UInt16(port_str) ?? 22
                        }
                        .keyboardType(.numberPad)
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
                Section(header: Text("Processes")) {
                    NavigationLink("View") {
                        ProcessViewer(server: Server(host: hostname, port: port), user: User(name: username, password: password))
                    }
                }
            }.navigationTitle("Server")
        }
    }
}
