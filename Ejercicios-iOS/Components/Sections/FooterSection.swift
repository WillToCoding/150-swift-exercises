//
//  FooterSection.swift
//  Ejercicios-iOS
//
//  Extraído de BlockSelectionView.swift
//

import SwiftUI

struct FooterSection: View {
    private var totalExercises: Int {
        ExerciseBlock.allBlocks.reduce(0) { $0 + $1.exerciseCount }
    }

    private var implementedExercises: Int {
        ExerciseBlock.allBlocks
            .filter { $0.isAvailable }
            .reduce(0) { $0 + Int(Double($1.exerciseCount) * $1.progress) }
    }

    var body: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 40)

            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    Text("\(totalExercises)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Total")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                }

                VStack(spacing: 4) {
                    Text("\(implementedExercises)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.91, green: 0.30, blue: 0.24))
                    Text("Disponibles")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                }

                VStack(spacing: 4) {
                    Text("5")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Bloques")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                }
            }
            .padding(.vertical, 16)

            // Créditos
            Text("Apple Coding Academy - Swift Developer Program 2026")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(Color(white: 0.4))
                .padding(.bottom, 8)
        }
        .padding(.top, 20)
    }
}

#Preview {
    ZStack {
        Color.black
        FooterSection()
    }
}
