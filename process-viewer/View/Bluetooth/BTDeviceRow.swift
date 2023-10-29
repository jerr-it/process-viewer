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
    
    var body: some View {
        HStack {
            Image(systemName: ICON_MAP[device.icon] ?? "questionmark")
            Text("\(device.name)")
            Spacer()
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
        }
    }
}
