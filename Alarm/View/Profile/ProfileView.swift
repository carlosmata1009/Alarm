//
//  ProfileView.swift
//  Alarm
//
//  Created by Carlos Mata on 8/7/23.
//

import SwiftUI
import Firebase

struct ProfileView: View {
    
    let user: User
    @State private var showingAlert = false
    @State private var showingAlertPassword = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var newPassword: String = ""
    @State private var fullname: String = ""
    @State private var username: String = ""
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.green, Color.purple]), startPoint: .bottomLeading, endPoint: .topLeading)
                .ignoresSafeArea()
            VStack {
                Text("Profile").padding(.top, -40)
                    .font(.system(size: 50))
                    .scaledToFit()
                    .frame(width: 220, height: 100)
                    .foregroundColor(.white)
                    .padding(.top, 25)

                VStack(spacing: 30){
                    VStack{
                        Text("Email").padding(.trailing, 270).foregroundColor(.white)
                        CustomTextField(text: $email, placeholder: Text("\(user.email)"), iconImage: "envelope")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                    }
                    VStack{
                        Text("Full name").padding(.trailing, 250).foregroundColor(.white)
                        CustomTextField(text: $fullname, placeholder: Text("\(user.fullname)"), iconImage: "person")
                            .padding()
                            .background(Color(.init(white: 1, alpha: 0.15)))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                    }
                }.padding(.top, -30)
                
                VStack(spacing: 15){
                    HStack{
                        
                        //Save button
                        Button(action:{
                            viewModel.updateUserInfo(email: email, fullname: fullname)
                            email = ""
                            fullname = ""
                        }, label:{
                            Text("Save")
                        }).customButtonStyle()
                        
                        //Change password Button
                        Button(action: {
                            password = ""
                            newPassword = ""
                            showingAlertPassword = true
                        }, label: {
                            Text("Change \n Password")
                        }).customButtonStyle()
                            .alert("Change Password", isPresented: $showingAlertPassword){
                                SecureField("Password", text:$password)
                                SecureField("New Password", text:$newPassword)
                                Button("Cancel", role: .cancel){}
                                Button("Ok", action: {
                                    viewModel.changePassword(password: password, newPassword: newPassword)
                                })
                            } message: {
                                Text("Enter your new password to change your current password.")
                            }
                            .alert(isPresented: $viewModel.showErrorAlertPassword) {
                                Alert(
                                    title: Text("Error"),
                                    message: Text("Your password is not correct, try again"),
                                    dismissButton: .default(Text("OK"), action: {
                                        viewModel.showErrorAlertPassword = false
                                    })
                                )
                            }
                        
                    }
                    
                    HStack(){
                        //Sign out button
                        Button(action: {
                            AuthViewModel.shared.signout()
                        }, label: {
                            Text("Sign out")
                        }).customButtonStyle()
                        //Delete account button
                        Button(action: {
                        password = ""
                            showingAlert = true
                        }, label: {
                            Text("Delete \n account")
                        })
                        .customButtonStyle()
                        .alert("Delete Account", isPresented: $showingAlert){
                            SecureField("Password", text:$password)
                            Button("Cancel", role: .cancel){}
                            Button("Delete", action: {
                                viewModel.deleteAccount(password: password)}
                            )
                        } message: {
                            Text("Enter your password to delte your account")
                        }
                        .alert(isPresented: $viewModel.showErrorAlertAccount) {
                            Alert(
                                title: Text("Error"),
                                message: Text("Your password is not correct, try again"),
                                dismissButton: .default(Text("OK"), action: {
                                    viewModel.showErrorAlertAccount = false
                                })
                            )
                        }
                    }
                }.padding(.top, 40)
                Spacer()
            }
        }
    }
}

