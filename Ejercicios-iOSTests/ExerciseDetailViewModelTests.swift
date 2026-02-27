//
//  ExerciseDetailViewModelTests.swift
//  Ejercicios-iOSTests
//
//  Created by Juan Carlos on 23/2/26.
//
//  Tests unitarios para ExerciseDetailViewModel.
//  Validan la ejecución de ejercicios y manejo de errores.
//
//  Given-When-Then:
//  - Given: ViewModel con ejercicio cargado
//  - When: executeExercise() o clearInput()
//  - Then: El resultado o error esperado
//

import Testing
@testable import Ejercicios_iOS

@MainActor
@Suite("ExerciseDetailViewModel Tests")
struct ExerciseDetailViewModelTests {

    /// Given: ViewModel con ejercicio de suma de array
    /// When: executeExercise() con input "2, 3"
    /// Then: El resultado contiene la suma
    @Test("Ejecutar ejercicio de suma de array")
    func testExecuteExercise() async throws {
        let exercise = ExerciseWrapper.test // Ejercicio de suma de array
        let vm = ExerciseDetailViewModel(exercise: exercise)
        vm.inputText = "2, 3"

        await vm.executeExercise()

        #expect(vm.result.contains("Suma: 5"), "La suma de [2, 3] debería ser 5, pero el resultado es '\(vm.result)'")
        #expect(vm.errorMessage == nil, "No debería haber error")
    }

    /// Given: ViewModel con ejercicio que requiere input
    /// When: executeExercise() con input vacío
    /// Then: Se muestra mensaje de error
    @Test("Error con input vacío")
    func testEmptyInputError() async throws {
        let exercise = ExerciseWrapper.test
        let vm = ExerciseDetailViewModel(exercise: exercise)
        vm.inputText = ""

        await vm.executeExercise()

        #expect(vm.errorMessage != nil, "Debería mostrar error con input vacío")
        #expect(vm.result.isEmpty, "El resultado debería estar vacío")
    }

    /// Given: ViewModel con input y resultado
    /// When: clearInput()
    /// Then: Se limpia todo
    @Test("Limpiar input")
    func testClearInput() async throws {
        let exercise = ExerciseWrapper.test
        let vm = ExerciseDetailViewModel(exercise: exercise)
        vm.inputText = "5, 3"
        await vm.executeExercise()

        vm.clearInput()

        #expect(vm.inputText.isEmpty, "inputText debería estar vacío")
        #expect(vm.result.isEmpty, "result debería estar vacío")
        #expect(vm.errorMessage == nil, "errorMessage debería ser nil")
    }

    /// Given: ViewModel ejecutando
    /// When: Se inicia executeExercise()
    /// Then: isExecuting cambia a true durante la ejecución
    @Test("Estado de ejecución")
    func testExecutingState() async throws {
        let exercise = ExerciseWrapper.test
        let vm = ExerciseDetailViewModel(exercise: exercise)
        vm.inputText = "1, 1"

        // Antes de ejecutar
        #expect(vm.isExecuting == false, "No debería estar ejecutando antes")

        await vm.executeExercise()

        // Después de ejecutar
        #expect(vm.isExecuting == false, "No debería estar ejecutando después")
        #expect(!vm.result.isEmpty, "Debería tener resultado")
    }
}
