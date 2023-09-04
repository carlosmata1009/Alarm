//
//  User.swift
//  Alarm
//
//  Created by Carlos Mata on 8/7/23.
//

import FirebaseFirestoreSwift

struct User: Codable{
    let fullname: String
    let email: String
    @DocumentID var id: String?
    let alarms: [Alarm]
}
