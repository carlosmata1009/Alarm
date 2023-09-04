//
//  CustomTextFieldProfile.swift
//  Alarm
//
//  Created by Carlos Mata on 8/7/23.
//

import SwiftUI

struct CustomTextFieldProfile: View {
    var user: User
    let placeholder: Text
    let iconImage: String
    var body: some View {
        ZStack(alignment: .leading){
            HStack{
                Image(systemName: iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)

            }
        }
    }
}
struct CustomTextFieldProfile_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldProfile( user: <#User#>, placeholder: Text("Email"), iconImage: "envelope")
    }
}
