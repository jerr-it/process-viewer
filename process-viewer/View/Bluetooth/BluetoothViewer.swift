//
//  BluetoothViewer.swift
//  process-viewer
//
//  Created by jerr-it on 10/25/23.
//

import Foundation
import SwiftUI
import Combine

let SCAN_ON_INTERVAL: Int = 10
let GET_DEVICES_INTERVAL: Int = 3

struct BluetoothViewer: View {
    @StateObject var btCtl: BluetoothCtl
    @State private var getDevicesTimer = Timer.publish(every: Double(GET_DEVICES_INTERVAL), on: .main, in: .common).autoconnect()
    @State private var scanOnTimer = Timer.publish(every: Double(SCAN_ON_INTERVAL), on: .main, in: .common).autoconnect()
    
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
                Text("Connected")
                Spacer()
                if (self.btCtl.scanTaskHandle != nil) {
                    ProgressView()
                }
            }) {
                List(self.btCtl.btDevices) { device in
                    if device.connected {
                        BTDeviceRow(device: device, btCtl: self.btCtl)
                    }
                }
            }
            Section(header: Text("Paired")) {
                List(self.btCtl.btDevices) { device in
                    if !device.connected && device.paired {
                        BTDeviceRow(device: device, btCtl: self.btCtl)
                    }
                }
            }
            Section(header: Text("Other")) {
                List(self.btCtl.btDevices) { device in
                    if !device.connected && !device.paired && !device.blocked {
                        BTDeviceRow(device: device, btCtl: self.btCtl)
                    }
                }
            }
            Section(header: Text("Blocked")) {
                List(self.btCtl.btDevices) { device in
                    if device.blocked {
                        BTDeviceRow(device: device, btCtl: self.btCtl)
                    }
                }
            }
        }
            .navigationTitle("Bluetooth")
            .onAppear {
                self.btCtl.checkBTAvailable {
                    self.btCtl.scanOn(timeout: SCAN_ON_INTERVAL)
                }
            }
            .onDisappear {
                self.btCtl.scanOff()
                self.scanOnTimer.upstream.connect().cancel()
                self.getDevicesTimer.upstream.connect().cancel()
            }
            .onReceive(scanOnTimer) { time in
                if self.btCtl.isAvailable {
                    self.btCtl.scanOn(timeout: SCAN_ON_INTERVAL)
                }
            }
            .onReceive(getDevicesTimer) { time in
                if self.btCtl.isAvailable {
                    self.btCtl.getBTDevices()
                }
            }
    }
}

