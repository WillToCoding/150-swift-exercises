//
//  RepositoryTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests unitarios para ExerciseRepository.
//  Validan que cada bloque de ejercicios se carga correctamente desde JSON.
//
//  Given-When-Then:
//  - Given: Repository inicializado
//  - When: getExercises(forBlock:) o getAllExercises()
//  - Then: Se cargan el número correcto de ejercicios con metadata válida
//

import Foundation
import Testing
@testable import Ejercicios_iOS

@MainActor
@Suite("ExerciseRepository Tests")
struct RepositoryTests {

    // MARK: - Carga por Bloque

    /// Given: Repository inicializado
    /// When: getExercises(forBlock: "intro1")
    /// Then: Se cargan 21 ejercicios (1-20 + 5.1, 5.2)
    @Test("Cargar bloque Introducción I")
    func testLoadIntro1() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getExercises(forBlock: "intro1")

        #expect(exercises.count == 21, "Intro1 debería tener 21 ejercicios (incluye 5.1 y 5.2), tiene \(exercises.count)")
        #expect(exercises.allSatisfy { $0.blockId == "intro1" }, "Todos deberían pertenecer al bloque intro1")
    }

    /// Given: Repository inicializado
    /// When: getExercises(forBlock: "intro2")
    /// Then: Se cargan 20 ejercicios
    @Test("Cargar bloque Introducción II")
    func testLoadIntro2() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getExercises(forBlock: "intro2")

        #expect(exercises.count == 20, "Intro2 debería tener 20 ejercicios, tiene \(exercises.count)")
        #expect(exercises.allSatisfy { $0.blockId == "intro2" }, "Todos deberían pertenecer al bloque intro2")
    }

    /// Given: Repository inicializado
    /// When: getExercises(forBlock: "algoritmia")
    /// Then: Se cargan 45 ejercicios
    @Test("Cargar bloque Algoritmia")
    func testLoadAlgoritmia() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getExercises(forBlock: "algoritmia")

        #expect(exercises.count == 45, "Algoritmia debería tener 45 ejercicios, tiene \(exercises.count)")
        #expect(exercises.allSatisfy { $0.blockId == "algoritmia" }, "Todos deberían pertenecer al bloque algoritmia")
    }

    /// Given: Repository inicializado
    /// When: getExercises(forBlock: "basicos")
    /// Then: Se cargan 30 ejercicios
    @Test("Cargar bloque Básicos")
    func testLoadBasicos() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getExercises(forBlock: "basicos")

        #expect(exercises.count == 30, "Básicos debería tener 30 ejercicios, tiene \(exercises.count)")
        #expect(exercises.allSatisfy { $0.blockId == "basicos" }, "Todos deberían pertenecer al bloque basicos")
    }

    /// Given: Repository inicializado
    /// When: getExercises(forBlock: "repaso")
    /// Then: Se cargan 35 ejercicios
    @Test("Cargar bloque Repaso")
    func testLoadRepaso() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getExercises(forBlock: "repaso")

        #expect(exercises.count == 35, "Repaso debería tener 35 ejercicios, tiene \(exercises.count)")
        #expect(exercises.allSatisfy { $0.blockId == "repaso" }, "Todos deberían pertenecer al bloque repaso")
    }

    // MARK: - Carga Total

    /// Given: Repository inicializado
    /// When: getAllExercises()
    /// Then: Se cargan 150 ejercicios en total
    @Test("Cargar todos los ejercicios")
    func testLoadAllExercises() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getAllExercises()

        #expect(exercises.count == 151, "Deberían cargarse 151 ejercicios, se cargaron \(exercises.count)")
    }

    // MARK: - Estadísticas

    /// Given: Repository inicializado
    /// When: getStatistics()
    /// Then: Las estadísticas son correctas
    @Test("Estadísticas de dificultad")
    func testStatistics() async throws {
        let repository = ExerciseRepository()

        let stats = repository.getStatistics()

        #expect(stats.total == 151, "Total debería ser 151, es \(stats.total)")
        #expect(stats.basic == 75, "Básicos deberían ser 75, son \(stats.basic)")
        #expect(stats.intermediate == 57, "Intermedios deberían ser 57, son \(stats.intermediate)")
        #expect(stats.advanced == 19, "Avanzados deberían ser 19, son \(stats.advanced)")
    }

    // MARK: - Búsqueda y Filtros del Repository

    /// Given: Repository con ejercicios
    /// When: getExercise(byId: 1)
    /// Then: Devuelve el ejercicio con id 1
    @Test("Buscar ejercicio por ID")
    func testGetExerciseById() async throws {
        let repository = ExerciseRepository()

        let exercise = repository.getExercise(byId: 1)

        #expect(exercise != nil, "Debería encontrar el ejercicio con id 1")
        #expect(exercise?.id == 1, "El id debería ser 1")
    }

    /// Given: Repository con ejercicios
    /// When: getExercises(byDifficulty: .advanced)
    /// Then: Devuelve solo ejercicios avanzados
    @Test("Filtrar por dificultad avanzada")
    func testFilterByDifficulty() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.getExercises(byDifficulty: .advanced)

        #expect(exercises.count == 19, "Deberían ser 19 ejercicios avanzados, son \(exercises.count)")
        #expect(exercises.allSatisfy { $0.difficulty == .advanced }, "Todos deberían ser avanzados")
    }

    /// Given: Repository con ejercicios
    /// When: searchExercises(query: "suma")
    /// Then: Devuelve ejercicios que contienen "suma" en el título
    @Test("Buscar ejercicios por texto")
    func testSearchExercises() async throws {
        let repository = ExerciseRepository()

        let exercises = repository.searchExercises(query: "suma")

        #expect(exercises.count > 0, "Debería encontrar ejercicios con 'suma'")
        #expect(exercises.allSatisfy { $0.title.localizedCaseInsensitiveContains("suma") }, "Todos deberían contener 'suma'")
    }

    // MARK: - Validación de Metadata

    /// Given: Repository con ejercicios cargados
    /// When: Verificamos la metadata del primer ejercicio
    /// Then: Los campos no están vacíos y tienen valores válidos
    @Test("Validar metadata de ejercicios")
    func testExerciseMetadataIsValid() async throws {
        let repository = ExerciseRepository()
        let exercises = repository.getAllExercises()

        for exercise in exercises {
            #expect(!exercise.title.isEmpty, "El título no debería estar vacío (ejercicio id: \(exercise.id))")
            #expect(!exercise.description.isEmpty, "La descripción no debería estar vacía (ejercicio id: \(exercise.id))")
            #expect(!exercise.blockId.isEmpty, "El blockId no debería estar vacío (ejercicio id: \(exercise.id))")
        }
    }
}
