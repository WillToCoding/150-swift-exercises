//
//  JSONLoader.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

/// Protocol para cargar datos desde archivos JSON
@MainActor
protocol JSONLoader {
    var url: URL { get }
}

extension JSONLoader {
    /// Función de carga genérica de JSON
    func load<JSON>(type: JSON.Type) throws -> JSON where JSON: Decodable {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }
}
