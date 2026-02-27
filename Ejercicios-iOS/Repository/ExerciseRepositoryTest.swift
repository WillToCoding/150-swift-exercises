//
//  ExerciseRepositoryTest.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 23/2/26.
//

import Foundation

/// Repositorio de prueba que carga ejercicios desde datos controlados
/// Similar a NetworkTest en EmpleadosAPI
@MainActor
struct ExerciseRepositoryTest: ExerciseRepositoryProtocol {

    // MARK: - Test Data

    private var testExercises: [ExerciseWrapper] {
        [
            ExerciseWrapper(
                metadata: Exercise(
                    id: 1,
                    title: "Suma de Array",
                    description: "Ejercicio de prueba",
                    difficulty: "basic",
                    category: "arrays",
                    inputType: "array",
                    explanation: nil,
                    diagramImage: nil
                ),
                executable: TestExecutable(exerciseId: 1),
                blockId: "test"
            )
        ]
    }

    // MARK: - ExerciseRepositoryProtocol

    func getAllExercises() -> [ExerciseWrapper] {
        testExercises
    }

    func getExercises(forBlock blockId: String) -> [ExerciseWrapper] {
        testExercises.filter { $0.blockId == blockId }
    }

    func getExercise(byId id: Double) -> ExerciseWrapper? {
        testExercises.first { $0.id == id }
    }

    func getExercises(byDifficulty difficulty: Difficulty) -> [ExerciseWrapper] {
        testExercises.filter { $0.difficulty == difficulty }
    }

    func getExercises(byCategory category: Category) -> [ExerciseWrapper] {
        testExercises.filter { $0.category == category }
    }

    func searchExercises(query: String) -> [ExerciseWrapper] {
        guard !query.isEmpty else { return testExercises }
        return testExercises.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }

    func getStatistics() -> (total: Int, basic: Int, intermediate: Int, advanced: Int) {
        (
            total: testExercises.count,
            basic: testExercises.filter { $0.difficulty == .basic }.count,
            intermediate: testExercises.filter { $0.difficulty == .intermediate }.count,
            advanced: testExercises.filter { $0.difficulty == .advanced }.count
        )
    }
}

// MARK: - Test Executable

private struct TestExecutable: ExecutableExercise {
    let exerciseId: Int

    func execute(input: String) async throws -> String {
        "Resultado de prueba: \(input)"
    }
}
