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
    
    func checkBTAvailable(then: Optional<() -> Void>) {
        Task.detached { @MainActor in
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl show")
                
                self.isAvailable = !stdout.contains("No default controller available")
                
                if self.isAvailable {
                    switch then {
                    case .some(let fn):
                        fn()
                    case .none:
                        break
                    }
                }
            } catch {
                print("Could not run command: \(error)")
                self.isAvailable = false
            }
        }
    }
    
    func scanOn(timeout: Int) {
        if !self.isAvailable {
            return
        }
        
        do {
            self.scanTaskHandle = try self.ssh.runAsync(cmd: "bluetoothctl --timeout \(timeout) scan on") { stdout in
            } onStderr: { stderr in
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
                let _ = try await self.ssh.runSync(cmd: "pkill -f 'bluetoothctl'")
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
                    let macAddress = String(components[1])
                    if macAddress.replacingOccurrences(of: ":", with: "-") == components[2] {
                        continue
                    }
                    
                    let devStdout = try await self.ssh.runSync(cmd: "bluetoothctl info \(components[1])")

                    devices.append(BTDevice(output: devStdout, mac: macAddress))
                }
            } catch {
                print("Could not fetch devices: \(stdout)")
            }
            
            if Set(self.btDevices) != Set(devices) {
                self.btDevices = devices
            }
        }
    }
    
    func connectDevice(device: BTDevice) {
        Task.detached { @MainActor in
            do {
                device.connecting = true
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl connect \(device.mac)")
                if stdout.contains("Connection successful") {
                    device.connected = true
                }
                device.connecting = false
            } catch {
                print("Unable to connect to device \(device.name) \(device.mac): \(error)")
            }
        }
    }
    
    func disconnectDevice(device: BTDevice) {
        Task.detached { @MainActor in
            do {
                device.connecting = true
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl disconnect \(device.mac)")
                if stdout.contains("Connection successful") {
                    device.connected = true
                }
                device.connecting = false
            } catch {
                print("Unable to connect to device \(device.name) \(device.mac): \(error)")
            }
        }
    }
    
    func trustDevice(device: BTDevice) {
        Task.detached { @MainActor in
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl trust \(device.mac)")
                if stdout.contains("trust succeeded") {
                    device.trusted = true
                }
            } catch {
                print("Unable to trust device \(device.name) \(device.mac): \(error)")
            }
        }
    }
    
    func untrustDevice(device: BTDevice) {
        Task.detached { @MainActor in
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl untrust \(device.mac)")
                if stdout.contains("untrust succeeded") {
                    device.trusted = false
                }
            } catch {
                print("Unable to untrust device \(device.name) \(device.mac): \(error)")
            }
        }
    }
    
    func blockDevice(device: BTDevice) {
        Task.detached { @MainActor in
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl block \(device.mac)")
                if stdout.contains("block succeeded") {
                    device.blocked = true
                }
            } catch {
                print("Unable to block device \(device.name) \(device.mac): \(error)")
            }
        }
    }
    
    func unblockDevice(device: BTDevice) {
        Task.detached { @MainActor in
            do {
                let stdout = try await self.ssh.runSync(cmd: "bluetoothctl unblock \(device.mac)")
                if stdout.contains("unblock succeeded") {
                    device.blocked = false
                }
            } catch {
                print("Unable to unblock device \(device.name) \(device.mac): \(error)")
            }
        }
    }
}
