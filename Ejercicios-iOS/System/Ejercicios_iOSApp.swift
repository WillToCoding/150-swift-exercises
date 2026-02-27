//
//  Ejercicios_iOSApp.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 5/12/25.
//

import SwiftUI

@main
struct Ejercicios_iOSApp: App {
    @State private var statsVM = StatsViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(statsVM)
                .onAppear {
                    statsVM.loadStats()
                }
        }
    }
}
