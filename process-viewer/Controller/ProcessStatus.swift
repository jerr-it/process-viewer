//
//  ProcessStatus.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//
// Abstracts the ps utility

import Foundation

@MainActor class ProcessStatus : ObservableObject {
    @Published var ssh: SSH
    @Published var processes: [Process]
    
    init(server: Server, user: User) {
        self.processes = []
        self.ssh = SSH(host: server.host, port: server.port, username: user.name, password: user.password)
        self.ssh.connect()
    }
    
    func getProcesses() {
        Task() {
            do {
                let (statusCode, stdout, stderr) = try await self.ssh.execute(cmd: "ps -eo pid,pcpu,pmem,user,cmd --no-headers")
                if (statusCode != 0) {
                    print(stderr)
                }
                
                self.processes = ProcessStatus.parse(stdout: stdout)
            } catch {
                print(error)
                self.ssh.connected = false
            }
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
