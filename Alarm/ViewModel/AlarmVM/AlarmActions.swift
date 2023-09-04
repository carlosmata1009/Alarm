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
