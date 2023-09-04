//
//  ContentView.swift
//  Alarm
//
//  Created by Carlos Mata on 8/6/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var userNotifications: UserNotifications
    var body: some View {
        Group{
            if viewModel.userSession == nil {
                LoginView()
            }else{
                if let user = viewModel.currentUser{
                    MainTabView(user: user)
                }
            }
        }
    }
}
