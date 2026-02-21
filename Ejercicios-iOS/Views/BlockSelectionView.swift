//
//  BlockSelectionView.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 19/12/25.
//

import SwiftUI

struct BlockSelectionView: View {
    private let blocks = ExerciseBlock.allBlocks
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo degradado oscuro profesional
                LinearGradient(
                    colors: [
                        Color(red: 0.08, green: 0.08, blue: 0.10),
                        Color(red: 0.12, green: 0.12, blue: 0.14)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header con logo
                        HeaderSection()

                        // Grid de bloques
                        LazyVGrid(columns: columns, spacing: 16) {
                            // Card de estadísticas globales (primera posición)
                            GlobalStatsCard()

                            ForEach(blocks) { block in
                                if block.isAvailable {
                                    NavigationLink {
                                        ExerciseListView(block: block)
                                    } label: {
                                        BlockCard(block: block)
                                    }
                                    .buttonStyle(CardButtonStyle())
                                } else {
                                    BlockCard(block: block)
                                }
                            }
                        }
                        .padding(.horizontal, 20)

                        // Footer con estadísticas
                        FooterSection()
                    }
                    .padding(.vertical, 20)
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }
}

// MARK: - Header Section

private struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 16) {
            // Logo WillToCoding
            Image("logoWhite")
                .resizable()
                .scaledToFit()
                .frame(height: 90)
                .accessibilityLabel("Logo WillToCoding")

            VStack(spacing: 8) {
                Text("Swift 6")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, Color(white: 0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                Text("150 Ejercicios de Programación")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(white: 0.6))
            }

            Text("Selecciona un bloque")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color(white: 0.5))
                .padding(.top, 8)
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

// MARK: - Block Card

struct BlockCard: View {
    let block: ExerciseBlock

    var body: some View {
        VStack(spacing: 12) {
            // Icono
            Image(systemName: block.icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white.opacity(0.9))

            // Nombre del bloque
            Text(block.name)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            // Subtítulo
            Text(block.subtitle)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))

            // Contador de ejercicios
            HStack(spacing: 4) {
                Text("\(block.exerciseCount)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                Text("ejercicios")
                    .font(.system(size: 12, weight: .regular, design: .rounded))
            }
            .foregroundStyle(.white.opacity(0.75))

            // Barra de progreso (solo si hay progreso)
            if block.progress > 0 {
                ProgressView(value: block.progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white.opacity(0.9)))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
            }

            // Badge de estado
            if !block.isAvailable {
                Text("Próximamente")
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.15))
                    .clipShape(Capsule())
                    .padding(.top, 2)
            } else if block.progress >= 1.0 {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                    Text("Completado")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
                .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: block.isAvailable
                            ? [block.color, block.color.opacity(0.8)]
                            : [block.color.opacity(0.5), block.color.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: block.color.opacity(block.isAvailable ? 0.4 : 0.2), radius: 12, x: 0, y: 6)
        )
        .opacity(block.isAvailable ? 1.0 : 0.7)
    }
}

// MARK: - Global Stats Card

private struct GlobalStatsCard: View {
    private let repository = ExerciseRepository()

    private var stats: (total: Int, basic: Int, intermediate: Int, advanced: Int) {
        repository.getStatistics()
    }

    var body: some View {
        NavigationLink {
            AllExercisesListView(initialDifficulty: nil)
        } label: {
            VStack(spacing: 12) {
                // Icono (igual que BlockCard)
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))

                // Título (igual que BlockCard.name)
                Text("Por Dificultad")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                // Subtítulo (igual que BlockCard.subtitle)
                Text("Todos los bloques")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))

                // Contador (igual que BlockCard) - Stats en vez de número
                HStack(spacing: 6) {
                    StatBadge(value: stats.basic, color: .green)
                    StatBadge(value: stats.intermediate, color: .orange)
                    StatBadge(value: stats.advanced, color: .red)
                }
                .foregroundStyle(.white.opacity(0.75))

                // Barra de progreso (igual que BlockCard)
                ProgressView(value: 1.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: .white.opacity(0.9)))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)

                // Badge (igual que BlockCard.Completado)
                HStack(spacing: 4) {
                    Image(systemName: "square.grid.2x2.fill")
                        .font(.system(size: 12))
                    Text("\(stats.total) ejercicios")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                }
                .foregroundStyle(.white.opacity(0.9))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())
                .padding(.top, 2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color(white: 0.25), Color(white: 0.18)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.white.opacity(0.1), radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Card Button Style

private struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

private struct StatBadge: View {
    let value: Int
    let color: Color

    var body: some View {
        Text("\(value)")
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

// MARK: - Footer Section

private struct FooterSection: View {
    private var totalExercises: Int {
        ExerciseBlock.allBlocks.reduce(0) { $0 + $1.exerciseCount }
    }

    private var implementedExercises: Int {
        ExerciseBlock.allBlocks
            .filter { $0.isAvailable }
            .reduce(0) { $0 + Int(Double($1.exerciseCount) * $1.progress) }
    }

    var body: some View {
        VStack(spacing: 12) {
            Divider()
                .background(Color.white.opacity(0.1))
                .padding(.horizontal, 40)

            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    Text("\(totalExercises)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Total")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                }

                VStack(spacing: 4) {
                    Text("\(implementedExercises)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(red: 0.91, green: 0.30, blue: 0.24))
                    Text("Disponibles")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                }

                VStack(spacing: 4) {
                    Text("5")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Text("Bloques")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(white: 0.5))
                }
            }
            .padding(.vertical, 16)

            // Créditos
            Text("Apple Coding Academy - Swift Developer Program 2026")
                .font(.system(size: 11, weight: .regular, design: .rounded))
                .foregroundStyle(Color(white: 0.4))
                .padding(.bottom, 8)
        }
        .padding(.top, 20)
    }
}

#Preview {
    BlockSelectionView()
}
