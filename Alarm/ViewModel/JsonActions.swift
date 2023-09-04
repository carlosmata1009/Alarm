//
//  JsonActions.swift
//  Alarm
//
//  Created by Carlos Mata on 8/11/23.
//

import Foundation
// The alarmData its now stored in firestore(alarmActions)
struct JsonActions {
    func saveJson(array: [Alarm]){
            let encoder = JSONEncoder()
            do{
                let data = try encoder.encode(array)
               if let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                   let file = document.appendingPathComponent("myAlarms.json")
                   do{
                       try data.write(to: file)
                       
                   }
                }
            }catch{
                print(error.localizedDescription)
            }
        }

    func loadJson() -> [Alarm]{
        var array : [Alarm] = []
        let decoder = JSONDecoder()
        let taskJSONURL = URL(fileURLWithPath: "myAlarms", relativeTo: .documentsDirectory).appendingPathExtension("json")
        do{
            let taskData = try Data(contentsOf: taskJSONURL)
            array = try decoder.decode([Alarm].self, from: taskData)
        }catch{
            print(error)
        }
        return array
    }
}



