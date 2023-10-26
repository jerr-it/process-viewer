//
//  BTDeviceRow.swift
//  process-viewer
//
//  Created by vmaster on 10/26/23.
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
    var device: BTDevice
    
    var body: some View {
        HStack {
            Image(systemName: ICON_MAP[device.icon] ?? "questionmark")
            Text("\(device.name)")
        }
    }
}
