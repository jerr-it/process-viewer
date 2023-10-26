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
    let timer = Timer.publish(every: 2, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Form {
            Section(header: Text("Status")) {
                SSHStatus(ssh: btCtl.ssh)
                HStack {
                    Image(systemName: "b.circle")
                    Text("Bluetooth")
                    Spacer()
                    Image(systemName: self.btCtl.isAvailable ? "checkmark.circle" : "x.circle")
                        .foregroundColor(self.btCtl.isAvailable ? .green : .red)
                }
            }
            Section(header: HStack {
                Text("Devices")
                Spacer()
                if (self.btCtl.scanTaskHandle != nil) {
                    ProgressView()
                }
            }) {
                List(self.btCtl.btDevices) { device in
                    BTDeviceRow(device: device)
                }
            }
        }
            .navigationTitle("Bluetooth")
            .onAppear {
                self.btCtl.checkBTAvailable()
                self.btCtl.scanOn()
            }
            .onDisappear {
                timer.upstream.connect().cancel()
                self.btCtl.scanOff()
            }
            .onReceive(timer) { time in
                self.btCtl.getBTDevices()
            }
    }
}

