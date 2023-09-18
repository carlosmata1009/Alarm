//
//  UserNotifications.swift
//  Alarm
//
//  Created by Carlos Mata on 8/27/23.
//

import UserNotifications
import AVFoundation

class UserNotifications: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    
    //Notifications auth
    func requestAuthorizationToUser(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted{
                print("granted")
            }
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func pushNotification(arrayOfAlarms: [Alarm]){
        print(arrayOfAlarms)
        self.requestAuthorizationToUser()
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) else { return }

            if settings.alertSetting == .enabled {
                
                for alarm in arrayOfAlarms{
                    
                    if let _ = Bundle.main.url(forResource: "song", withExtension: "mp3") {
                        let content = UNMutableNotificationContent()
                        content.title = alarm.nameOfAlarm
                        content.body = "Alarm"
                        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "song.wav"))

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm"
                        let alarmFormatted = dateFormatter.date(from: alarm.date)
                        
                        let calendar = Calendar.current
                        let dateComponents = calendar.dateComponents([.hour, .minute], from: alarmFormatted ?? Date())
                        
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        let request = UNNotificationRequest(identifier: alarm.id, content: content, trigger: trigger)
                        center.add(request) { error in
                            if let error = error {
                                print("Error scheduling notification: \(alarm.id), \(error.localizedDescription)")
                            } else {
                                print("Notification scheduled successfully \(alarm.date)")
                            }
                        }
                    }else{
                        print("Not found")
                    }
                }
            } else {
                self.requestAuthorizationToUser()
            }

        }
    }
}
