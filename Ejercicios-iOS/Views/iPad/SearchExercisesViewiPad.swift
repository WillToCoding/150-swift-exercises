//
//  SearchExercisesViewiPad.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 21/02/26.
//

import SwiftUI

struct SearchExercisesViewiPad: View {
    @State private var viewModel = ExerciseListViewModel()
    @State private var hasSearched = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.searchText.isEmpty && !hasSearched {
                    SearchSuggestionsViewiPad(viewModel: viewModel, onSearch: { hasSearched = true })
                } else if viewModel.filteredExercises.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
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
                }
            }
            .navigationTitle("Buscar")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .navigationDestination(for: String.self) { exerciseId in
                if let exercise = viewModel.filteredExercises.first(where: { $0.uniqueId == exerciseId }) {
                    ExerciseDetailView(exercise: exercise)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Buscar por título...")
            .toolbar {
                if hasSearched {
                    ToolbarItem(placement: .automatic) {
                        FilterMenu(viewModel: viewModel)
                    }
                }
            }
            .onChange(of: viewModel.searchText) { _, newValue in
                if !newValue.isEmpty {
                    hasSearched = true
                }
            }
            .onAppear {
                viewModel.loadExercises(forBlock: nil)
            }
        }
    }

    private var groupedExercises: [(String, [ExerciseWrapper])] {
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

// MARK: - Search Suggestions for iPad

struct SearchSuggestionsViewiPad: View {
    @Bindable var viewModel: ExerciseListViewModel
    var onSearch: () -> Void

    private let popularSearches = [
        "Fibonacci", "Factorial", "Palíndromo", "Ordenación",
        "Primo", "Array", "String", "Recursión"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                // Búsquedas populares
                VStack(alignment: .leading, spacing: 16) {
                    Text("Búsquedas populares")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    FlowLayout(spacing: 10) {
                        ForEach(popularSearches, id: \.self) { term in
                            Button {
                                viewModel.searchText = term
                                onSearch()
                            } label: {
                                Text(term)
                                    .font(.body)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 10)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Por dificultad
                VStack(alignment: .leading, spacing: 16) {
                    Text("Por dificultad")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 16) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Button {
                                viewModel.selectedDifficulty = difficulty
                                onSearch()
                            } label: {
                                VStack(spacing: 10) {
                                    Image(systemName: difficulty.icon)
                                        .font(.largeTitle)
                                    Text(difficulty.displayName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 24)
                                .background(difficulty.color.opacity(0.15))
                                .foregroundStyle(difficulty.color)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Por categoría
                VStack(alignment: .leading, spacing: 16) {
                    Text("Por categoría")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))], spacing: 12) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Button {
                                viewModel.selectedCategory = category
                                onSearch()
                            } label: {
                                Text(category.displayName)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .safeAreaPadding()
        }
    }
}

#Preview {
    SearchExercisesViewiPad()
}
