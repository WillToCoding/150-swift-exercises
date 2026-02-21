//
//  ExerciseDetailView.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import SwiftUI

// MARK: - Cross-Platform Color Helper

extension Color {
    static var secondarySystemGroupedBackground: Color {
        #if os(iOS)
        Color(uiColor: .secondarySystemGroupedBackground)
        #else
        Color(nsColor: .controlBackgroundColor)
        #endif
    }
}

// MARK: - Exercise Detail View

struct ExerciseDetailView: View {
    @State private var viewModel: ExerciseDetailViewModel

    init(exercise: any ExerciseProtocol) {
        _viewModel = State(initialValue: ExerciseDetailViewModel(exercise: exercise))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                ExerciseHeader(exercise: viewModel.exercise)

                // Descripción
                DescriptionSection(description: viewModel.exercise.description)

                // Input Section
                InputSection(
                    inputText: $viewModel.inputText,
                    inputType: viewModel.exercise.inputType,
                    onExecute: {
                        Task {
                            await viewModel.executeExercise()
                        }
                    },
                    isExecuting: viewModel.isExecuting
                )

                // Result Section (aparece justo después de ejecutar)
                if !viewModel.result.isEmpty {
                    ResultSection(result: viewModel.result)
                }

                // Error Section
                if let errorMessage = viewModel.errorMessage {
                    ErrorSection(message: errorMessage)
                }

                // Explicación del algoritmo (al final, expandible)
                if viewModel.exercise.explanation != nil || viewModel.exercise.diagramImage != nil {
                    ExplanationSection(
                        explanation: viewModel.exercise.explanation,
                        diagramImage: viewModel.exercise.diagramImage
                    )
                }

                Spacer()
            }
            .safeAreaPadding()
        }
        .navigationTitle("Ejercicio #\(viewModel.exercise.id.formattedId)")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.clearInput()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isExecuting)
            }
            #else
            ToolbarItem(placement: .automatic) {
                Button {
                    viewModel.clearInput()
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isExecuting)
            }
            #endif
        }
    }
}

#Preview {
    NavigationStack {
        ExerciseDetailView(exercise: ExerciseWrapper.test)
    }
}
