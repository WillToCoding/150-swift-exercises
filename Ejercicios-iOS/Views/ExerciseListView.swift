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

// MARK: - Statistics Section

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

struct StatItem: View {
    let title: String
    let value: Int
    let color: Color
    var isSelected: Bool = false
    var onTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .background(isSelected ? color.opacity(0.15) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture {
            onTap?()
        }
    }
}

// MARK: - Filter Menu

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

#Preview {
    NavigationStack {
        ExerciseListView(block: ExerciseBlock.allBlocks[0])
    }
}
