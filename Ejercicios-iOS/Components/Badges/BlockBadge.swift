//
//  BlockBadge.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 6/12/25.
//

import SwiftUI

struct BlockBadge: View {
    let name: String
    let color: Color

    var body: some View {
        Text(name)
            .font(.caption2)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

#Preview {
    VStack(spacing: 10) {
        BlockBadge(name: "Intro I", color: Color(red: 0.61, green: 0.35, blue: 0.71))
        BlockBadge(name: "Básicos", color: Color(red: 0.20, green: 0.78, blue: 0.35))
        BlockBadge(name: "Algoritmia", color: Color(red: 0.91, green: 0.30, blue: 0.24))
    }
    .padding()
}
