//
//  BluetoothCtl.swift
//  process-viewer
//
//  Created by jerr-it on 10/25/23.
//

import Foundation

@MainActor class BluetoothCtl : ObservableObject {
    @Published var ssh: SSH
    
    init(server: Server, user: User) {
        self.ssh = SSH(host: server.host, port: server.port, username: user.name, password: user.password)
    }
}
