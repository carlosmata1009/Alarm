//
//  LoginView.swift
//  Alarm
//
//  Created by Carlos Mata on 8/6/23.
//

import SwiftUI

struct LoginView: View {
    @State private var showAlertEmail = false
    @State private var email: String = ""
    @State private var password: String = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.green, Color.purple]), startPoint: .bottomLeading, endPoint: .topLeading)
                    .ignoresSafeArea()
                VStack{
                    
                    Text("My Alarm")
                        .font(.system(size: 50))
                        .scaledToFit()
                        .frame(width: 220, height: 100)
                        .foregroundColor(.white)
                        .padding(.top, 25)
                    
                    VStack(spacing: 20) {
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
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            email = ""
                            showAlertEmail = true
                        }, label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top)
                                .padding(.trailing, 32)
                        }) .alert("Reset Password", isPresented: $showAlertEmail){
                            TextField("Email", text: $email)
                            Button("Cancel", role: .cancel){}
                            Button("Ok", action: {
                                viewModel.resetPasswordByEmail(email: email)
                            })
                        } message: {
                            Text("Enter your email to reset your password.")
                        }
                        .alert(isPresented: $viewModel.showErrorEmail) {
                            Alert(
                                title: Text("Error"),
                                message: Text("This email doesn't have an account, try with another email"),
                                dismissButton: .default(Text("OK"), action: {
                                    viewModel.showErrorEmail = false
                                })
                            )
                        }
                    }
                    Button(action: {
                        viewModel.login(withEmail: email, password: password)
                    }, label: {
                        Text("Sign in")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 360, height: 50)
                            .background(Color.purple)
                            .clipShape(Capsule())
                            .padding()
                    })
                    Spacer()
                    NavigationLink(destination: RegistrationView().navigationBarHidden(true), label: {
                        HStack{
                            Text("Don't have an account?")
                                .font(.system(size: 16))
                            Text("Sign Up")
                                .font(.system(size: 16))
                        }.foregroundColor(.white)
                    }).padding(.bottom,16)
                }
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
