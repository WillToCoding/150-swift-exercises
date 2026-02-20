//
//  ExerciseBlock.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 19/12/25.
//

import SwiftUI

struct ExerciseBlock: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let exerciseCount: Int
    let idRange: String
    let color: Color
    let icon: String
    let isAvailable: Bool
    let progress: Double // 0.0 to 1.0

    static let allBlocks: [ExerciseBlock] = [
        ExerciseBlock(
            id: "intro1",
            name: "Introducción I",
            subtitle: "Iniciación",
            exerciseCount: 20,
            idRange: "1-20",
            color: Color(red: 0.61, green: 0.35, blue: 0.71), // Morado
            icon: "1.circle.fill",
            isAvailable: true,
            progress: 1.0
        ),
        ExerciseBlock(
            id: "intro2",
            name: "Introducción II",
            subtitle: "Intermedio",
            exerciseCount: 20,
            idRange: "1-20",
            color: Color(red: 0.95, green: 0.77, blue: 0.06), // Dorado
            icon: "2.circle.fill",
            isAvailable: true,
            progress: 1.0
        ),
        ExerciseBlock(
            id: "basicos",
            name: "Básicos",
            subtitle: "Fundamentos",
            exerciseCount: 30,
            idRange: "1-30",
            color: Color(red: 0.20, green: 0.78, blue: 0.35), // Verde Esmeralda
            icon: "star.fill",
            isAvailable: true,
            progress: 1.0
        ),
        ExerciseBlock(
            id: "repaso",
            name: "Repaso",
            subtitle: "POO y Structs",
            exerciseCount: 35,
            idRange: "1-35",
            color: Color(red: 0.20, green: 0.60, blue: 0.86), // Azul Académico
            icon: "arrow.clockwise",
            isAvailable: true,
            progress: 1.0
        ),
        ExerciseBlock(
            id: "algoritmia",
            name: "Algoritmia",
            subtitle: "Programación Funcional",
            exerciseCount: 45,
            idRange: "1-45",
            color: Color(red: 0.91, green: 0.30, blue: 0.24), // Coral/Rojo Academia
            icon: "function",
            isAvailable: true,
            progress: 1.0
        )
    ]
}
