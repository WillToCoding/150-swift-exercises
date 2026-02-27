//
//  BlockCard.swift
//  Ejercicios-iOS
//
//  Extraído de BlockSelectionView.swift
//

import SwiftUI

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
                .lineLimit(1)
                .minimumScaleFactor(0.7)

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

#Preview {
    ZStack {
        Color.black
        BlockCard(block: ExerciseBlock.allBlocks[0])
            .padding()
    }
}
