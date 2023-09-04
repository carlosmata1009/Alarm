//
//  AuthViewModel.swift
//  Alarm
//
//  Created by Carlos Mata on 8/7/23.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var showErrorAlertAccount = false
    @Published var showErrorAlertPassword = false
    @Published var showErrorEmail = false

    static let shared = AuthViewModel()
    init(){
        userSession = Auth.auth().currentUser
        fetchUser()

    }
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail:email, password: password){ result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let user = result?.user else {return}
            self.userSession = user
            self.fetchUser()
        }
    }
    func register(withEmail email: String, password: String, fullname: String){
        if !fullname.isEmpty && isValidFullName(fullname: fullname) {
            Auth.auth().createUser(withEmail: email, password: password){ result, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let user = result?.user else {return}
                self.userSession = user
                let data = ["email": email, "fullname": fullname, "uid": user.uid, "alarms": []] as [String : Any]
                Firestore.firestore().collection("users").document(user.uid).setData(data){ _ in
                    self.userSession = user
                    self.fetchUser()
                }
            }
        }else{
            print("full name is not correct ")
        }
    }
    func signout(){
        self.userSession = nil
        try? Auth.auth().signOut()
    }
    func updateUserInfo(email: String, fullname: String){
        let user = Auth.auth().currentUser
        
        guard let uid = userSession?.uid else{return}
        if !email.isEmpty && isValidEmail(email: email) {
            Firestore.firestore().collection("users").document(uid).updateData(["email": email]) { error in
                if let error = error {
                    // Handle the Firestore update error.
                    print("Error updating email: \(error.localizedDescription)")
                } else {
                    // Successfully updated email.
                    user?.updateEmail(to: email) { error in
                        if let error = error {
                            // Handle the Firebase Authentication error.
                            print("Error updating email in Firebase Auth: \(error.localizedDescription)")
                        } else {
                            // Successfully updated email in Firebase Auth.
                            
                        }
                    }
                }
            }
        } else {
            print("Invalid email")
        }
            
        if !fullname.isEmpty && isValidFullName(fullname: fullname) {
            Firestore.firestore().collection("users").document(uid).updateData(["fullname": fullname]) { error in
                if let error = error {
                    // Handle the Firestore update error.
                    print("Error updating fullname: \(error.localizedDescription)")
                } else {
                    
                }
            }
        } else {
            print("Invalid fullname")
        }
    }
    
    func fetchUser(){
        guard let uid = userSession?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else {return}
            self.currentUser = user
            self.fetchUser()
        }
    }
    func deleteAccount(password: String){
        
        let user = Auth.auth().currentUser
        guard let uid = userSession?.uid else {return}
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: user?.email ?? "default@default.com", password: password)
        
        user?.reauthenticate(with: credential){authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.showErrorAlertAccount = true
            } else {
                user?.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        Firestore.firestore().collection("users").document(uid).delete()
                        print("The account of \(self.currentUser!.fullname) is being deleted.")
                        self.userSession = nil
                    }
                }
            }
        }
    }
    
    func changePassword(password: String, newPassword: String){
        
        let user = Auth.auth().currentUser
        let credential: AuthCredential = EmailAuthProvider.credential(withEmail: user?.email ?? "default@default.com", password: password)
        
        user?.reauthenticate(with: credential){authResult, error in
            if let error = error {
                print(error.localizedDescription)
                self.showErrorAlertPassword = true
            } else {
                user?.updatePassword(to: newPassword)
            }
        }
    }
    func resetPasswordByEmail(email: String){
        if(isValidEmail(email: email)){
            Auth.auth().sendPasswordReset(withEmail: email){ error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showErrorEmail = true               
                }else{
                    print("Succesfully send")
                }
            }
        }else{
            self.showErrorEmail = true
        }
    }
}
