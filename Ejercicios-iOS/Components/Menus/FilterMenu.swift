//
//  FilterMenu.swift
//  Ejercicios-iOS
//
//  Extraído de ExerciseListView.swift
//

import SwiftUI

struct FilterMenu: View {
    @Bindable var viewModel: ExerciseListViewModel

    var body: some View {
        Menu {
            Section("Dificultad") {
                Button(action: { viewModel.selectedDifficulty = nil }) {
                    Label("Todas", systemImage: viewModel.selectedDifficulty == nil ? "checkmark" : "")
                }
                ForEach(Difficulty.allCases, id: \.self) { difficulty in
                    Button(action: { viewModel.selectedDifficulty = difficulty }) {
                        Label(difficulty.displayName, systemImage: viewModel.selectedDifficulty == difficulty ? "checkmark" : "")
                    }
                }
            }

            Section("Categoría") {
                Button(action: { viewModel.selectedCategory = nil }) {
                    Label("Todas", systemImage: viewModel.selectedCategory == nil ? "checkmark" : "")
                }
                ForEach(Category.allCases, id: \.self) { category in
                    Button(action: { viewModel.selectedCategory = category }) {
                        Label(category.displayName, systemImage: viewModel.selectedCategory == category ? "checkmark" : "")
                    }
                }
            }

            if viewModel.selectedDifficulty != nil || viewModel.selectedCategory != nil {
                Section {
                    Button(role: .destructive, action: { viewModel.clearFilters() }) {
                        Label("Limpiar filtros", systemImage: "xmark.circle")
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
        }
    }
}
