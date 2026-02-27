//
//  BlockSelectionViewiPad.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 21/02/26.
//

import SwiftUI

struct BlockSelectionViewiPad: View {
    private let blocks = ExerciseBlock.allBlocks
    @State private var selectedBlock: ExerciseBlock?
    @State private var viewModel = ExerciseListViewModel()

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedBlock) {
                ForEach(blocks) { block in
                    BlockRowiPad(block: block)
                        .tag(block)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Bloques")
        } detail: {
            if let selectedBlock {
                ExerciseListContentiPad(block: selectedBlock, viewModel: viewModel)
            } else {
                ContentUnavailableView(
                    "Selecciona un Bloque",
                    systemImage: "square.grid.2x2",
                    description: Text("Elige un bloque del menú lateral para ver sus ejercicios")
                )
            }
        }
        .onChange(of: selectedBlock) { _, newBlock in
            if let block = newBlock {
                viewModel.loadExercises(forBlock: block.id)
            }
        }
    }
}

// MARK: - Block Row for iPad

struct BlockRowiPad: View {
    let block: ExerciseBlock

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: block.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(block.color)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(block.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))

                Text("\(block.exerciseCount) ejercicios")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if block.progress >= 1.0 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Exercise List Content for iPad

struct ExerciseListContentiPad: View {
    let block: ExerciseBlock
    @Bindable var viewModel: ExerciseListViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.filteredExercises, id: \.uniqueId) { exercise in
                        NavigationLink(value: exercise.uniqueId) {
                            ExerciseRowiPad(exercise: exercise)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .safeAreaPadding()
            .navigationTitle(block.name)
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
        }
        .onAppear {
            viewModel.loadExercises(forBlock: block.id)
        }
    }
}

// MARK: - Exercise Row for iPad

struct ExerciseRowiPad: View {
    let exercise: ExerciseWrapper

    var body: some View {
        HStack(spacing: 12) {
            Text("#\(exercise.id.formattedId)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 45, alignment: .leading)

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    Text(exercise.difficulty.displayName)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(exercise.difficulty.color))

                    Text(exercise.category.displayName)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - ExerciseBlock Hashable Conformance

extension ExerciseBlock: Hashable {
    static func == (lhs: ExerciseBlock, rhs: ExerciseBlock) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#Preview {
    BlockSelectionViewiPad()
}
