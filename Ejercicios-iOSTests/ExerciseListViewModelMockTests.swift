//
//  ExerciseListViewModelMockTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests unitarios para ExerciseListViewModel con Mock.
//  Validan la carga y filtros con datos controlados.
//

import Testing
@testable import Ejercicios_iOS

@MainActor
@Suite("ExerciseListViewModel Tests con Mock")
struct ExerciseListViewModelMockTests {
    let repository: ExerciseRepositoryProtocol
    let vm: ExerciseListViewModel

    init() {
        repository = ExerciseRepositoryTest()
        vm = ExerciseListViewModel(repository: repository)
    }

    @Test("Cargar ejercicios desde mock")
    func testLoadFromMock() async throws {
        vm.loadExercises()

        #expect(vm.exercises.count == 1, "Mock tiene 1 ejercicio de prueba")
        #expect(vm.exercises.first?.title == "Suma de Array")
    }

    @Test("Estadísticas desde mock")
    func testStatsFromMock() async throws {
        vm.loadExercises()

        let stats = vm.getStatistics()

        #expect(stats.total == 1)
        #expect(stats.basic == 1)
        #expect(stats.intermediate == 0)
        #expect(stats.advanced == 0)
    }
}
