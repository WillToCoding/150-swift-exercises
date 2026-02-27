//
//  StatsViewModel.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 23/2/26.
//
//  ViewModel compartido para estadísticas globales.
//  Se propaga via .environment() desde la App.
//  Similar al patrón de EmpleadosAPI.
//

import Foundation
import Observation

@Observable
@MainActor
final class StatsViewModel {

    // MARK: - Properties

    private(set) var stats: (total: Int, basic: Int, intermediate: Int, advanced: Int) = (0, 0, 0, 0)
    private(set) var state: ViewState = .loading

    private let repository: ExerciseRepositoryProtocol

    // MARK: - Initialization

    init(repository: ExerciseRepositoryProtocol = ExerciseRepository()) {
        self.repository = repository
    }

    // MARK: - Methods

    func loadStats() {
        state = .loading
        stats = repository.getStatistics()
        state = .loaded
    }
}
