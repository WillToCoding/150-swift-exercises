//
//  AllExercisesListView.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 22/12/25.
//

import SwiftUI

struct AllExercisesListView: View {
    let initialDifficulty: Difficulty?
    @State private var viewModel = ExerciseListViewModel()

    private var navigationTitle: String {
        if let difficulty = viewModel.selectedDifficulty {
            return "Ejercicios \(difficulty.displayName)s"
        }
        return "Todos los Ejercicios"
    }

    var body: some View {
        List {
            // Estadísticas
            if !viewModel.exercises.isEmpty {
                StatisticsSection(viewModel: viewModel)
            }

            // Lista de ejercicios
            ForEach(viewModel.filteredExercises, id: \.uniqueId) { exercise in
                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    ExerciseCard(exercise: exercise)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(navigationTitle)
        .searchable(text: $viewModel.searchText, prompt: "Buscar ejercicios...")
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                FilterMenu(viewModel: viewModel)
            }
            #else
            ToolbarItem(placement: .automatic) {
                FilterMenu(viewModel: viewModel)
            }
            #endif
        }
        .onAppear {
            viewModel.loadExercises(forBlock: nil)
            if let difficulty = initialDifficulty {
                viewModel.selectedDifficulty = difficulty
            }
        }
    }
}

#Preview {
    NavigationStack {
        AllExercisesListView(initialDifficulty: .basic)
    }
}
