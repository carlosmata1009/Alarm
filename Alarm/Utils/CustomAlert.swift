//
//  CustomAlert.swift
//  Alarm
//
//  Created by Carlos Mata on 8/31/23.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var alertState: AlertState?
    var dismissAction: (() -> Void)?

    var body: some View {
        ZStack {
            if let alert = alertState {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Text(alert.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(alert.message)
                    Button("OK") {
                        alert.action?() // Execute the action closure
                        dismissAction?()
                        alertState = nil
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                }
                .frame(width: 300)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            }
        }
    }
}
