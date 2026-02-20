//
//  Exercise.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

// MARK: - Double Extension for ID Formatting

extension Double {
    /// Formatea el ID sin decimales innecesarios (5.0 → "5", 5.1 → "5.1")
    var formattedId: String {
        if self == floor(self) {
            return String(format: "%.0f", self)
        } else {
            return String(format: "%.1f", self)
        }
    }
}

/// Estructura que mapea los datos del JSON
struct Exercise: Codable {
    let id: Double
    let title: String
    let description: String
    let difficulty: String
    let category: String
    let inputType: String
    let explanation: String?
    let diagramImage: String?
}

// MARK: - Test Data Extension

extension Exercise {
    /// Ejemplo del primer ejercicio para pruebas
    static let testExample = Exercise(
        id: 1,
        title: "Suma de Dos Números",
        description: "Escribe una función que reciba dos números y devuelva su suma.\n\nEjemplo:\nEntrada: 5, 3\nSalida: 8",
        difficulty: "basic",
        category: "math",
        inputType: "twoNumbers",
        explanation: nil,
        diagramImage: nil
    )
}

// MARK: - Executable Protocol

/// Protocolo para ejercicios ejecutables (solo lógica, sin metadata)
protocol ExecutableExercise {
    var exerciseId: Int { get }
    @MainActor func execute(input: String) async throws -> String
}

// MARK: - Exercise Protocol

/// Protocolo que combina metadata del JSON con la implementación ejecutable
protocol ExerciseProtocol: Identifiable {
    var id: Double { get }
    var blockId: String { get }
    var uniqueId: String { get }
    var title: String { get }
    var description: String { get }
    var difficulty: Difficulty { get }
    var category: Category { get }
    var inputType: InputType { get }
    var explanation: String? { get }
    var diagramImage: String? { get }
    @MainActor func execute(input: String) async throws -> String
}

// MARK: - Exercise Wrapper

/// Combina metadata del JSON con implementación ejecutable
struct ExerciseWrapper: ExerciseProtocol {
    private let metadata: Exercise
    private let executable: ExecutableExercise
    let blockId: String

    var id: Double { metadata.id }
    var uniqueId: String { "\(blockId)_\(metadata.id)" }
    var title: String { metadata.title }
    var description: String { metadata.description }
    var difficulty: Difficulty { Difficulty(rawValue: metadata.difficulty) ?? .basic }
    var category: Category { Category(rawValue: metadata.category) ?? .math }
    var inputType: InputType { InputType(rawValue: metadata.inputType) ?? .text }
    var explanation: String? { metadata.explanation }
    var diagramImage: String? { metadata.diagramImage }

    init(metadata: Exercise, executable: ExecutableExercise, blockId: String) {
        self.metadata = metadata
        self.executable = executable
        self.blockId = blockId
    }

    func execute(input: String) async throws -> String {
        try await executable.execute(input: input)
    }
}

// MARK: - Error Handling

/// Errores comunes que pueden ocurrir al ejecutar ejercicios
enum ExerciseError: LocalizedError {
    case invalidInput(String)
    case emptyInput
    case invalidFormat(String)
    case outOfRange(String)

    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
             "Entrada inválida: \(message)"
        case .emptyInput:
             "La entrada no puede estar vacía"
        case .invalidFormat(let message):
             "Formato inválido: \(message)"
        case .outOfRange(let message):
             "Fuera de rango: \(message)"
        }
    }
}

// MARK: - Preview Data

extension ExerciseWrapper {
    /// Ejercicio básico de prueba (Suma de dos números)
    @MainActor static let test = ExerciseWrapper(
        metadata: .testExample,
        executable: Exercise01(),
        blockId: "algoritmia"
    )

    /// Ejercicio intermedio de prueba
    @MainActor static let testIntermediate = ExerciseWrapper(
        metadata: Exercise(
            id: 16,
            title: "Bubble Sort",
            description: "Implementa el algoritmo Bubble Sort para ordenar un array de números.\n\nEjemplo:\nEntrada: 5, 2, 8, 1\nSalida: 1, 2, 5, 8",
            difficulty: "intermediate",
            category: "sorting",
            inputType: "array",
            explanation: "Bubble Sort compara elementos adyacentes y los intercambia si están en el orden incorrecto.",
            diagramImage: nil
        ),
        executable: Exercise16(),
        blockId: "algoritmia"
    )

    /// Ejercicio avanzado de prueba
    @MainActor static let testAdvanced = ExerciseWrapper(
        metadata: Exercise(
            id: 31,
            title: "Algoritmo de Dijkstra",
            description: "Implementa el algoritmo de Dijkstra para encontrar el camino más corto.",
            difficulty: "advanced",
            category: "algorithms",
            inputType: "text",
            explanation: "Dijkstra encuentra el camino más corto desde un nodo origen a todos los demás nodos en un grafo ponderado.",
            diagramImage: "diagram_dijkstra"
        ),
        executable: Exercise31(),
        blockId: "algoritmia"
    )
}
