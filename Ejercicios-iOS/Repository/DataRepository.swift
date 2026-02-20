//
//  DataRepository.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

/// Protocol para repositorio de datos que añade funcionalidad de JSONLoader
protocol DataRepository: JSONLoader {
    func loadExercises() throws -> [Exercise]
}

extension DataRepository {
    /// Carga los ejercicios desde el archivo JSON usando la versión genérica
    func loadExercises() throws -> [Exercise] {
        try load(type: [Exercise].self)
    }
}
