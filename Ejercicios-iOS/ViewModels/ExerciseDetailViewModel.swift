//
//  ExerciseDetailViewModel.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

@Observable @MainActor
final class ExerciseDetailViewModel {

    // MARK: - Properties

    let exercise: any ExerciseProtocol

    var inputText: String = ""
    var result: String = ""
    var isExecuting: Bool = false
    var errorMessage: String?

    // MARK: - Initialization

    init(exercise: any ExerciseProtocol) {
        self.exercise = exercise
    }

    // MARK: - Methods

    func executeExercise() async {
        // Solo validar input vacío si el ejercicio requiere entrada
        if exercise.inputType.requiresInput {
            guard !inputText.isEmpty else {
                errorMessage = "Por favor ingresa un valor"
                return
            }
        }

        // Capturar el valor antes del await para evitar data race
        let input = inputText
        
        isExecuting = true
        errorMessage = nil
        result = ""

        do {
            let output = try await exercise.execute(input: input)
            result = output
        } catch let error as ExerciseError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Error inesperado: \(error.localizedDescription)"
        }

        isExecuting = false
    }

    func clearInput() {
        inputText = ""
        result = ""
        errorMessage = nil
    }
}
