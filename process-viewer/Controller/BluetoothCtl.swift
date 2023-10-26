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
    @Published var scanTaskHandle: Task<Void, Error>?
    
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
                
                if self.isAvailable {
                    self.scanOn()
                }
            } catch {
                print("Could not run command: \(error)")
                self.isAvailable = false
            }
        }
    }
    
    func scanOn() {
        if !self.isAvailable {
            return
        }
        
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
        if !self.isAvailable {
            return
        }
        
        Task.detached { @MainActor in
            do {
                let _ = try await self.ssh.runSync(cmd: "pkill -f 'bluetoothctl scan on'")
            } catch {
                print("Error when trying to disable scanning: \(error)")
            }
            self.scanTaskHandle?.cancel()
            self.scanTaskHandle = nil
        }
    }
    
    func getBTDevices() {
        Task.detached { @MainActor in
            var devices: [BTDevice] = []
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl devices")
                let lines = stdout.split(separator: "\n")
                for line in lines {
                    if line.isEmpty {
                        continue
                    }
                    
                    let components = line.split(separator: " ")
                    if String(components[1]).replacingOccurrences(of: ":", with: "-") == components[2] {
                        continue
                    }
                    
                    let devStdout = try await self.ssh.runSync(cmd: "bluetoothctl info \(components[1])")

                    devices.append(BTDevice(output: devStdout))
                }
            } catch {
                print("Could not fetch devices: \(stdout)")
            }
            self.btDevices = devices
        }
    }
}
