//
//  AlarmApp.swift
//  Alarm
//
//  Created by Carlos Mata on 8/6/23.
//

import SwiftUI
import Firebase
import AVFoundation

@main
struct AlarmApp: App {
    
    @StateObject var userNotifications = UserNotifications()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
                .environmentObject(userNotifications)
        }
        
    }
}
