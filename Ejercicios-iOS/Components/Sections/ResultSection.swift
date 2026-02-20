//
//  ResultSection.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 20/02/26.
//

import SwiftUI

struct ResultSection: View {
    let result: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Text("Resultado")
                    .font(.headline)
            }

            Text(result)
                .font(.system(.body, design: .monospaced))
                .textSelection(.enabled)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    ResultSection(result: "La suma es: 55")
        .padding()
}
