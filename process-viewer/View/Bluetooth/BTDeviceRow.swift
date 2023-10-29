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
            Button ("") {
                modalOpen.toggle()
            }
            if self.device.connecting {
                ProgressView()
            } else {
                if device.connected {
                    Image(systemName: "minus")
                        .foregroundColor(.red)
                        .onTapGesture {
                            self.btCtl.disconnectDevice(device: device)
                        }
                } else {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                        .onTapGesture {
                            self.btCtl.connectDevice(device: device)
                        }
                }
            }
        }.sheet(isPresented: $modalOpen) {
            BTDeviceDetails(device: self.device)
        }
    }
}

struct BTDeviceDetails: View {
    @StateObject var device: BTDevice
    
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
                Toggle("Bonded", isOn: $device.bonded)
                Toggle("Trusted", isOn: $device.trusted)
                Toggle("Blocked", isOn: $device.blocked)
                Toggle("Connected", isOn: $device.connected)
            }
        }
    }
}
