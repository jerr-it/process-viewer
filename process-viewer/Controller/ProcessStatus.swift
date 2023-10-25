//
//  ProcessStatus.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//
// Abstracts the ps utility

import Foundation
import SwiftUI

@MainActor class ProcessStatus : ObservableObject {
    @Published var ssh: SSH
    @Published var processes: [Process] = []
    
    init(ssh: SSH) {
        self.ssh = ssh
        self.processes = []
    }
    
    func getProcesses() {
        Task() {
            do {
                let stdout = try await self.ssh.runSync(cmd: "ps -eo pid,pcpu,pmem,user,cmd --no-headers")
                self.processes = ProcessStatus.parse(stdout: stdout)
            } catch {
                print(error)
                self.ssh.connected = false
            }
        }
    }
    
    func sendSignal(pid: Int, signal: String) {
        Task() {
            let _ = try await self.ssh.runSync(cmd: "kill -s \(signal) \(pid)")
            self.getProcesses()
        }
    }
    
    static func parse(stdout: String) -> [Process] {
        var processes: [Process] = []
        
        let parts = stdout.split(separator: "\n")
        for line in parts {
            let components = line.split(separator: " ")
            
            let pid = Int(components[0]) ?? -1
            let pcpu = Double(components[1]) ?? -1.0
            let pmem = Double(components[2]) ?? -1.0
            let usr = String(components[3])
            let cmd = String(components[4])
            
            processes.append(Process(pid: pid, user: usr, cmd: cmd, pcpu: pcpu, pmem: pmem))
        }
        
        return processes
    }
}
