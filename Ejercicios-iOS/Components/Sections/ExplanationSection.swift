//
//  ExplanationSection.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 20/02/26.
//

import SwiftUI

struct ExplanationSection: View {
    let explanation: String?
    let diagramImage: String?
    @State private var isExpanded = false
    @State private var showFullScreenImage = false
    @State private var diagramScale: CGFloat = 1.0  // Solo macOS

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header del botón expandible
            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .foregroundStyle(.yellow)
                    Text("¿Cómo funciona este algoritmo?")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.secondarySystemGroupedBackground)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            // Contenido expandible
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    // Explicación textual
                    if let explanation = explanation {
                        Text(explanation)
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    // Imagen del diagrama
                    if let imageName = diagramImage {
                        DiagramView(
                            imageName: imageName,
                            showFullScreenImage: $showFullScreenImage,
                            diagramScale: $diagramScale
                        )
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.yellow.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow.opacity(0.3), lineWidth: 1)
                )
                .padding(.top, 8)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        #if os(iOS)
        .fullScreenCover(isPresented: $showFullScreenImage) {
            if let imageName = diagramImage {
                ZoomableImageView(imageName: imageName)
            }
        }
        #endif
    }
}

// MARK: - Diagram View

private struct DiagramView: View {
    let imageName: String
    @Binding var showFullScreenImage: Bool
    @Binding var diagramScale: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            #if os(iOS)
            // iOS: Toca para abrir fullscreen
            HStack {
                Text("Diagrama de Flujo")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                Text("Toca para ampliar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Button {
                showFullScreenImage = true
            } label: {
                Image(imageName)
                    .interpolation(.high)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            #else
            // macOS: Controles de zoom integrados
            HStack {
                Text("Diagrama de Flujo")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()

                // Controles de zoom
                HStack(spacing: 8) {
                    Button {
                        withAnimation { diagramScale = max(1, diagramScale - 0.25) }
                    } label: {
                        Image(systemName: "minus.magnifyingglass")
                    }
                    .buttonStyle(.borderless)

                    Text("\(Int(diagramScale * 100))%")
                        .monospacedDigit()
                        .frame(width: 45)
                        .font(.caption)

                    Button {
                        withAnimation { diagramScale = min(3, diagramScale + 0.25) }
                    } label: {
                        Image(systemName: "plus.magnifyingglass")
                    }
                    .buttonStyle(.borderless)

                    Button {
                        withAnimation { diagramScale = 1 }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .buttonStyle(.borderless)
                }
            }

            GeometryReader { geometry in
                ScrollView([.horizontal, .vertical]) {
                    Image(imageName)
                        .interpolation(.high)
                        .antialiased(true)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.width * diagramScale,
                            height: geometry.size.height * diagramScale
                        )
                        .frame(
                            minWidth: geometry.size.width,
                            minHeight: geometry.size.height
                        )
                }
                .scrollIndicators(.visible)
            }
            .aspectRatio(4/3, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            #endif
        }
    }
}

// MARK: - Zoomable Image View

struct ZoomableImageView: View {
    let imageName: String
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                #if os(macOS)
                // macOS: ScrollView con imagen centrada y controles de zoom
                ScrollView([.horizontal, .vertical]) {
                    Image(imageName)
                        .interpolation(.high)
                        .antialiased(true)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.width * scale,
                            height: geometry.size.height * scale
                        )
                        .frame(
                            minWidth: geometry.size.width,
                            minHeight: geometry.size.height
                        )
                }
                .scrollIndicators(.visible)
                .overlay(alignment: .bottomTrailing) {
                    // Controles de zoom para macOS
                    HStack(spacing: 12) {
                        Button {
                            withAnimation { scale = max(1, scale - 0.5) }
                        } label: {
                            Image(systemName: "minus.magnifyingglass")
                        }
                        .buttonStyle(.borderless)

                        Text("\(Int(scale * 100))%")
                            .monospacedDigit()
                            .frame(width: 50)

                        Button {
                            withAnimation { scale = min(5, scale + 0.5) }
                        } label: {
                            Image(systemName: "plus.magnifyingglass")
                        }
                        .buttonStyle(.borderless)

                        Divider()
                            .frame(height: 20)

                        Button {
                            withAnimation { scale = 1 }
                        } label: {
                            Image(systemName: "arrow.counterclockwise")
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(10)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding()
                }
                #else
                // iOS: Gestos táctiles
                ScrollView([.horizontal, .vertical], showsIndicators: false) {
                    Image(imageName)
                        .interpolation(.high)
                        .antialiased(true)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: geometry.size.width * scale,
                            height: geometry.size.height * scale
                        )
                        .frame(
                            minWidth: geometry.size.width,
                            minHeight: geometry.size.height
                        )
                        .onTapGesture(count: 2) {
                            withAnimation {
                                scale = scale > 1 ? 1 : 2.5
                            }
                        }
                }
                .defaultScrollAnchor(.center)
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let delta = value / lastScale
                            lastScale = value
                            scale = min(max(scale * delta, 1), 5)
                        }
                        .onEnded { _ in
                            lastScale = 1.0
                            if scale < 1 {
                                withAnimation { scale = 1 }
                            }
                        }
                )
                #endif
            }
            .background(Color.black)
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                #endif
                ToolbarItem(placement: .principal) {
                    Text("Diagrama de Flujo")
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                }
                #if os(iOS)
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            scale = 1
                            offset = .zero
                            lastOffset = .zero
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .foregroundStyle(.white)
                    }
                }
                #else
                ToolbarItem(placement: .automatic) {
                    Button {
                        withAnimation {
                            scale = 1
                            offset = .zero
                            lastOffset = .zero
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                #endif
            }
            #if os(iOS)
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            #endif
        }
    }
}

#Preview {
    ExplanationSection(
        explanation: "Este algoritmo utiliza un bucle para sumar todos los números desde 1 hasta n.",
        diagramImage: nil
    )
    .padding()
}
