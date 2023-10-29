//
//  BTDeviceRow.swift
//  process-viewer
//
//  Created by jerr-it on 10/26/23.
//

import SwiftUI

let ICON_MAP: Dictionary<String, String> = [
    "audio-card": "waveform",
    "audio-headphones": "headphones",
    "audio-headset": "headphones",
    "camera-photo": "camera",
    "camera-video": "video",
    "computer": "desktopcomputer",
    "input-gaming": "gamecontroller",
    "input-keyboard": "keyboard",
    "input-mouse": "computermouse",
    "input-tabled": "ipad.landscape",
    "modem": "wifi.router",
    "multimedia-player": "play.square.stack.fill",
    "network-wireless": "antenna.radiowaves.left.and.right",
    "phone": "iphone",
    "printer": "printer",
    "scanner": "scanner",
    "video-display": "play.display",
    "unknown": "camera.metering.unknown"
]

struct BTDeviceRow: View {
    @StateObject var device: BTDevice
    @StateObject var btCtl: BluetoothCtl
    @State var modalOpen: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: ICON_MAP[device.icon] ?? "questionmark")
            Text("\(device.name)")
            Spacer()
            if self.device.connecting {
                ProgressView()
            } else {
                if device.connected {
                    Button("Disconnect") {
                        self.btCtl.disconnectDevice(device: device)
                    }
                        .foregroundColor(.red)
                        .buttonStyle(BorderlessButtonStyle())
                } else {
                    Button("Connect") {
                        self.btCtl.connectDevice(device: device)
                    }
                        .foregroundColor(.green)
                        .buttonStyle(BorderlessButtonStyle())
                }
            }
        }.onTapGesture {
            modalOpen.toggle()
        }.sheet(isPresented: $modalOpen) {
            BTDeviceDetails(device: self.device, btCtl: self.btCtl)
        }
    }
}

struct BTDeviceDetails: View {
    @StateObject var device: BTDevice
    @StateObject var btCtl: BluetoothCtl
    
    var body: some View {
        Text("\(device.name)")
            .font(.title)
            .padding(30)
        Form {
            Section(header: Text("Identifier")) {
                HStack {
                    Text("Alias")
                    Spacer()
                    Text("\(device.alias)")
                }
                HStack {
                    Text("MAC-Address")
                    Spacer()
                    Text("\(device.mac)")
                }
            }
            Section(header: Text("Technical Information")) {
                HStack {
                    Text("Class")
                    Spacer()
                    Text("\(device.dClass)")
                }
                HStack {
                    Text("Symbol")
                    Spacer()
                    Text("\(device.icon)")
                }
            }
            Section(header: Text("Status")) {
                Toggle("Paired", isOn: $device.paired)
                    .onChange(of: device.paired, perform: { state in
                        if state {
                            self.btCtl.pairDevice(device: self.device)
                        }else {
                            self.btCtl.unpairDevice(device: self.device)
                        }
                    })
                Toggle("Trusted", isOn: $device.trusted)
                    .onChange(of: device.trusted, perform: { state in
                        if state {
                            self.btCtl.trustDevice(device: self.device)
                        }else {
                            self.btCtl.untrustDevice(device: self.device)
                        }
                    })                
                Toggle("Blocked", isOn: $device.blocked)
                    .onChange(of: device.blocked, perform: { state in
                        if state {
                            self.btCtl.blockDevice(device: self.device)
                        }else {
                            self.btCtl.unblockDevice(device: self.device)
                        }
                    })
                Toggle("Connected", isOn: $device.connected)
                    .onChange(of: device.connected, perform: { state in
                        if state {
                            self.btCtl.connectDevice(device: self.device)
                        }else {
                            self.btCtl.disconnectDevice(device: self.device)
                        }
                    })
            }
        }
    }
}
