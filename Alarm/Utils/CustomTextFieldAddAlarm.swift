//
//  CustomTextFieldAddAlarm.swift
//  Alarm
//
//  Created by Carlos Mata on 8/21/23.
//

import SwiftUI

struct CustomTextFieldAddAlarm: View {
    @Binding var text: String
    let placeholder: Text
    var body: some View {
        ZStack(alignment: .leading){
            if text.isEmpty{
                placeholder
                    .foregroundColor(Color(.init(white: 1, alpha: 0.8)))
                    .padding(.leading, 40)
            }
                TextField("", text: $text)
        }
    }
}
