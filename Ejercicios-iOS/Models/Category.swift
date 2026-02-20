//
//  Category.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

/// Categoría del ejercicio según el tipo de problema
enum Category: String, CaseIterable, Codable {
    case arrays = "arrays"
    case strings = "strings"
    case numbers = "numbers"
    case sorting = "sorting"
    case searching = "searching"
    case recursion = "recursion"
    case math = "math"
    case dataStructures = "dataStructures"
    case logic = "logic"
    case algorithms = "algorithms"

    /// Nombre localizado para mostrar en la UI
    var displayName: String {
        switch self {
        case .arrays:
            "Arrays"
        case .strings:
            "Strings"
        case .numbers:
            "Números"
        case .sorting:
            "Ordenamiento"
        case .searching:
            "Búsqueda"
        case .recursion:
            "Recursión"
        case .math:
            "Matemáticas"
        case .dataStructures:
            "Estructuras de Datos"
        case .logic:
            "Lógica"
        case .algorithms:
            "Algoritmos"
        }
    }

    /// Icono SF Symbol asociado a la categoría
    var icon: String {
        switch self {
        case .arrays:
             "square.grid.3x3"
        case .strings:
             "textformat"
        case .numbers:
             "number"
        case .sorting:
             "arrow.up.arrow.down"
        case .searching:
             "magnifyingglass"
        case .recursion:
             "arrow.triangle.2.circlepath"
        case .math:
             "function"
        case .dataStructures:
             "list.bullet.rectangle"
        case .logic:
             "brain.head.profile"
        case .algorithms:
             "cpu"
        }
    }
}
