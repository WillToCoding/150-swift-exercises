//
//  GlobalStatsCard.swift
//  Ejercicios-iOS
//
//  Extraído de BlockSelectionView.swift
//

import SwiftUI

struct GlobalStatsCard: View {
    @Environment(StatsViewModel.self) private var statsVM

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
                if statsVM.state == .loaded {
                    HStack(spacing: 6) {
                        StatBadge(value: statsVM.stats.basic, color: .green)
                        StatBadge(value: statsVM.stats.intermediate, color: .orange)
                        StatBadge(value: statsVM.stats.advanced, color: .red)
                    }
                    .foregroundStyle(.white.opacity(0.75))
                } else {
                    ProgressView()
                        .tint(.white)
                }

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
                    Text("\(statsVM.stats.total) ejercicios")
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

#Preview {
    @Previewable @State var statsVM = StatsViewModel()

    ZStack {
        Color.black
        GlobalStatsCard()
            .padding()
            .environment(statsVM)
            .onAppear {
                statsVM.loadStats()
            }
    }
}
