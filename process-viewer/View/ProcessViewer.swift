//
//  ProcessViewer.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//

import Foundation
import SwiftUI


struct ProcessViewer : View {
    @StateObject var processStatus: ProcessStatus
    
    init(server: Server, user: User) {
        self._processStatus = StateObject(wrappedValue: ProcessStatus(server: server, user: user))
    }
    
    var body: some View {
        Form {
            Section(header: Text("Status")) {
                SSHStatus(ssh: processStatus.ssh)
            }
            Section(header: HStack {
                Text("Processes")
                Spacer()
                Button("Refresh", systemImage: "arrow.clockwise", action: self.processStatus.getProcesses)
                    .labelStyle(.titleAndIcon)
            }) {
                List (processStatus.processes) { process in
                    ProcessRow(process: process)
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
