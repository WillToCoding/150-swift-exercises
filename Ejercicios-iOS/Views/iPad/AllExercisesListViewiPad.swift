//
//  AllExercisesListViewiPad.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 21/02/26.
//

import SwiftUI

struct AllExercisesListViewiPad: View {
    @State private var viewModel = ExerciseListViewModel()

    private var navigationTitle: String {
        if let difficulty = viewModel.selectedDifficulty {
            return "Ejercicios \(difficulty.displayName)s"
        }
        return "Todos los Ejercicios"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    // Estadísticas
                    if !viewModel.exercises.isEmpty {
                        StatisticsSection(viewModel: viewModel)
                            .padding(.bottom, 8)
                    }

                    // Ejercicios agrupados por bloque
                    ForEach(groupedExercises, id: \.0) { blockId, exercises in
                        Section {
                            ForEach(exercises, id: \.uniqueId) { exercise in
                                NavigationLink(value: exercise.uniqueId) {
                                    ExerciseRowiPad(exercise: exercise)
                                }
                                .buttonStyle(.plain)
                            }
                        } header: {
                            Text(blockName(for: blockId))
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 16)
                        }
                    }
                }
            }
            .safeAreaPadding()
            .navigationTitle(navigationTitle)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationDestination(for: String.self) { exerciseId in
                if let exercise = viewModel.filteredExercises.first(where: { $0.uniqueId == exerciseId }) {
                    ExerciseDetailView(exercise: exercise)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Buscar ejercicios...")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    FilterMenu(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.loadExercises(forBlock: nil)
            }
        }
    }

    private var groupedExercises: [(String, [any ExerciseProtocol])] {
        let grouped = Dictionary(grouping: viewModel.filteredExercises) { $0.blockId }
        let orderedBlockIds = ["intro1", "intro2", "basicos", "repaso", "algoritmia"]

        return orderedBlockIds.compactMap { blockId in
            guard let exercises = grouped[blockId], !exercises.isEmpty else { return nil }
            return (blockId, exercises)
        }
    }

    private func blockName(for blockId: String) -> String {
        ExerciseBlock.allBlocks.first { $0.id == blockId }?.name ?? blockId
    }
}

#Preview {
    AllExercisesListViewiPad()
}
