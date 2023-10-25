//
//  BluetoothViewer.swift
//  process-viewer
//
//  Created by jerr-it on 10/25/23.
//

import SwiftUI

struct BluetoothViewer: View {
    @StateObject var btCtl: BluetoothCtl
    
    init(server: Server, user: User) {
        self._btCtl = StateObject(wrappedValue: BluetoothCtl(server: server, user: user))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Status")) {
                SSHStatus(ssh: btCtl.ssh)
            }
        }.navigationTitle("Bluetooth")
    }
}

