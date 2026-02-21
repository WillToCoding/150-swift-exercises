//
//  SearchExercisesView.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 21/02/26.
//

import SwiftUI

struct SearchExercisesView: View {
    @State private var viewModel = ExerciseListViewModel()
    @State private var hasSearched = false

    var body: some View {
        Group {
            if viewModel.searchText.isEmpty && !hasSearched {
                // Estado inicial: sugerencias de búsqueda
                SearchSuggestionsView(viewModel: viewModel, onSearch: { hasSearched = true })
            } else if viewModel.filteredExercises.isEmpty {
                // Sin resultados
                ContentUnavailableView.search(text: viewModel.searchText)
            } else {
                // Resultados de búsqueda
                List {
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
            }
        }
        .navigationTitle("Buscar")
        .searchable(text: $viewModel.searchText, prompt: "Buscar por título...")
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

// MARK: - Search Suggestions

struct SearchSuggestionsView: View {
    @Bindable var viewModel: ExerciseListViewModel
    var onSearch: () -> Void

    private let popularSearches = [
        "Fibonacci",
        "Factorial",
        "Palíndromo",
        "Ordenación",
        "Primo",
        "Array",
        "String",
        "Recursión"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Búsquedas populares
                VStack(alignment: .leading, spacing: 12) {
                    Text("Búsquedas populares")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    FlowLayout(spacing: 8) {
                        ForEach(popularSearches, id: \.self) { term in
                            Button {
                                viewModel.searchText = term
                                onSearch()
                            } label: {
                                Text(term)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(Capsule())
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Filtrar por dificultad
                VStack(alignment: .leading, spacing: 12) {
                    Text("Por dificultad")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Button {
                                viewModel.selectedDifficulty = difficulty
                                onSearch()
                            } label: {
                                VStack(spacing: 6) {
                                    Image(systemName: difficulty.icon)
                                        .font(.title2)
                                    Text(difficulty.displayName)
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(difficulty.color.opacity(0.15))
                                .foregroundStyle(difficulty.color)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                // Por categoría
                VStack(alignment: .leading, spacing: 12) {
                    Text("Por categoría")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Button {
                                viewModel.selectedCategory = category
                                onSearch()
                            } label: {
                                Text(category.displayName)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.secondary.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(in: proposal.width ?? 0, subviews: subviews, spacing: spacing)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(in: bounds.width, subviews: subviews, spacing: spacing)
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                       y: bounds.minY + result.positions[index].y),
                          proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var rowHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += rowHeight + spacing
                    rowHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                rowHeight = max(rowHeight, size.height)
                x += size.width + spacing
                self.size.width = max(self.size.width, x)
            }

            self.size.height = y + rowHeight
        }
    }
}

// MARK: - Difficulty Extension

extension Difficulty {
    var icon: String {
        switch self {
        case .basic: return "leaf.fill"
        case .intermediate: return "flame.fill"
        case .advanced: return "bolt.fill"
        }
    }
}

#Preview {
    NavigationStack {
        SearchExercisesView()
    }
}
