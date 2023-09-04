//
//  validInformation.swift
//  Alarm
//
//  Created by Carlos Mata on 9/1/23.
//

import Foundation

func isValidEmail(email: String) -> Bool
{
    var returnValue = true
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    let regex = try! NSRegularExpression(pattern: emailRegEx)
    let nsRange = NSRange(location: 0, length: email.count)
    let results = regex.matches(in: email, range: nsRange)
    if results.count == 0
    {
        returnValue = false
    }
    return  returnValue
}
func isValidFullName(fullname: String) -> Bool {
    let components = fullname.split(separator: " ")
    return components.count == 2 && !components.contains { $0.isEmpty }
}
