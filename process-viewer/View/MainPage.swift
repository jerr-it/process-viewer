//
//  ServerConfigurator.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//

import Foundation
import SwiftUI


struct MainPage : View {
    @StateObject var serverStore = ServerStore()
    @StateObject var userStore = UserStore()
    
    @State var server: Server = Server()
    @State var user: User = User()
    @StateObject var ssh: SSH = SSH()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Configuration")) {
                    Picker("Server", selection: $server) {
                        ForEach(serverStore.serverList) { serv in
                            Text("\(serv.host):\(serv.port)")
                                .tag(serv)
                        }
                    }
                    Picker("User", selection: $user) {
                        ForEach(userStore.userList) { usr in
                            Text(usr.name)
                                .tag(usr)
                        }
                    }
                    Button(self.ssh.connected ? "Connected" : "Connect", systemImage: self.ssh.connected ? "checkmark.icloud.fill" : "icloud.fill", action: {() -> Void in
                        self.ssh.connect(server: server, user: user)
                    })
                        .disabled(self.ssh.connected)
                        .foregroundColor(self.ssh.connected ? .green : .white)
                }
                Section(header: Text("Utils")) {
                    NavigationLink("Processes") {
                        ProcessViewer(ps: ProcessStatus(ssh: ssh)).disabled(!self.ssh.connected)
                    }.disabled(!self.ssh.connected)
                    NavigationLink("Bluetooth") {
                        BluetoothViewer(btCtl: BluetoothCtl(ssh: ssh)).disabled(!self.ssh.connected)
                    }.disabled(!self.ssh.connected)
                }
                .toolbar {
                    NavigationLink(destination: ServerUserCreator(serverStore: self.serverStore, userStore: self.userStore)) {
                        Image(systemName: "plus")
                    }
                }
            }.navigationTitle("Server")
        }
    }
}
