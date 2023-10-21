//
//  UserStore.swift
//  process-viewer
//
//  Created by vmaster on 10/21/23.
//

import Foundation
import KeychainAccess

let USER_STORE_FILE: String = "user_store.txt"
let KEYCHAIN_SERVICE: String = "com.jerr-it.process_viewer"

class UserStore : ObservableObject {
    @Published var userList: [User]
    
    init() {
        self.userList = []
        self.loadUsers()
    }
    
    func addUser(user: User) {
        self.userList.append(user)
        self.saveUsers()
    }
    
    func removeUser(user: User) {
        self.userList = self.userList.filter {
            $0 != user
        }
        self.saveUsers()
    }
    
    func loadUsers() {
        var users: [User] = []
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDir.appendingPathComponent(USER_STORE_FILE)
            do {
                let fileStr = try String(contentsOf: fileURL, encoding: .utf8)
                let lines = fileStr.split(separator: "\n")
                for username in lines {
                    if let password = try? keychain.get("\(username)") {
                        users.append(User(name: String(username), password: password))
                    } else {
                        print("Keychain did not return a value")
                    }
                }
            } catch {
                print("Cannot access file of stored users: \(error)")
            }
        }
        
        self.userList = users
    }
    
    func saveUsers() {
        let keychain = Keychain(service: KEYCHAIN_SERVICE)
        if let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDir.appendingPathComponent(USER_STORE_FILE)
            do {
                for user in self.userList {
                    try "\(user.name)\n".write(to: fileURL, atomically: true, encoding: .utf8)
                    try keychain.set(user.password, key:"\(user.name)")
                }
            } catch {
                print("Unable to store users: \(error)")
            }
        }
    }
}
