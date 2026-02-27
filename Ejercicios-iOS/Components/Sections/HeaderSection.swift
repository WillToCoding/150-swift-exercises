//
//  HeaderSection.swift
//  Ejercicios-iOS
//
//  Extraído de BlockSelectionView.swift
//

import SwiftUI

struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 16) {
            // Logo WillToCoding
            Image("logoWhite")
                .resizable()
                .scaledToFit()
                .frame(height: 90)
                .accessibilityLabel("Logo WillToCoding")

            VStack(spacing: 8) {
                Text("Swift 6")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(white: 0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("150 Ejercicios de Programación")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(white: 0.6))
            }

            Text("Selecciona un bloque")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color(white: 0.5))
                .padding(.top, 8)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

#Preview {
    ZStack {
        Color.black
        HeaderSection()
    }
}
