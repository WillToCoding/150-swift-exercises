//
//  InputSection.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 20/02/26.
//

import SwiftUI

struct InputSection: View {
    @Binding var inputText: String
    let inputType: InputType
    let onExecute: () -> Void
    let isExecuting: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Solo mostrar entrada si el ejercicio la requiere
            if inputType.requiresInput {
                Text("Entrada")
                    .font(.headline)

                TextField(inputType.placeholder, text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isExecuting)
                    .submitLabel(.done)
                    .onSubmit {
                        onExecute()
                    }
            }

            Button(action: onExecute) {
                if isExecuting {
                    HStack {
                        ProgressView()
                            .tint(.white)
                        Text("Ejecutando...")
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Text("Ejecutar")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(isExecuting || (inputType.requiresInput && inputText.isEmpty))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    @Previewable @State var text = "42"

    InputSection(
        inputText: $text,
        inputType: .singleNumber,
        onExecute: {},
        isExecuting: false
    )
    .padding()
}

#Preview("Ejecutando") {
    @Previewable @State var text = "42"

    InputSection(
        inputText: $text,
        inputType: .singleNumber,
        onExecute: {},
        isExecuting: true
    )
    .padding()
}
