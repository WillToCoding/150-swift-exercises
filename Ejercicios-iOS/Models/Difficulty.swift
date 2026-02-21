//
//  Difficulty.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation
import SwiftUI

/// Nivel de dificultad de los ejercicios
enum Difficulty: String, CaseIterable, Codable {
    case basic = "basic"
    case intermediate = "intermediate"
    case advanced = "advanced"

    /// Nombre localizado para mostrar en la UI
    var displayName: String {
        switch self {
        case .basic:
            "Básico"
        case .intermediate:
            "Intermedio"
        case .advanced:
            "Avanzado"
        }
    }

    /// Color asociado al nivel de dificultad
    var colorName: String {
        switch self {
        case .basic:
             "green"
        case .intermediate:
             "orange"
        case .advanced:
             "red"
        }
    }

    /// Color SwiftUI asociado al nivel de dificultad
    var color: Color {
        switch self {
        case .basic:
            .green
        case .intermediate:
            .orange
        case .advanced:
            .red
        }
    }
}
