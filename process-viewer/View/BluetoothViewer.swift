//
//  BluetoothViewer.swift
//  process-viewer
//
//  Created by jerr-it on 10/25/23.
//

import Foundation
import SwiftUI

struct BluetoothViewer: View {
    @StateObject var btCtl: BluetoothCtl
    
    var body: some View {
        Form {
            Section(header: HStack {
                Text("Status")
                Spacer()
                if (self.btCtl.scanTaskHandle != nil) {
                    ProgressView()
                }
            }) {
                SSHStatus(ssh: btCtl.ssh)
                HStack {
                    Image(systemName: "b.circle")
                    Text("Bluetooth")
                    Spacer()
                    Image(systemName: self.btCtl.isAvailable ? "checkmark.circle" : "x.circle")
                        .foregroundColor(self.btCtl.isAvailable ? .green : .red)
                }
            }
        }
            .navigationTitle("Bluetooth")
            .onAppear {
                self.btCtl.checkBTAvailable()
                self.btCtl.scanOn()
            }
            .onDisappear {
                self.btCtl.scanOff()
            }
    }
}

