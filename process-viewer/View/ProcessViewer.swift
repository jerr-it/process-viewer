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
    @State var filterStr: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Status")) {
                SSHStatus(ssh: ps.ssh)
            }
            Section(header: Text("Search")) {
                TextField("User, command, PID ...", text: $filterStr)
                    .autocorrectionDisabled()
            }
            Section(header: HStack {
                Text("Processes")
                Spacer()
                Button("Refresh", systemImage: "arrow.clockwise", action: self.ps.getProcesses)
                    .labelStyle(.titleAndIcon)
            }) {
                List (
                    ps.processes.filter { process in
                        if (self.filterStr == "") {
                            return true
                        }
                        return process.user.contains(self.filterStr) || process.cmd.contains(self.filterStr) || String(process.pid).contains(self.filterStr)
                    }
                ) { process in
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
            Text("\(ssh.server.host)")
            Spacer()
            Image(systemName: self.ssh.connected ? "checkmark.circle" : "x.circle")
                .foregroundColor(self.ssh.connected ? .green : .red)
        }
    }
}
