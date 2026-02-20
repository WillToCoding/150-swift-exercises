//
//  DifficultyBadge.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 6/12/25.
//

import SwiftUI

struct DifficultyBadge: View {
    let difficulty: Difficulty

    private var badgeColor: Color {
        switch difficulty {
        case .basic:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }

    var body: some View {
        Text(difficulty.displayName)
            .font(.caption2)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundStyle(badgeColor)
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 10) {
        DifficultyBadge(difficulty: .basic)
        DifficultyBadge(difficulty: .intermediate)
        DifficultyBadge(difficulty: .advanced)
    }
    .padding()
}
