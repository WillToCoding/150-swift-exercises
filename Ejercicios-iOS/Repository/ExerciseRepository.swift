//
//  ExerciseRepository.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

/// Repositorio que gestiona todos los ejercicios de algoritmia
@MainActor
struct ExerciseRepository: ExerciseRepositoryProtocol, DataRepository {

    // MARK: - Cache

    private static var cachedExercises: [ExerciseWrapper]?
    private static var cachedStats: (total: Int, basic: Int, intermediate: Int, advanced: Int)?

    // MARK: - DataRepository Properties

    var url: URL {
        Bundle.main.url(forResource: "algoritmia", withExtension: "json")!
    }

    // MARK: - Initialization

    init() {}

    // MARK: - JSON Loading Helper

    /// Carga ejercicios desde un archivo JSON específico
    private func loadExercises(from fileName: String) -> [Exercise] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let exercises = try? JSONDecoder().decode([Exercise].self, from: data) else {
            return []
        }
        return exercises
    }

    // MARK: - Exercises Collection

    /// Colección de todos los ejercicios disponibles
    func getAllExercises() -> [ExerciseWrapper] {
        // Usar caché si existe
        if let cached = Self.cachedExercises {
            return cached
        }

        var allExercises: [ExerciseWrapper] = []

        // Cargar Introducción I
        let intro1Exercises = loadBlockExercises(blockId: "intro1", executablesMap: [
            1: IntroI_Exercise01(), 2: IntroI_Exercise02(), 3: IntroI_Exercise03(), 4: IntroI_Exercise04(),
            5: IntroI_Exercise05(), 6: IntroI_Exercise06(), 7: IntroI_Exercise07(), 8: IntroI_Exercise08(),
            9: IntroI_Exercise09(), 10: IntroI_Exercise10(), 11: IntroI_Exercise11(), 12: IntroI_Exercise12(),
            13: IntroI_Exercise13(), 14: IntroI_Exercise14(), 15: IntroI_Exercise15(), 16: IntroI_Exercise16(),
            17: IntroI_Exercise17(), 18: IntroI_Exercise18(), 19: IntroI_Exercise19(), 20: IntroI_Exercise20()
        ])
        allExercises += intro1Exercises

        // Cargar Introducción II
        let intro2Exercises = loadBlockExercises(blockId: "intro2", executablesMap: [
            1: IntroII_Exercise01(), 2: IntroII_Exercise02(), 3: IntroII_Exercise03(), 4: IntroII_Exercise04(),
            5: IntroII_Exercise05(), 6: IntroII_Exercise06(), 7: IntroII_Exercise07(), 8: IntroII_Exercise08(),
            9: IntroII_Exercise09(), 10: IntroII_Exercise10(), 11: IntroII_Exercise11(), 12: IntroII_Exercise12(),
            13: IntroII_Exercise13(), 14: IntroII_Exercise14(), 15: IntroII_Exercise15(), 16: IntroII_Exercise16(),
            17: IntroII_Exercise17(), 18: IntroII_Exercise18(), 19: IntroII_Exercise19(), 20: IntroII_Exercise20()
        ])
        allExercises += intro2Exercises

        // Cargar Algoritmia
        let algoritmiaExercises = loadBlockExercises(blockId: "algoritmia", executablesMap: [
            // Básicos (1-15)
            1: Exercise01(), 2: Exercise02(), 3: Exercise03(), 4: Exercise04(), 5: Exercise05(),
            6: Exercise06(), 7: Exercise07(), 8: Exercise08(), 9: Exercise09(), 10: Exercise10(),
            11: Exercise11(), 12: Exercise12(), 13: Exercise13(), 14: Exercise14(), 15: Exercise15(),
            // Intermedios (16-30)
            16: Exercise16(), 17: Exercise17(), 18: Exercise18(), 19: Exercise19(), 20: Exercise20(),
            21: Exercise21(), 22: Exercise22(), 23: Exercise23(), 24: Exercise24(), 25: Exercise25(),
            26: Exercise26(), 27: Exercise27(), 28: Exercise28(), 29: Exercise29(), 30: Exercise30(),
            // Avanzados (31-45)
            31: Exercise31(), 32: Exercise32(), 33: Exercise33(), 34: Exercise34(), 35: Exercise35(),
            36: Exercise36(), 37: Exercise37(), 38: Exercise38(), 39: Exercise39(), 40: Exercise40(),
            41: Exercise41(), 42: Exercise42(), 43: Exercise43(), 44: Exercise44(), 45: Exercise45()
        ])
        allExercises += algoritmiaExercises

        // Cargar Básicos
        let basicosExercises = loadBlockExercises(blockId: "basicos", executablesMap: [
            1: Basico_Exercise01(), 2: Basico_Exercise02(), 3: Basico_Exercise03(), 4: Basico_Exercise04(),
            5: Basico_Exercise05(), 6: Basico_Exercise06(), 7: Basico_Exercise07(), 8: Basico_Exercise08(),
            9: Basico_Exercise09(), 10: Basico_Exercise10(), 11: Basico_Exercise11(), 12: Basico_Exercise12(),
            13: Basico_Exercise13(), 14: Basico_Exercise14(), 15: Basico_Exercise15(), 16: Basico_Exercise16(),
            17: Basico_Exercise17(), 18: Basico_Exercise18(), 19: Basico_Exercise19(), 20: Basico_Exercise20(),
            21: Basico_Exercise21(), 22: Basico_Exercise22(), 23: Basico_Exercise23(), 24: Basico_Exercise24(),
            25: Basico_Exercise25(), 26: Basico_Exercise26(), 27: Basico_Exercise27(), 28: Basico_Exercise28(),
            29: Basico_Exercise29(), 30: Basico_Exercise30()
        ])
        allExercises += basicosExercises

        // Cargar Repaso
        let repasoExercises = loadBlockExercises(blockId: "repaso", executablesMap: [
            1: Repaso_Exercise01(), 2: Repaso_Exercise02(), 3: Repaso_Exercise03(), 4: Repaso_Exercise04(),
            5: Repaso_Exercise05(), 6: Repaso_Exercise06(), 7: Repaso_Exercise07(), 8: Repaso_Exercise08(),
            9: Repaso_Exercise09(), 10: Repaso_Exercise10(), 11: Repaso_Exercise11(), 12: Repaso_Exercise12(),
            13: Repaso_Exercise13(), 14: Repaso_Exercise14(), 15: Repaso_Exercise15(), 16: Repaso_Exercise16(),
            17: Repaso_Exercise17(), 18: Repaso_Exercise18(), 19: Repaso_Exercise19(), 20: Repaso_Exercise20(),
            21: Repaso_Exercise21(), 22: Repaso_Exercise22(), 23: Repaso_Exercise23(), 24: Repaso_Exercise24(),
            25: Repaso_Exercise25(), 26: Repaso_Exercise26(), 27: Repaso_Exercise27(), 28: Repaso_Exercise28(),
            29: Repaso_Exercise29(), 30: Repaso_Exercise30(), 31: Repaso_Exercise31(), 32: Repaso_Exercise32(),
            33: Repaso_Exercise33(), 34: Repaso_Exercise34(), 35: Repaso_Exercise35()
        ])
        allExercises += repasoExercises

        // Guardar en caché
        Self.cachedExercises = allExercises
        return allExercises
    }

    /// Carga ejercicios de un bloque específico
    private func loadBlockExercises(blockId: String, executablesMap: [Int: any ExecutableExercise], decimalMap: [Double: any ExecutableExercise] = [:]) -> [ExerciseWrapper] {
        let metadataArray = loadExercises(from: blockId)

        return metadataArray.compactMap { metadata in
            // Primero buscar en el mapa decimal (para IDs como 5.1, 5.2)
            if let executable = decimalMap[metadata.id] {
                return ExerciseWrapper(metadata: metadata, executable: executable, blockId: blockId)
            }
            // Luego buscar en el mapa entero
            if let executable = executablesMap[Int(metadata.id)] {
                return ExerciseWrapper(metadata: metadata, executable: executable, blockId: blockId)
            }
            return nil
        }
    }

    /// Obtiene ejercicios de un bloque específico
    func getExercises(forBlock blockId: String) -> [ExerciseWrapper] {
        switch blockId {
        case "intro1":
            return loadBlockExercises(
                blockId: "intro1",
                executablesMap: [
                    1: IntroI_Exercise01(), 2: IntroI_Exercise02(), 3: IntroI_Exercise03(), 4: IntroI_Exercise04(),
                    6: IntroI_Exercise06(), 7: IntroI_Exercise07(), 8: IntroI_Exercise08(),
                    9: IntroI_Exercise09(), 10: IntroI_Exercise10(), 11: IntroI_Exercise11(), 12: IntroI_Exercise12(),
                    13: IntroI_Exercise13(), 14: IntroI_Exercise14(), 15: IntroI_Exercise15(), 16: IntroI_Exercise16(),
                    17: IntroI_Exercise17(), 18: IntroI_Exercise18(), 19: IntroI_Exercise19(), 20: IntroI_Exercise20()
                ],
                decimalMap: [
                    5.1: IntroI_Exercise05(), 5.2: IntroI_Exercise05_2()
                ]
            )
        case "intro2":
            return loadBlockExercises(blockId: "intro2", executablesMap: [
                1: IntroII_Exercise01(), 2: IntroII_Exercise02(), 3: IntroII_Exercise03(), 4: IntroII_Exercise04(),
                5: IntroII_Exercise05(), 6: IntroII_Exercise06(), 7: IntroII_Exercise07(), 8: IntroII_Exercise08(),
                9: IntroII_Exercise09(), 10: IntroII_Exercise10(), 11: IntroII_Exercise11(), 12: IntroII_Exercise12(),
                13: IntroII_Exercise13(), 14: IntroII_Exercise14(), 15: IntroII_Exercise15(), 16: IntroII_Exercise16(),
                17: IntroII_Exercise17(), 18: IntroII_Exercise18(), 19: IntroII_Exercise19(), 20: IntroII_Exercise20()
            ])
        case "algoritmia":
            return loadBlockExercises(blockId: "algoritmia", executablesMap: [
                1: Exercise01(), 2: Exercise02(), 3: Exercise03(), 4: Exercise04(), 5: Exercise05(),
                6: Exercise06(), 7: Exercise07(), 8: Exercise08(), 9: Exercise09(), 10: Exercise10(),
                11: Exercise11(), 12: Exercise12(), 13: Exercise13(), 14: Exercise14(), 15: Exercise15(),
                16: Exercise16(), 17: Exercise17(), 18: Exercise18(), 19: Exercise19(), 20: Exercise20(),
                21: Exercise21(), 22: Exercise22(), 23: Exercise23(), 24: Exercise24(), 25: Exercise25(),
                26: Exercise26(), 27: Exercise27(), 28: Exercise28(), 29: Exercise29(), 30: Exercise30(),
                31: Exercise31(), 32: Exercise32(), 33: Exercise33(), 34: Exercise34(), 35: Exercise35(),
                36: Exercise36(), 37: Exercise37(), 38: Exercise38(), 39: Exercise39(), 40: Exercise40(),
                41: Exercise41(), 42: Exercise42(), 43: Exercise43(), 44: Exercise44(), 45: Exercise45()
            ])
        case "basicos":
            return loadBlockExercises(blockId: "basicos", executablesMap: [
                1: Basico_Exercise01(), 2: Basico_Exercise02(), 3: Basico_Exercise03(), 4: Basico_Exercise04(),
                5: Basico_Exercise05(), 6: Basico_Exercise06(), 7: Basico_Exercise07(), 8: Basico_Exercise08(),
                9: Basico_Exercise09(), 10: Basico_Exercise10(), 11: Basico_Exercise11(), 12: Basico_Exercise12(),
                13: Basico_Exercise13(), 14: Basico_Exercise14(), 15: Basico_Exercise15(), 16: Basico_Exercise16(),
                17: Basico_Exercise17(), 18: Basico_Exercise18(), 19: Basico_Exercise19(), 20: Basico_Exercise20(),
                21: Basico_Exercise21(), 22: Basico_Exercise22(), 23: Basico_Exercise23(), 24: Basico_Exercise24(),
                25: Basico_Exercise25(), 26: Basico_Exercise26(), 27: Basico_Exercise27(), 28: Basico_Exercise28(),
                29: Basico_Exercise29(), 30: Basico_Exercise30()
            ])
        case "repaso":
            return loadBlockExercises(blockId: "repaso", executablesMap: [
                1: Repaso_Exercise01(), 2: Repaso_Exercise02(), 3: Repaso_Exercise03(), 4: Repaso_Exercise04(),
                5: Repaso_Exercise05(), 6: Repaso_Exercise06(), 7: Repaso_Exercise07(), 8: Repaso_Exercise08(),
                9: Repaso_Exercise09(), 10: Repaso_Exercise10(), 11: Repaso_Exercise11(), 12: Repaso_Exercise12(),
                13: Repaso_Exercise13(), 14: Repaso_Exercise14(), 15: Repaso_Exercise15(), 16: Repaso_Exercise16(),
                17: Repaso_Exercise17(), 18: Repaso_Exercise18(), 19: Repaso_Exercise19(), 20: Repaso_Exercise20(),
                21: Repaso_Exercise21(), 22: Repaso_Exercise22(), 23: Repaso_Exercise23(), 24: Repaso_Exercise24(),
                25: Repaso_Exercise25(), 26: Repaso_Exercise26(), 27: Repaso_Exercise27(), 28: Repaso_Exercise28(),
                29: Repaso_Exercise29(), 30: Repaso_Exercise30(), 31: Repaso_Exercise31(), 32: Repaso_Exercise32(),
                33: Repaso_Exercise33(), 34: Repaso_Exercise34(), 35: Repaso_Exercise35()
            ])
        default:
            return []
        }
    }

    /// Obtiene un ejercicio por su ID
    /// - Parameter id: ID del ejercicio (1-45, puede ser decimal como 5.1)
    /// - Returns: El ejercicio correspondiente o nil si no existe
    func getExercise(byId id: Double) -> ExerciseWrapper? {
        getAllExercises().first { $0.id == id }
    }

    /// Filtra ejercicios por dificultad
    /// - Parameter difficulty: Nivel de dificultad
    /// - Returns: Array de ejercicios que coinciden con la dificultad
    func getExercises(byDifficulty difficulty: Difficulty) -> [ExerciseWrapper] {
        getAllExercises().filter { $0.difficulty == difficulty }
    }

    /// Filtra ejercicios por categoría
    /// - Parameter category: Categoría del ejercicio
    /// - Returns: Array de ejercicios que coinciden con la categoría
    func getExercises(byCategory category: Category) -> [ExerciseWrapper] {
        getAllExercises().filter { $0.category == category }
    }

    /// Busca ejercicios por título
    /// - Parameter query: Texto a buscar en el título
    /// - Returns: Array de ejercicios que contienen el texto en su título
    func searchExercises(query: String) -> [ExerciseWrapper] {
        guard !query.isEmpty else {
            return getAllExercises()
        }

        return getAllExercises().filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
    }

    /// Obtiene estadísticas de los ejercicios
    /// - Returns: Tupla con el total de ejercicios y conteo por dificultad
    func getStatistics() -> (total: Int, basic: Int, intermediate: Int, advanced: Int) {
        // Usar caché si existe
        if let cached = Self.cachedStats {
            return cached
        }

        let all = getAllExercises()
        let stats = (
            total: all.count,
            basic: all.filter { $0.difficulty == .basic }.count,
            intermediate: all.filter { $0.difficulty == .intermediate }.count,
            advanced: all.filter { $0.difficulty == .advanced }.count
        )

        // Guardar en caché
        Self.cachedStats = stats
        return stats
    }
}
