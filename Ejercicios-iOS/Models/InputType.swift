//
//  InputType.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

/// Tipo de entrada que requiere el ejercicio
enum InputType: String, CaseIterable {
    case none                   // Sin entrada requerida (ej: Fibonacci fijo)
    case singleNumber           // Un solo número (ej: "5")
    case multipleNumbers        // Varios números separados por comas (ej: "1,2,3,4,5")
    case text                   // Texto libre (ej: "Hola mundo")
    case array                  // Array en formato JSON (ej: "[1,2,3,4,5]")
    case twoNumbers             // Dos números separados por coma (ej: "10,5")

    /// Indica si el ejercicio requiere entrada del usuario
    var requiresInput: Bool {
        self != .none
    }

    /// Placeholder sugerido para el campo de entrada
    var placeholder: String {
        switch self {
        case .none:
             ""
        case .singleNumber:
             "Ingresa un número"
        case .multipleNumbers:
             "Ingresa números separados por comas (1,2,3)"
        case .text:
             "Ingresa un texto"
        case .array:
             "Ingresa un array en formato JSON [1,2,3]"
        case .twoNumbers:
             "Ingresa dos números separados por coma (10,5)"
        }
    }

    /// Tipo de teclado recomendado
    var keyboardType: String {
        switch self {
        case .none:
             "default"
        case .singleNumber, .multipleNumbers, .twoNumbers, .array:
             "numbersAndPunctuation"
        case .text:
             "default"
        }
    }
}
