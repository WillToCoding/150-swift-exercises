//
//  ExerciseCard.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import SwiftUI

struct ExerciseCard: View {
    let exercise: ExerciseWrapper
    var showBlock: Bool = true

    private var blockInfo: (name: String, color: Color) {
        switch exercise.blockId {
        case "intro1": return ("Intro I", Color(red: 0.61, green: 0.35, blue: 0.71))
        case "intro2": return ("Intro II", Color(red: 0.95, green: 0.77, blue: 0.06))
        case "basicos": return ("Básicos", Color(red: 0.20, green: 0.78, blue: 0.35))
        case "repaso": return ("Repaso", Color(red: 0.20, green: 0.60, blue: 0.86))
        case "algoritmia": return ("Algoritmia", Color(red: 0.91, green: 0.30, blue: 0.24))
        default: return ("", .gray)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header con bloque, número y dificultad
            HStack {
                if showBlock {
                    BlockBadge(name: blockInfo.name, color: blockInfo.color)
                }

                Text("#\(exercise.id.formattedId)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.secondary)

                Spacer()

                DifficultyBadge(difficulty: exercise.difficulty)
            }

            // Título
            Text(exercise.title)
                .font(.headline)
                .fontWeight(.semibold)

            // Categoría con icono
            HStack(spacing: 6) {
                Image(systemName: exercise.category.icon)
                    .font(.caption)
                Text(exercise.category.displayName)
                    .font(.caption)
            }
            .foregroundStyle(.secondary)
        }
        .padding()
        #if os(iOS)
        .background(Color(.systemBackground))
        #else
        .background(Color(nsColor: .windowBackgroundColor))
        #endif
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    ExerciseCard(exercise: ExerciseWrapper.test)
        .padding()
}
