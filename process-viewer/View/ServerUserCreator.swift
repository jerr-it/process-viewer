//
//  ServerUserCreator.swift
//  process-viewer
//
//  Created by jerr-it on 10/21/23.
//

import SwiftUI

enum Page : String, CaseIterable, Identifiable {
    case User, Server
    var id: Self { self }
}

struct ServerUserCreator: View {
    @StateObject var serverStore: ServerStore
    @StateObject var userStore: UserStore
    
    @State var page: Page
    
    @State var username: String
    @State var password: String
    
    @State var hostname: String
    @State var port: String
    
    init(serverStore: ServerStore, userStore: UserStore) {
        self._serverStore = StateObject(wrappedValue: serverStore)
        self._userStore = StateObject(wrappedValue: userStore)
        
        self.page = Page.User
        
        self.username = ""
        self.password = ""
        self.hostname = ""
        self.port = ""
    }

    var body: some View {
        Form {
            Picker("Page", selection: $page) {
                ForEach(Page.allCases) { page in
                    Text(page.rawValue.capitalized)
                        .tag(page)
                }
            }.pickerStyle(.segmented)
            Section(header: Text("Add")) {
                if page == Page.User {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                    Button("Done", systemImage: "checkmark", action: {() -> Void in
                        self.userStore.addUser(user: User(name: self.username, password: self.password))
                    })
                } else {
                    TextField("Hostname", text: $hostname)
                    TextField("Port", text: $port).keyboardType(.numberPad)
                    Button("Done", systemImage: "checkmark", action: {() -> Void in
                        self.serverStore.addServer(server: Server(host: self.hostname, port: UInt16(self.port) ?? 22))
                    })
                }
            }
            Section(header: Text("List")) {
                if page == Page.User {
                    List(self.userStore.userList) { user in
                        Text(user.name).swipeActions {
                            Button("", systemImage: "xmark", action: {() -> Void in
                                self.userStore.removeUser(user: user)
                            }).tint(.red)
                        }
                    }
                } else {
                    List(self.serverStore.serverList) { server in
                        Text("\(server.host):\(server.port)").swipeActions {
                            Button("", systemImage: "xmark", action: {() -> Void in
                                self.serverStore.removeServer(server: server)
                            }).tint(.red)
                        }
                    }
                }
            }
        }.navigationTitle("Servers / Users")
    }
}
