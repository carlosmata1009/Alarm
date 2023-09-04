//
//  CustomButtonStyle.swift
//  Alarm
//
//  Created by Carlos Mata on 8/31/23.
//

import SwiftUI

struct CustomButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 150, height: 60)
            .background(Color.green)
            .clipShape(Capsule())
            .padding()
    }
}

extension View {
    func customButtonStyle() -> some View {
        self.modifier(CustomButtonStyle())
    }
}
