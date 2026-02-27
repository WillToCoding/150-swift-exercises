//
//  StatBadge.swift
//  Ejercicios-iOS
//
//  Extraído de BlockSelectionView.swift
//

import SwiftUI

struct StatBadge: View {
    let value: Int
    let color: Color

    var body: some View {
        Text("\(value)")
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

#Preview {
    HStack(spacing: 6) {
        StatBadge(value: 75, color: .green)
        StatBadge(value: 57, color: .orange)
        StatBadge(value: 19, color: .red)
    }
    .padding()
    .background(Color.black)
}
