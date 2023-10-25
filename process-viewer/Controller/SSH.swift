//
//  SSHConnection.swift
//  process-viewer
//
//  Created by jerr-it
//  Abstracts an SSH connection using the swift-ssh-client package

import Foundation
import SwiftUI
import Citadel

enum SSHError : Error {
    case NotConnected
}

@MainActor class SSH : ObservableObject {
    @Published var connected: Bool
    let server: Server
    let user: User
    var client: SSHClient?
    
    init(host: String, port: UInt16, username: String, password: String) {
        self.server = Server(host: host, port: port)
        self.user = User(name: username, password: password)
        self.connected = false
        self.client = nil
        
        Task() {
            do {
                self.client = try await SSHClient.connect(
                    host: "\(self.server.host)",
                    authenticationMethod: .passwordBased(username: self.user.name, password: self.user.password),
                    hostKeyValidator: .acceptAnything(),
                    reconnect: .never
                )
                
                self.connected = true
            } catch {
                self.connected = false
            }
        } 
    }

    func runSync(cmd: String) async throws -> String {
        if !client!.isConnected {
            self.connected = false
            throw SSHError.NotConnected
        }
        
        let stdout = try await client!.executeCommand(cmd)
        return String(buffer: stdout)
    }
    
    func runAsync(cmd: String, onStdout: @escaping (String) -> Void, onStderr: @escaping (String) -> Void) async throws -> Task<Void, Error> {
        if !client!.isConnected {
            self.connected = false
            throw SSHError.NotConnected
        }
        
        return Task {
            do {
                let streams = try await self.client!.executeCommandStream(cmd)
                var asyncStreams = streams.makeAsyncIterator()
                
                while let blob = try await asyncStreams.next() {
                    switch blob {
                    case .stdout(let stdout):
                        onStdout(String(buffer: stdout))
                    case .stderr(let stderr):
                        onStderr(String(buffer: stderr))
                    }
                }
            } catch {
                print("Could not start async ssh command: \(error)")
            }
        }
    }
}
