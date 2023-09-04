//
//  MainTabView.swift
//  Alarm
//
//  Created by Carlos Mata on 8/7/23.
//

import SwiftUI

struct MainTabView: View {
    let user: User
    var body: some View {
        NavigationView {
            TabView{
                AlarmPopoverView()
                    .tabItem{
                        Image(systemName: "house")
                    }
                ProfileView(user: user)
                    .tabItem{
                        Image(systemName: "person")
                    }
            }
            
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .accentColor(.black)
            .navigationBarHidden(true)
        }
    }
}
