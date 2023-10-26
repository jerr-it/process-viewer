//
//  BluetoothCtl.swift
//  process-viewer
//
//  Created by jerr-it on 10/25/23.
//

import Foundation
import SwiftUI

class BluetoothCtl : ObservableObject {
    @Published var ssh: SSH
    @Published var isAvailable: Bool
    @Published var btDevices: [BTDevice]
    var scanTaskHandle: Task<Void, Error>?
    
    init(ssh: SSH) {
        self.ssh = ssh
        self.isAvailable = false
        self.btDevices = []
    }
    
    func checkBTAvailable() {
        Task.detached { @MainActor in
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl show")
                
                self.isAvailable = !stdout.contains("No default controller available")
            } catch {
                print("Could not run command: \(error)")
                self.isAvailable = false
            }
        }
    }
    
    func scanOn() {
        do {
            self.scanTaskHandle = try self.ssh.runAsync(cmd: "bluetoothctl scan on") { stdout in
                print("Stdout: \(stdout)")
            } onStderr: { stderr in
                print("Stderr: \(stderr)")
            }
        } catch {
            print("Error when starting async ssh: \(error)")
        }
    }
    
    func scanOff() {
        Task.detached { @MainActor in
            do {
                let _ = try await self.ssh.runSync(cmd: "pkill -f 'bluetoothctl scan on'")
            } catch {
                print("Error when trying to disable scanning: \(error)")
            }
            self.scanTaskHandle?.cancel()
        }
    }
}
