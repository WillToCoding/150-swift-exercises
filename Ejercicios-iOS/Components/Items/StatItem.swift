//
//  StatItem.swift
//  Ejercicios-iOS
//
//  Extraído de ExerciseListView.swift
//

import SwiftUI

struct StatItem: View {
    let title: String
    let value: Int
    let color: Color
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(isSelected ? color.opacity(0.15) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            onTap?()
        }
    }
}

#Preview {
    HStack {
        StatItem(title: "Total", value: 150, color: .blue, isSelected: true)
        StatItem(title: "Básico", value: 80, color: .green)
    }
    .padding()
}
