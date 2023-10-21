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
    
    @State var displayWarning: Bool
    
    init(serverStore: ServerStore, userStore: UserStore) {
        self._serverStore = StateObject(wrappedValue: serverStore)
        self._userStore = StateObject(wrappedValue: userStore)
        
        self.page = Page.User
        
        self.username = ""
        self.password = ""
        self.hostname = ""
        self.port = ""
        
        self.displayWarning = false
    }
    
    func validateForm() -> Bool {
        if self.page == Page.User {
            return !self.username.isEmpty && !self.password.isEmpty
        } else {
            return !self.hostname.isEmpty && !self.port.isEmpty
        }
    }

    var body: some View {
        Form {
            Picker("Page", selection: $page) {
                ForEach(Page.allCases) { page in
                    Text(page.rawValue.capitalized)
                        .tag(page)
                }
            }.pickerStyle(.segmented)
            Section(header: 
                HStack {
                    Text("Add")
                    Spacer()
                    if(self.displayWarning) {
                        Text("Missing values").foregroundStyle(.red)
                    }
                }
            ) {
                if page == Page.User {
                    TextField("Username", text: $username).autocorrectionDisabled()
                    SecureField("Password", text: $password).autocorrectionDisabled()
                    Button("Done", systemImage: "checkmark", action: {() -> Void in
                        self.displayWarning = !validateForm()
                        if !self.displayWarning {
                            self.userStore.addUser(
                                user: User(
                                    name: self.username.trimmingCharacters(in: .whitespacesAndNewlines),
                                    password: self.password.trimmingCharacters(in: .whitespacesAndNewlines)
                                )
                            )
                            self.username = ""
                            self.password = ""
                        }
                    })
                } else {
                    TextField("Hostname", text: $hostname).autocorrectionDisabled()
                    TextField("Port", text: $port).keyboardType(.numberPad).autocorrectionDisabled()
                    Button("Done", systemImage: "checkmark", action: {() -> Void in
                        self.displayWarning = !validateForm()
                        if !self.displayWarning {
                            self.serverStore.addServer(
                                server: Server(
                                    host: self.hostname.trimmingCharacters(in: .whitespacesAndNewlines),
                                    port: UInt16(self.port) ?? 22
                                )
                            )
                            self.hostname = ""
                            self.port = ""
                        }
                    })
                }
            }
            Section(header: Text("List")) {
                if page == Page.User {
                    List(self.userStore.userList) { user in
                        Text(verbatim: user.name).swipeActions {
                            Button("", systemImage: "xmark", action: {() -> Void in
                                self.userStore.removeUser(user: user)
                            }).tint(.red)
                        }
                    }
                } else {
                    List(self.serverStore.serverList) { server in
                        Text(verbatim: "\(server.host):\(server.port)").swipeActions {
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
