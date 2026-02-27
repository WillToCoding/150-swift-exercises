//
//  StatsViewModelTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests de integración para StatsViewModel.
//  Validan la carga de estadísticas con datos reales.
//

import Testing
@testable import Ejercicios_iOS

@MainActor
@Suite("StatsViewModel Integration Tests")
struct StatsViewModelTests {

    /// Given: ViewModel recién creado
    /// When: loadStats()
    /// Then: Se cargan las estadísticas reales
    @Test("Cargar stats reales")
    func testLoadRealStats() async throws {
        let vm = StatsViewModel()

        vm.loadStats()

        #expect(vm.state == .loaded)
        #expect(vm.stats.total == 151)
        #expect(vm.stats.basic == 75)
        #expect(vm.stats.intermediate == 57)
        #expect(vm.stats.advanced == 19)
    }

    /// Given: ViewModel recién creado
    /// When: Verificamos ViewState helpers
    /// Then: isLoading y errorMessage funcionan correctamente
    @Test("ViewState helpers")
    func testViewStateHelpers() async throws {
        let vm = StatsViewModel()

        #expect(vm.state.isLoading == true)
        #expect(vm.state.errorMessage == nil)

        vm.loadStats()

        #expect(vm.state.isLoading == false)
    }
}
