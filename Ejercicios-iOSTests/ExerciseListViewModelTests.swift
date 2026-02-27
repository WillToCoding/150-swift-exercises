//
//  ExerciseListViewModelTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests de integración para ExerciseListViewModel.
//  Validan la carga de ejercicios, filtros y búsqueda con datos reales.
//
//  Given-When-Then:
//  - Given: ViewModel sin ejercicios o con ejercicios cargados
//  - When: loadExercises(), filtrar, buscar o clearFilters()
//  - Then: Los ejercicios se cargan/filtran correctamente
//

import Testing
@testable import Ejercicios_iOS
import Foundation

@MainActor
@Suite("ExerciseListViewModel Integration Tests")
struct ExerciseListViewModelTests {

    // MARK: - Carga de Ejercicios

    /// Given: ViewModel sin ejercicios cargados
    /// When: loadExercises() sin filtro de bloque
    /// Then: Se cargan todos los 150 ejercicios
    @Test("Cargar todos los ejercicios")
    func testLoadAllExercises() async throws {
        let vm = ExerciseListViewModel()

        vm.loadExercises()

        #expect(vm.exercises.count == 151, "Deberían cargarse 151 ejercicios, pero se cargaron \(vm.exercises.count)")
        #expect(vm.filteredExercises.count == 151, "Sin filtros, filteredExercises debería tener 151")
    }

    /// Given: ViewModel sin ejercicios cargados
    /// When: loadExercises(forBlock: "algoritmia")
    /// Then: Se cargan 45 ejercicios del bloque Algoritmia
    @Test("Cargar ejercicios de Algoritmia")
    func testLoadAlgoritmiaExercises() async throws {
        let vm = ExerciseListViewModel()

        vm.loadExercises(forBlock: "algoritmia")

        #expect(vm.exercises.count == 45, "Algoritmia debería tener 45 ejercicios, pero tiene \(vm.exercises.count)")
    }

    /// Given: ViewModel sin ejercicios cargados
    /// When: loadExercises(forBlock: "intro1")
    /// Then: Se cargan 21 ejercicios (20 + ejercicio 5.1 y 5.2)
    @Test("Cargar ejercicios de Introducción I")
    func testLoadIntro1Exercises() async throws {
        let vm = ExerciseListViewModel()

        vm.loadExercises(forBlock: "intro1")

        // intro1 tiene ejercicios 1-20 + 5.1 y 5.2 = 21
        #expect(vm.exercises.count == 21, "Intro1 debería tener 21 ejercicios, pero tiene \(vm.exercises.count)")
    }

    // MARK: - Filtros

    /// Given: ViewModel con ejercicios cargados
    /// When: Filtrar por dificultad .advanced
    /// Then: Solo se muestran ejercicios avanzados
    @Test("Filtrar por dificultad avanzada")
    func testFilterByDifficultyAdvanced() async throws {
        let vm = ExerciseListViewModel()
        vm.loadExercises()

        vm.selectedDifficulty = .advanced

        #expect(vm.filteredExercises.count == 19, "Deberían haber 19 ejercicios avanzados, pero hay \(vm.filteredExercises.count)")
        #expect(vm.filteredExercises.allSatisfy { $0.difficulty == .advanced }, "Todos deberían ser avanzados")
    }

    /// Given: ViewModel con ejercicios cargados
    /// When: Filtrar por dificultad .basic
    /// Then: Solo se muestran ejercicios básicos
    @Test("Filtrar por dificultad básica")
    func testFilterByDifficultyBasic() async throws {
        let vm = ExerciseListViewModel()
        vm.loadExercises()

        vm.selectedDifficulty = .basic

        #expect(vm.filteredExercises.count == 75, "Deberían haber 75 ejercicios básicos, pero hay \(vm.filteredExercises.count)")
        #expect(vm.filteredExercises.allSatisfy { $0.difficulty == .basic }, "Todos deberían ser básicos")
    }

    /// Given: ViewModel con ejercicios cargados
    /// When: Filtrar por categoría .recursion
    /// Then: Solo se muestran ejercicios de recursión
    @Test("Filtrar por categoría recursión")
    func testFilterByCategory() async throws {
        let vm = ExerciseListViewModel()
        vm.loadExercises()

        vm.selectedCategory = .recursion

        #expect(vm.filteredExercises.count > 0, "Debería haber al menos un ejercicio de recursión")
        #expect(vm.filteredExercises.allSatisfy { $0.category == .recursion }, "Todos deberían ser de recursión")
    }

    /// Given: ViewModel con ejercicios cargados
    /// When: Buscar "Fibonacci"
    /// Then: Solo se muestran ejercicios con Fibonacci en el título
    @Test("Buscar por título")
    func testSearchByTitle() async throws {
        let vm = ExerciseListViewModel()
        vm.loadExercises()

        vm.searchText = "Fibonacci"

        #expect(vm.filteredExercises.count > 0, "Debería encontrar al menos un ejercicio de Fibonacci")
        #expect(vm.filteredExercises.allSatisfy { $0.title.localizedCaseInsensitiveContains("Fibonacci") }, "Todos deberían contener 'Fibonacci' en el título")
    }

    /// Given: ViewModel con filtros aplicados
    /// When: clearFilters()
    /// Then: Se muestran todos los ejercicios
    @Test("Limpiar filtros")
    func testClearFilters() async throws {
        let vm = ExerciseListViewModel()
        vm.loadExercises()
        vm.selectedDifficulty = .advanced
        vm.searchText = "algo"
        let countBeforeClear = vm.filteredExercises.count

        vm.clearFilters()

        #expect(vm.searchText.isEmpty, "searchText debería estar vacío")
        #expect(vm.selectedDifficulty == nil, "selectedDifficulty debería ser nil")
        #expect(vm.filteredExercises.count == vm.exercises.count, "Después de limpiar filtros, deberían mostrarse todos los ejercicios")
        #expect(vm.filteredExercises.count > countBeforeClear, "Deberían mostrarse más ejercicios después de limpiar")
    }

    // MARK: - Estadísticas

    /// Given: ViewModel con ejercicios cargados
    /// When: getStatistics()
    /// Then: Devuelve conteo correcto por dificultad
    @Test("Obtener estadísticas")
    func testGetStatistics() async throws {
        let vm = ExerciseListViewModel()
        vm.loadExercises()

        let stats = vm.getStatistics()

        #expect(stats.total == 151, "Total debería ser 151")
        #expect(stats.basic == 75, "Básicos deberían ser 75")
        #expect(stats.intermediate == 57, "Intermedios deberían ser 57")
        #expect(stats.advanced == 19, "Avanzados deberían ser 19")
        #expect(stats.basic + stats.intermediate + stats.advanced == stats.total, "La suma de dificultades debe igualar el total")
    }
}
