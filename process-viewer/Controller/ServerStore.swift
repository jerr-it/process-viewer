//
//  ServerStore.swift
//  process-viewer
//
//  Created by jerr-it on 10/21/23.
//

import Foundation

let SERVER_STORE_FILE: String = "server_store.txt"

class ServerStore : ObservableObject {
    @Published var serverList: [Server]
    
    init() {
        self.serverList = []
        
        self.loadServers()
    }
    
    func addServer(server: Server) {
        self.serverList.append(server)
        self.saveServers()
    }
    
    func removeServer(server: Server) {
        self.serverList = self.serverList.filter {
            $0 != server
        }
        self.saveServers()
    }
    
    func loadServers() {
        var servers: [Server] = []
        
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDir.appendingPathComponent(SERVER_STORE_FILE)
            do {
                let fileStr = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = fileStr.split(separator: "\n")
                for line in lines {
                    let components = line.split(separator: ",")
                    servers.append(Server(host: String(components[0]), port: UInt16(components[1]) ?? 22))
                }
            } catch {
                print("Cannot access file of stored servers.")
            }
        }
        
        self.serverList = servers
    }
    
    func saveServers() {
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDir.appendingPathComponent(SERVER_STORE_FILE)
            do {
                for server in self.serverList {
                    try "\(server.host),\(server.port)\n".write(to: fileURL, atomically: true, encoding: .utf8)
                }
            } catch {
                print("Cannot access file to store servers.")
            }
        }
    }
}
