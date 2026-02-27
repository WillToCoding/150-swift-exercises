//
//  ExerciseHeader.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 20/02/26.
//

import SwiftUI

struct ExerciseHeader: View {
    let exercise: ExerciseWrapper

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.title)
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                DifficultyBadge(difficulty: exercise.difficulty)

                HStack(spacing: 6) {
                    Image(systemName: exercise.category.icon)
                    Text(exercise.category.displayName)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ExerciseHeader(exercise: ExerciseWrapper.test)
        .padding()
}
