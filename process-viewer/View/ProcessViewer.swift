//
//  ProcessViewer.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//

import Foundation
import SwiftUI


struct ProcessViewer : View {
    @StateObject var ps: ProcessStatus
    
    init(server: Server, user: User) {
        self._ps = StateObject(wrappedValue: ProcessStatus(server: server, user: user))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Status")) {
                SSHStatus(ssh: ps.ssh)
            }
            Section(header: HStack {
                Text("Processes")
                Spacer()
                Button("Refresh", systemImage: "arrow.clockwise", action: self.ps.getProcesses)
                    .labelStyle(.titleAndIcon)
            }) {
                List (ps.processes) { process in
                    ProcessRow(ps: ps, process: process)
                }
            }
        }.navigationTitle("Process Viewer")
    }
}

struct SSHStatus : View {
    @StateObject var ssh: SSH
    
    var body: some View {
        HStack {
            Image(systemName: "server.rack")
            Text("Status")
            Spacer()
            Image(systemName: ssh.connected ? "checkmark" : "x.circle")
        }
    }
}
