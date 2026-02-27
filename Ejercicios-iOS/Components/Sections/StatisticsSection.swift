//
//  StatisticsSection.swift
//  Ejercicios-iOS
//
//  Extraído de ExerciseListView.swift
//

import SwiftUI

struct StatisticsSection: View {
    @Bindable var viewModel: ExerciseListViewModel

    var body: some View {
        let stats = viewModel.getStatistics()

        Section {
            HStack(spacing: 20) {
                StatItem(title: "Total", value: stats.total, color: .blue, isSelected: viewModel.selectedDifficulty == nil) {
                    viewModel.selectedDifficulty = nil
                }
                StatItem(title: "Básico", value: stats.basic, color: .green, isSelected: viewModel.selectedDifficulty == .basic) {
                    viewModel.selectedDifficulty = .basic
                }
                StatItem(title: "Intermedio", value: stats.intermediate, color: .orange, isSelected: viewModel.selectedDifficulty == .intermediate) {
                    viewModel.selectedDifficulty = .intermediate
                }
                StatItem(title: "Avanzado", value: stats.advanced, color: .red, isSelected: viewModel.selectedDifficulty == .advanced) {
                    viewModel.selectedDifficulty = .advanced
                }
            }
            .padding(.vertical, 8)
        }
    }
}
