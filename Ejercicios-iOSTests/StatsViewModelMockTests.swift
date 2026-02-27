//
//  StatsViewModelMockTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests unitarios para StatsViewModel con Mock.
//  Validan la carga de estadísticas con datos controlados.
//

import Testing
@testable import Ejercicios_iOS

@MainActor
@Suite("StatsViewModel Tests con Mock")
struct StatsViewModelMockTests {
    let vm: StatsViewModel

    init() {
        vm = StatsViewModel(repository: ExerciseRepositoryTest())
    }

    /// Given: ViewModel recién creado con mock
    /// When: Verificamos estado inicial
    /// Then: Estado es loading y stats vacías
    @Test("Estado inicial es loading")
    func testInitialState() async throws {
        #expect(vm.state == .loading)
        #expect(vm.stats.total == 0)
    }

    /// Given: ViewModel con mock
    /// When: loadStats()
    /// Then: Se cargan las estadísticas del mock (1 ejercicio básico)
    @Test("Cargar stats desde mock")
    func testLoadStats() async throws {
        vm.loadStats()

        #expect(vm.state == .loaded)
        #expect(vm.stats.total == 1)
        #expect(vm.stats.basic == 1)
        #expect(vm.stats.intermediate == 0)
        #expect(vm.stats.advanced == 0)
    }
}
