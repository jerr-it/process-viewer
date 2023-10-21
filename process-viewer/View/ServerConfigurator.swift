//
//  ServerConfigurator.swift
//  process-viewer
//
//  Created by jerr-it on 10/19/23.
//

import Foundation
import SwiftUI


struct ServerConfigurator : View {
    @StateObject var serverStore = ServerStore()
    @StateObject var userStore = UserStore()
    
    @State var server: Server = Server()
    @State var user: User = User()
    
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
                }
                Section(header: Text("Utils")) {
                    NavigationLink("Processes") {
                        ProcessViewer(server: self.server, user: self.user)
                    }
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
