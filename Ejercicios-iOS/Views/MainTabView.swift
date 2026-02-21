//
//  MainTabView.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 21/02/26.
//

import SwiftUI

/// Detecta si el dispositivo es iPhone para condicionar vistas
#if os(iOS)
@MainActor let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
#else
@MainActor let isiPhone = false // En macOS siempre usa vistas de pantalla grande
#endif

struct MainTabView: View {
    var body: some View {
        #if os(iOS)
        TabView {
            Tab("Bloques", systemImage: "square.grid.2x2.fill") {
                if isiPhone {
                    BlockSelectionView()
                } else {
                    BlockSelectionViewiPad()
                }
            }

            Tab("Ejercicios", systemImage: "list.bullet.rectangle.fill") {
                if isiPhone {
                    NavigationStack {
                        AllExercisesListView(initialDifficulty: nil)
                    }
                } else {
                    AllExercisesListViewiPad()
                }
            }

            Tab("Buscar", systemImage: "magnifyingglass", role: .search) {
                if isiPhone {
                    NavigationStack {
                        SearchExercisesView()
                    }
                } else {
                    SearchExercisesViewiPad()
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tabBarMinimizeBehavior(.onScrollDown)
        #else
        // macOS: usa directamente la vista de bloques con NavigationSplitView
        BlockSelectionViewiPad()
        #endif
    }
}

#Preview {
    MainTabView()
}
