//
//  RegistrationView.swift
//  Alarm
//
//  Created by Carlos Mata on 8/6/23.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullname: String = ""
    @State private var username: String = ""
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.green, Color.purple]), startPoint: .bottomLeading, endPoint: .topLeading)
                .ignoresSafeArea()
            VStack{
                
                Text("New Account")
                    .font(.system(size: 30))
                    .scaledToFit()
                    .frame(width: 220, height: 100)
                    .foregroundColor(.white)
                    .padding(.top, 25)
                
                VStack(spacing: 20) {
                    
                    CustomTextField(text: $fullname, placeholder: Text("Full Name"), iconImage: "person")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    
                    CustomTextField(text: $email, placeholder: Text("Email"), iconImage: "envelope")
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    
                    CustomSecureField(text: $password, placeholder: Text("Password"))
                        .padding()
                        .background(Color(.init(white: 1, alpha: 0.15)))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                }
                
                Button(action: {
                    viewModel.register(withEmail: email, password: password,  fullname: fullname)
                }, label: {
                    Text("Sign up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 360, height: 50)
                        .background(Color.purple)
                        .clipShape(Capsule())
                        .padding()
                })
                Spacer()
                
                Button(action: {mode.wrappedValue.dismiss()}, label: {
                    HStack{
                        Text("Already have an account?")
                            .font(.system(size: 16))
                        Text("Sign In")
                            .font(.system(size: 16))
                    }.foregroundColor(.white)})
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
