//
//  AlarmApp.swift
//  Alarm
//
//  Created by Carlos Mata on 8/6/23.
//

import SwiftUI
import Firebase

@main
struct AlarmApp: App {
    init(){
        FirebaseApp.configure()
    }
    @StateObject var userNotifications = UserNotifications()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
                .environmentObject(userNotifications)
        }
    }
}
