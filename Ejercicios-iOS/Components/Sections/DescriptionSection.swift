//
//  DescriptionSection.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 20/02/26.
//

import SwiftUI

struct DescriptionSection: View {
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Descripción")
                .font(.headline)

            Text(description)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    DescriptionSection(description: "Dado un número entero positivo n, calcular la suma de todos los números desde 1 hasta n.")
        .padding()
}
