//
//  AlarmModel.swift
//  Alarm
//
//  Created by Carlos Mata on 8/10/23.
//

import FirebaseFirestoreSwift
import Foundation

struct Alarm :  Codable{
    
    var date : String
    var ringtone : String
    var nameOfAlarm: String
    var activated: Bool
    var repeatedDays: [String]
    var id: String = UUID().uuidString
    var dictionary: [String: Any]{
        return[
            "id": id,
            "date": date,
            "ringtone": ringtone,
            "nameOfAlarm": nameOfAlarm,
            "activated": activated,
            "repeatedDays": repeatedDays
        ]
    }
}
