//
//  ProcessRow.swift
//  process-viewer
//
//  Created by jerr-it on 10/15/23.
//

import SwiftUI

struct ProcessRow: View {
    var ps: ProcessStatus
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
        }.swipeActions(allowsFullSwipe: false) {
            Button {
                self.ps.sendSignal(pid: process.pid, signal: "SIGKILL")
            } label: {
                Label("Kill", systemImage: "bolt.fill")
            }.tint(.red)
            
            Button {
                self.ps.sendSignal(pid: process.pid, signal: "SIGTERM")
            } label: {
                Label("Term", systemImage: "xmark")
            }.tint(.orange)
        }
    }
}
