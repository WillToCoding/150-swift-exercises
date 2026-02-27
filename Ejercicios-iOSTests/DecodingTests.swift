//
//  DecodingTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests unitarios para la decodificación de JSON.
//  Estos tests son críticos porque en v3.1.0 hubo un bug donde los enums
//  no se decodificaban correctamente desde JSON (rawValues en español vs JSON en inglés).
//
//  Patrón aplicado: RawValue para decodificación (inglés) + DisplayName para UI (español)
//

import Foundation
import Testing
@testable import Ejercicios_iOS

// Typealias para evitar ambigüedad con Category de otros módulos
typealias ExerciseCategory = Ejercicios_iOS.Category

@MainActor
@Suite("JSON Decoding Tests")
struct DecodingTests {

    // MARK: - Difficulty Decoding

    /// Given: String "basic" (como viene del JSON)
    /// When: Difficulty(rawValue:)
    /// Then: Devuelve .basic (no nil)
    @Test("Decodificar Difficulty.basic")
    func testDifficultyBasicDecoding() async throws {
        let result = Difficulty(rawValue: "basic")

        #expect(result == .basic, "Difficulty 'basic' debería decodificarse correctamente")
        #expect(result?.displayName == "Básico", "El displayName debería ser 'Básico'")
    }

    /// Given: String "intermediate"
    /// When: Difficulty(rawValue:)
    /// Then: Devuelve .intermediate
    @Test("Decodificar Difficulty.intermediate")
    func testDifficultyIntermediateDecoding() async throws {
        let result = Difficulty(rawValue: "intermediate")

        #expect(result == .intermediate, "Difficulty 'intermediate' debería decodificarse correctamente")
        #expect(result?.displayName == "Intermedio", "El displayName debería ser 'Intermedio'")
    }

    /// Given: String "advanced"
    /// When: Difficulty(rawValue:)
    /// Then: Devuelve .advanced
    @Test("Decodificar Difficulty.advanced")
    func testDifficultyAdvancedDecoding() async throws {
        let result = Difficulty(rawValue: "advanced")

        #expect(result == .advanced, "Difficulty 'advanced' debería decodificarse correctamente")
        #expect(result?.displayName == "Avanzado", "El displayName debería ser 'Avanzado'")
    }

    /// Given: String inválida "Básico" (español, formato incorrecto)
    /// When: Difficulty(rawValue:)
    /// Then: Devuelve nil (no debe coincidir con rawValue en inglés)
    @Test("Difficulty con rawValue inválido devuelve nil")
    func testDifficultyInvalidRawValue() async throws {
        let result = Difficulty(rawValue: "Básico")

        #expect(result == nil, "Un rawValue en español no debería decodificarse")
    }

    // MARK: - Category Decoding

    /// Given: String "math"
    /// When: ExerciseCategory(rawValue:)
    /// Then: Devuelve .math
    @Test("Decodificar ExerciseCategory.math")
    func testCategoryMathDecoding() async throws {
        let result = ExerciseCategory(rawValue: "math")

        #expect(result == .math, "ExerciseCategory 'math' debería decodificarse correctamente")
        #expect(result?.displayName == "Matemáticas", "El displayName debería ser 'Matemáticas'")
    }

    /// Given: String "recursion"
    /// When: ExerciseCategory(rawValue:)
    /// Then: Devuelve .recursion
    @Test("Decodificar ExerciseCategory.recursion")
    func testCategoryRecursionDecoding() async throws {
        let result = ExerciseCategory(rawValue: "recursion")

        #expect(result == .recursion, "ExerciseCategory 'recursion' debería decodificarse correctamente")
        #expect(result?.displayName == "Recursión", "El displayName debería ser 'Recursión'")
    }

    /// Given: Todas las categorías válidas
    /// When: ExerciseCategory(rawValue:) para cada una
    /// Then: Todas se decodifican correctamente
    @Test("Todas las categorías se decodifican", arguments: [
        ("arrays", ExerciseCategory.arrays),
        ("strings", ExerciseCategory.strings),
        ("numbers", ExerciseCategory.numbers),
        ("sorting", ExerciseCategory.sorting),
        ("searching", ExerciseCategory.searching),
        ("recursion", ExerciseCategory.recursion),
        ("math", ExerciseCategory.math),
        ("dataStructures", ExerciseCategory.dataStructures),
        ("logic", ExerciseCategory.logic),
        ("algorithms", ExerciseCategory.algorithms)
    ])
    func testAllCategoriesDecoding(rawValue: String, expected: ExerciseCategory) async throws {
        let result = ExerciseCategory(rawValue: rawValue)

        #expect(result == expected, "ExerciseCategory '\(rawValue)' debería ser \(expected)")
    }

    /// Given: String "Matemáticas" (español, formato incorrecto)
    /// When: ExerciseCategory(rawValue:)
    /// Then: Devuelve nil
    @Test("ExerciseCategory con rawValue inválido devuelve nil")
    func testCategoryInvalidRawValue() async throws {
        let result = ExerciseCategory(rawValue: "Matemáticas")

        #expect(result == nil, "Un rawValue en español no debería decodificarse")
    }

    // MARK: - Exercise JSON Decoding

    /// Given: JSON válido de un ejercicio
    /// When: JSONDecoder().decode(Exercise.self, from: data)
    /// Then: Se decodifica correctamente
    @Test("Decodificar Exercise desde JSON")
    func testExerciseJSONDecoding() async throws {
        let json = """
        {
            "id": 1,
            "title": "Suma de Dos Números",
            "description": "Escribe una función que sume dos números.",
            "difficulty": "basic",
            "category": "math",
            "inputType": "twoNumbers"
        }
        """
        let data = json.data(using: .utf8)!

        let exercise = try JSONDecoder().decode(Exercise.self, from: data)

        #expect(exercise.id == 1, "El id debería ser 1")
        #expect(exercise.title == "Suma de Dos Números", "El título debería coincidir")
        #expect(exercise.difficulty == "basic", "La dificultad debería ser 'basic'")
        #expect(exercise.category == "math", "La categoría debería ser 'math'")
    }

    /// Given: JSON con campos opcionales (explanation, diagramImage)
    /// When: JSONDecoder().decode(Exercise.self, from: data)
    /// Then: Se decodifica con campos opcionales como nil
    @Test("Decodificar Exercise con campos opcionales nil")
    func testExerciseJSONDecodingWithOptionals() async throws {
        let json = """
        {
            "id": 2,
            "title": "Test",
            "description": "Description",
            "difficulty": "intermediate",
            "category": "arrays",
            "inputType": "text"
        }
        """
        let data = json.data(using: .utf8)!

        let exercise = try JSONDecoder().decode(Exercise.self, from: data)

        #expect(exercise.explanation == nil, "explanation debería ser nil")
        #expect(exercise.diagramImage == nil, "diagramImage debería ser nil")
    }

    /// Given: JSON con campos opcionales presentes
    /// When: JSONDecoder().decode(Exercise.self, from: data)
    /// Then: Se decodifican los campos opcionales
    @Test("Decodificar Exercise con campos opcionales presentes")
    func testExerciseJSONDecodingWithOptionalsPresent() async throws {
        let json = """
        {
            "id": 3,
            "title": "Test con explicación",
            "description": "Description",
            "difficulty": "advanced",
            "category": "algorithms",
            "inputType": "array",
            "explanation": "Esta es la explicación del algoritmo",
            "diagramImage": "diagram_test_03"
        }
        """
        let data = json.data(using: .utf8)!

        let exercise = try JSONDecoder().decode(Exercise.self, from: data)

        #expect(exercise.explanation == "Esta es la explicación del algoritmo", "explanation debería estar presente")
        #expect(exercise.diagramImage == "diagram_test_03", "diagramImage debería estar presente")
    }

    // MARK: - ExerciseWrapper Mapping

    /// Given: Exercise con difficulty="advanced" y category="sorting"
    /// When: Se crea ExerciseWrapper
    /// Then: Los enums se mapean correctamente (no usan fallback)
    @Test("ExerciseWrapper mapea enums correctamente")
    func testExerciseWrapperEnumMapping() async throws {
        let metadata = Exercise(
            id: 16,
            title: "Test Sorting",
            description: "Test",
            difficulty: "intermediate",
            category: "sorting",
            inputType: "array",
            explanation: nil,
            diagramImage: nil
        )

        let wrapper = ExerciseWrapper(
            metadata: metadata,
            executable: Exercise16(),
            blockId: "test"
        )

        // Verificar que NO usa los fallbacks (.basic, .math)
        #expect(wrapper.difficulty == .intermediate, "Debería ser .intermediate, no el fallback .basic")
        #expect(wrapper.category == .sorting, "Debería ser .sorting, no el fallback .math")
    }
}
