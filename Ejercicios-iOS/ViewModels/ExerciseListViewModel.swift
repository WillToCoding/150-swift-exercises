//
//  ExerciseListViewModel.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation
import Observation

@Observable
@MainActor
final class ExerciseListViewModel {

    // MARK: - Properties

    var exercises: [ExerciseWrapper] = []
    var filteredExercises: [ExerciseWrapper] = []
    var searchText: String = "" {
        didSet {
            filterExercises()
        }
    }
    var selectedDifficulty: Difficulty? = nil {
        didSet {
            filterExercises()
        }
    }
    var selectedCategory: Category? = nil {
        didSet {
            filterExercises()
        }
    }

    private let repository: ExerciseRepositoryProtocol
    private var blockId: String?

    // MARK: - Initialization

    init(repository: ExerciseRepositoryProtocol = ExerciseRepository()) {
        self.repository = repository
    }

    // MARK: - Methods

    func loadExercises(forBlock blockId: String? = nil) {
        self.blockId = blockId
        if let blockId = blockId {
            exercises = repository.getExercises(forBlock: blockId)
        } else {
            exercises = repository.getAllExercises()
        }
        filterExercises()
    }

    private func filterExercises() {
        var result = exercises

        // Filtrar por búsqueda
        if !searchText.isEmpty {
            result = result.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }

        // Filtrar por dificultad
        if let difficulty = selectedDifficulty {
            result = result.filter { $0.difficulty == difficulty }
        }

        // Filtrar por categoría
        if let category = selectedCategory {
            result = result.filter { $0.category == category }
        }

        filteredExercises = result
    }

    func clearFilters() {
        searchText = ""
        selectedDifficulty = nil
        selectedCategory = nil
    }

    func getStatistics() -> (total: Int, basic: Int, intermediate: Int, advanced: Int) {
        (
            total: exercises.count,
            basic: exercises.filter { $0.difficulty == .basic }.count,
            intermediate: exercises.filter { $0.difficulty == .intermediate }.count,
            advanced: exercises.filter { $0.difficulty == .advanced }.count
        )
    }
}
