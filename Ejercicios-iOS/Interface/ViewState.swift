//
//  ViewState.swift
//  Ejercicios-iOS
//
//  Created by Juan Carlos on 23/2/26.
//

import Foundation

/// Estados posibles de una vista que carga datos
/// Similar a EmpleadosAPI
enum ViewState: Equatable {
    case loading
    case loaded
    case error(String)

    var isLoading: Bool {
        self == .loading
    }

    var errorMessage: String? {
        if case .error(let message) = self {
            return message
        }
        return nil
    }
}
