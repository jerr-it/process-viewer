//
//  SSHConnection.swift
//  process-viewer
//
//  Created by jerr-it
//  Abstracts an SSH connection using the swift-ssh-client package

import Foundation
import SwiftUI
import SSHClient

@MainActor class SSH : ObservableObject {
    @Published var connected: Bool
    private var connection: SSHConnection
    
    init(host: String, port: UInt16, username: String, password: String) {
        self.connection = SSHConnection(
            host: host,
            port: port,
            authentication: SSHAuthentication(
                username: username,
                method: .password(.init(password)),
                hostKeyValidation: .acceptAll()
            )
        )
        self.connected = false
    }
    
    func connect() {
        Task() {
            do {
                try await self.connection.start()
                self.connected = true
            } catch {
                self.connected = false
            }
        }
    }
    
    func execute(cmd: String) async throws -> (Int, String, String) {
        let response = try await self.connection.execute(SSHCommand(cmd))
        return (
            response.status.exitStatus,
            String(decoding: response.standardOutput ?? Data(), as: UTF8.self),
            String(decoding: response.errorOutput ?? Data(), as: UTF8.self)
        )
    }
}
