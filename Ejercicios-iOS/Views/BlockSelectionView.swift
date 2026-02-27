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

#Preview {
    BlockSelectionView()
}
