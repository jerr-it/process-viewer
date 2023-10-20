//
//  ProcessRow.swift
//  process-viewer
//
//  Created by jerr-it on 10/15/23.
//

import SwiftUI

struct ProcessRow: View {
    var process: Process
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(process.cmd)
                    .font(.headline)
                Text(process.user)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            Text(String(format: "%.1f", process.pcpu))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .opacity(process.pcpu / 100.0)
            
            Text(String(format: "%.1f", process.pmem))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .opacity(process.pmem / 100.0)
            
            Text("\(process.pid)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

var processes: [Process] = [
    Process(pid: 1, user: "vmaster", cmd: "/bin/ls", pcpu: 1.4, pmem: 94.1),
    Process(pid: 2, user: "vmaster", cmd: "/bin/cat", pcpu: 55.4, pmem: 45.5),
    Process(pid: 3, user: "root", cmd: "/bin/usbmuxd", pcpu: 89.2, pmem: 10.1)
]

#Preview {
    Group {
        List(processes) { process in
            ProcessRow(process: process)
        }
    }
}
