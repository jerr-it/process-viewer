//
//  BTDeviceRow.swift
//  process-viewer
//
//  Created by vmaster on 10/26/23.
//

import SwiftUI

struct BTDeviceRow: View {
    var device: BTDevice
    
    var body: some View {
        HStack {
            Image(systemName: "antenna.radiowaves.left.and.right")
            Text("\(device.name)")
        }
    }
}
