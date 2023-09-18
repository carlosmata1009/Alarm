//
//  AlarmActions.swift
//  Alarm
//
//  Created by Carlos Mata on 8/22/23.
//

import Foundation
import Firebase

class AlarmActions: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    init(){
        userSession = Auth.auth().currentUser
    }
    
    func saveAlarm(alarm: Alarm){
        
        guard let uid = userSession?.uid else{return}
        let db = Firestore.firestore().collection("users").document(uid)
        
        db.updateData([
            "alarms": FieldValue.arrayUnion([alarm.dictionary])
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func actualHourAndMinutesInSeconds()-> TimeInterval{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let hour = TimeInterval(calendar.component(.hour, from: currentDate))
        let minute = TimeInterval(calendar.component(.minute, from: currentDate))
        let seconds = TimeInterval(calendar.component(.second, from: currentDate))
        
        let segundosHoras = TimeInterval(hour * 60 * 60)
        let segundosMinutos = TimeInterval(minute * 60)
        
        let secondsTotal = segundosHoras + segundosMinutos + seconds
        
        return TimeInterval(secondsTotal)
    }
    
    func fetchFieldsdOfAlarms() async throws -> [(id: String, seconds: TimeInterval)]{
        
        var arrayOfIdsAndActivated: [(id: String, date: String, value: Bool)] = []
        var arrayOfSecondsAndId: [(id: String, seconds: TimeInterval)] = []
        let ArrayOfAlarms = try await loadAlarms()
        let dayInSeconds = TimeInterval(60 * 60 * 24)
       
        for alarm in ArrayOfAlarms{
            if alarm.activated{
                arrayOfIdsAndActivated.append((alarm.id, alarm.date, alarm.activated))
            }
        }
        
        for alarm in arrayOfIdsAndActivated {
            
            let components = alarm.date.split(separator: ":")
            let hoursAlarm = TimeInterval(components[0])
            let minutesAlarm = TimeInterval(components[1])
            let segundosHoras = hoursAlarm! * 60 * 60
            let segundosMinutos = minutesAlarm! * 60
        
            let dateInSeconds = segundosHoras + segundosMinutos
            
            let actualTimeSeconds = actualHourAndMinutesInSeconds()
            
            if(dateInSeconds > actualTimeSeconds){
                let diffenceOfSeconds = dateInSeconds - actualTimeSeconds
                print(diffenceOfSeconds)
                arrayOfSecondsAndId.append((id: alarm.id, seconds: TimeInterval(diffenceOfSeconds)))
            }else{
                let diffenceOfSeconds = (dayInSeconds - actualTimeSeconds) + dateInSeconds
                print(diffenceOfSeconds)
                arrayOfSecondsAndId.append((id: alarm.id, seconds: TimeInterval(diffenceOfSeconds)))
            }
        }
        
        return arrayOfSecondsAndId
    }

    func loadAlarms() async throws -> [Alarm] {
        let uid = (userSession?.uid) ?? "23456754321"
        let db = Firestore.firestore().collection("users").document(uid)
        
        do {
            let document = try await db.getDocument()

            if let data = document.get("alarms") as? [[String: Any?]] {

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let json = try JSONSerialization.data(withJSONObject: data)
                let alarms = try decoder.decode([Alarm].self, from: json)
                return alarms
            } else {
                throw NSError(domain: "com.yourdomain", code: -1, userInfo: nil)
            }
        } catch {
            throw error
        }
    }

    func updateArrayOfAlarms(array: [Alarm]) {
        guard let uid = userSession?.uid else{return}
        do{
            let db = Firestore.firestore().collection("users").document(uid)
            var alarmsDict: [[String: Any]] = []
            for alarm in array {
                let alarmDict: [String: Any] = [
                    "id": alarm.id,
                    "nameOfAlarm": alarm.nameOfAlarm,
                    "activated": alarm.activated,
                    "date": alarm.date,
                    "ringtone": alarm.ringtone,
                    "repeatedDays": alarm.repeatedDays
                ]
                alarmsDict.append(alarmDict)
            }
            db.updateData([
                "alarms": alarmsDict
            ]){ error in
                if let error = error {
                    print("Error updating alarms: \(error)")
                } else {
                    print("Alarms updated successfully")
                }
            }
        }
    }
    
}
