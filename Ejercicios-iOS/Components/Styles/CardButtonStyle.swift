//
//  CardButtonStyle.swift
//  Ejercicios-iOS
//
//  Extraído de BlockSelectionView.swift
//

import SwiftUI

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    Button("Test Card") {
        print("Pressed")
    }
    .buttonStyle(CardButtonStyle())
    .padding()
}
