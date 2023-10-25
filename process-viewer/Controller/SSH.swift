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
    @Published var server: Server
    @Published var user: User
    var client: SSHClient?
    
    init() {
        self.server = Server()
        self.user = User()
        self.connected = false
    }
    
    func connect(server: Server, user: User) {
        Task() {
            do {
                self.client = try await SSHClient.connect(
                    host: "\(server.host)",
                    authenticationMethod: .passwordBased(username: user.name, password: user.password),
                    hostKeyValidator: .acceptAnything(),
                    reconnect: .never
                )
                
                self.connected = true
                self.server = server
                self.user = user
            } catch {
                self.connected = false
                print("Could not connect: \(error)")
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
    
    func runAsync(cmd: String, onStdout: @escaping (String) throws -> Void, onStderr: @escaping (String) throws -> Void) throws -> Task<Void, Error> {
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
                        try onStdout(String(buffer: stdout))
                    case .stderr(let stderr):
                        try onStderr(String(buffer: stderr))
                    }
                }
            } catch {
                print("Could not start async ssh command: \(error)")
            }
        }
    }
}
