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
    
    @StateObject var userNotifications = UserNotifications()
    private var managerAudio = ManagerAudioBackground()
    @Environment(\.scenePhase) private var phase
    @StateObject private var alarmActions = AlarmActions()
    @State private var turnedOnAlarms: [(id: String, seconds: TimeInterval)] = []
 
    init(){
        FirebaseApp.configure()
        managerAudio.setupAudioSession()
    }
    var body: some Scene {
        
        
        WindowGroup {
            ContentView()
                .environmentObject(AuthViewModel.shared)
                .environmentObject(userNotifications)
                .onAppear {
                    Task {
                        do {
                            let alarms = try await alarmActions.fetchFieldsdOfAlarms()
                            turnedOnAlarms = alarms
                        } catch {
                            print("Error fetching alarms: \(error.localizedDescription)")
                        }
                    }
                }
                .onChange(of: phase){ newPhase in
                    switch newPhase {
                    case .background: managerAudio.playSongFromResourcesWithDelay(delayTime: turnedOnAlarms)
                    case .active: managerAudio.stopSong()
                    default: break
                }
            }
        }
    }
}
