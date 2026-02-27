
//
//  ExerciseListView.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import SwiftUI

struct ExerciseListView: View {
    let block: ExerciseBlock
    @State private var viewModel = ExerciseListViewModel()

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
                    ExerciseCard(exercise: exercise, showBlock: false)
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(block.name)
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
            viewModel.loadExercises(forBlock: block.id)
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseListView(block: ExerciseBlock.allBlocks[0])
    }
}
