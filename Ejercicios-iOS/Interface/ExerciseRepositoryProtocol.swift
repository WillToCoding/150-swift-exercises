//
//  ExerciseRepositoryProtocol.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 23/2/26.
//

import Foundation

/// Protocolo que define las operaciones del repositorio de ejercicios
@MainActor
protocol ExerciseRepositoryProtocol: Sendable {
    /// Obtiene todos los ejercicios disponibles
    func getAllExercises() -> [ExerciseWrapper]

    /// Obtiene ejercicios de un bloque específico
    func getExercises(forBlock blockId: String) -> [ExerciseWrapper]

    /// Obtiene un ejercicio por su ID
    func getExercise(byId id: Double) -> ExerciseWrapper?

    /// Filtra ejercicios por dificultad
    func getExercises(byDifficulty difficulty: Difficulty) -> [ExerciseWrapper]

    /// Filtra ejercicios por categoría
    func getExercises(byCategory category: Category) -> [ExerciseWrapper]

    /// Busca ejercicios por título
    func searchExercises(query: String) -> [ExerciseWrapper]

    /// Obtiene estadísticas de los ejercicios
    func getStatistics() -> (total: Int, basic: Int, intermediate: Int, advanced: Int)
}
