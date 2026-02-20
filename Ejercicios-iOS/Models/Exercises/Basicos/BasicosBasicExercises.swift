//
//  BasicosBasicExercises.swift
//  Ejercicios-iOS
//
//  Básicos - Ejercicios 1-10
//  Nivel: Básico
//

import Foundation

// MARK: - Ejercicio 1: Número Primo
// Reutiliza IntroI_Exercise14 (mismo algoritmo según diagrama del PDF)

struct Basico_Exercise01: ExecutableExercise {
    let exerciseId = 1

    @MainActor
    func execute(input: String) async throws -> String {
        let ejercicioPrimo = IntroI_Exercise14()
        return try await ejercicioPrimo.execute(input: input)
    }
}

// MARK: - Ejercicio 2: Contar Primos en Array
// Reutiliza Basico_Exercise01 para verificar cada número

struct Basico_Exercise02: ExecutableExercise {
    let exerciseId = 2

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer array de números
        let numbers = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        // Paso 2: Validar que no esté vacío
        guard !numbers.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números separados por coma")
        }

        // Paso 3: Validar máximo 50 elementos
        guard numbers.count <= 50 else {
            throw ExerciseError.outOfRange("Máximo 50 elementos permitidos")
        }

        // Paso 4: Contar primos usando Basico_Exercise01
        let ejercicioPrimo = Basico_Exercise01()
        var primos: [Int] = []

        for num in numbers {
            if let resultado = try? await ejercicioPrimo.execute(input: String(num)),
               resultado.contains("es primo") && !resultado.contains("NO") {
                primos.append(num)
            }
        }

        // Paso 5: Mostrar resultado
        return """
        Array: [\(numbers.map(String.init).joined(separator: ", "))]
        Total de primos: \(primos.count)
        Primos encontrados: \(primos.map(String.init).joined(separator: ", "))
        """
    }
}

// MARK: - Ejercicio 3: Secuencia Fibonacci
// Reutiliza Exercise06 de Algoritmia

struct Basico_Exercise03: ExecutableExercise {
    let exerciseId = 3

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer N
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 2: Validar N >= 1 y N <= 50
        guard n >= 1 && n <= 50 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 50")
        }

        // Paso 3: Generar secuencia usando Exercise06
        let ejercicioFib = Exercise06()
        var secuencia: [String] = []

        for i in 1...n {
            let resultado = try await ejercicioFib.execute(input: String(i))
            // Extraer solo el número del resultado "Fibonacci(X) = Y"
            if let numero = resultado.split(separator: "=").last?.trimmingCharacters(in: .whitespaces) {
                secuencia.append(numero)
            }
        }

        // Paso 4: Mostrar resultado
        return secuencia.joined(separator: ", ")
    }
}

// MARK: - Ejercicio 4: Verificar Palíndromo
// Reutiliza Exercise05 de Algoritmia + validación de una palabra

struct Basico_Exercise04: ExecutableExercise {
    let exerciseId = 4

    @MainActor
    func execute(input: String) async throws -> String {
        let texto = input.trimmingCharacters(in: .whitespaces)

        // Paso 1: Validar que no esté vacío
        guard !texto.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa una palabra")
        }

        // Paso 2: Validar que sea una sola palabra (sin espacios)
        guard !texto.contains(" ") else {
            throw ExerciseError.invalidInput("Solo se permite una palabra (sin espacios)")
        }

        // Paso 3: Validar longitud máxima
        guard texto.count <= 100 else {
            throw ExerciseError.outOfRange("Máximo 100 caracteres permitidos")
        }

        // Paso 4: Usar Exercise05 de Algoritmia
        let ejercicioPalindromo = Exercise05()
        return try await ejercicioPalindromo.execute(input: texto)
    }
}

// MARK: - Ejercicio 5: Suma Cifras del Factorial
// Reutiliza IntroI_Exercise10 para el factorial + suma de cifras

struct Basico_Exercise05: ExecutableExercise {
    let exerciseId = 5

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer el número
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 2: Validar n >= 0 y n <= 20
        guard n >= 0 && n <= 20 else {
            throw ExerciseError.outOfRange("El número debe estar entre 0 y 20")
        }

        // Paso 3: Obtener factorial usando IntroI_Exercise10
        let ejercicioFactorial = IntroI_Exercise10()
        let resultadoFactorial = try await ejercicioFactorial.execute(input: input)

        // Extraer el número del resultado "X! = Y"
        guard let factorialStr = resultadoFactorial.split(separator: "=").last?.trimmingCharacters(in: .whitespaces),
              let factorial = Int(factorialStr) else {
            throw ExerciseError.invalidInput("Error al calcular factorial")
        }

        // Paso 4: Sumar las cifras del factorial
        let cifras = String(factorial).compactMap { $0.wholeNumberValue }
        let suma = cifras.reduce(0, +)

        // Paso 5: Mostrar resultado
        return """
        \(n)! = \(factorial)
        Suma de cifras: \(cifras.map(String.init).joined(separator: " + ")) = \(suma)
        """
    }
}

// MARK: - Ejercicio 6: Conjuntos con Elementos Comunes
// Reutiliza Basico_Exercise01 para verificar primos

struct Basico_Exercise06: ExecutableExercise {
    let exerciseId = 6

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer N
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 2: Validar N >= 3 y N <= 20
        guard n >= 3 && n <= 20 else {
            throw ExerciseError.outOfRange("El número debe estar entre 3 y 20")
        }

        // Paso 3: Obtener todos los primos de 1 a 100 usando Basico_Exercise01
        let ejercicioPrimo = Basico_Exercise01()
        var todosLosPrimos: [Int] = []

        for num in 1...100 {
            if let resultado = try? await ejercicioPrimo.execute(input: String(num)),
               resultado.contains("es primo") && !resultado.contains("NO") {
                todosLosPrimos.append(num)
            }
        }

        // Paso 4: Elegir N primos aleatorios (sin repetir posición)
        var primos: Set<Int> = []
        var indicesUsados: Set<Int> = []

        while primos.count < n {
            let indice = Int.random(in: 0..<todosLosPrimos.count)
            if !indicesUsados.contains(indice) {
                indicesUsados.insert(indice)
                primos.insert(todosLosPrimos[indice])
            }
        }

        // Paso 5: Obtener rango del conjunto de primos
        guard let primoMinimo = primos.min(),
              let primoMaximo = primos.max() else {
            throw ExerciseError.invalidInput("Error al generar primos")
        }

        // Paso 6: Generar aleatorios en min...max, SOLO añadimos si es primo
        var conjuntoGenerado: Set<Int> = []
        var contadorComunes = 0

        while contadorComunes < 3 {
            let aleatorio = Int.random(in: primoMinimo...primoMaximo)
            if primos.contains(aleatorio) && !conjuntoGenerado.contains(aleatorio) {
                conjuntoGenerado.insert(aleatorio)
                contadorComunes += 1
            }
        }

        // Paso 7: Rellenar con aleatorios de 1...100 hasta tener N elementos
        while conjuntoGenerado.count < n {
            let aleatorio = Int.random(in: 1...100)
            conjuntoGenerado.insert(aleatorio)
        }

        // Paso 8: Calcular intersección final
        let interseccion = primos.intersection(conjuntoGenerado)

        // Paso 9: Mostrar resultado
        return """
        Conjunto de primos: {\(primos.sorted().map(String.init).joined(separator: ", "))}
        Conjunto generado: {\(conjuntoGenerado.sorted().map(String.init).joined(separator: ", "))}
        Elementos comunes (\(interseccion.count)): {\(interseccion.sorted().map(String.init).joined(separator: ", "))}
        """
    }
}

// MARK: - Ejercicio 7: Suma de Array
// Reutiliza Exercise01 de Algoritmia

struct Basico_Exercise07: ExecutableExercise {
    let exerciseId = 7

    @MainActor
    func execute(input: String) async throws -> String {
        let ejercicioSuma = Exercise01()
        return try await ejercicioSuma.execute(input: input)
    }
}

// MARK: - Ejercicio 8: Filtrar Primos de Array Aleatorio
// Reutiliza Basico_Exercise01 para verificar primos (mismo patrón que Ejercicio 6)

struct Basico_Exercise08: ExecutableExercise {
    let exerciseId = 8

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Generar 100 números aleatorios entre 1 y 100
        var arrayAleatorio: [Int] = []
        for _ in 1...100 {
            arrayAleatorio.append(Int.random(in: 1...100))
        }

        // Paso 2: Filtrar primos usando Basico_Exercise01
        let ejercicioPrimo = Basico_Exercise01()
        var primos: [Int] = []

        for num in arrayAleatorio {
            if let resultado = try? await ejercicioPrimo.execute(input: String(num)),
               resultado.contains("es primo") && !resultado.contains("NO") {
                primos.append(num)
            }
        }

        // Paso 3: Formatear con salto de línea cada 10 números
        let arrayOrdenado = arrayAleatorio.sorted()
        let primosUnicos = Array(Set(primos)).sorted()

        let arrayFormateado = stride(from: 0, to: arrayOrdenado.count, by: 10).map { i in
            arrayOrdenado[i..<min(i + 10, arrayOrdenado.count)]
                .map { String(format: "%3d", $0) }
                .joined(separator: ", ")
        }.joined(separator: "\n")

        let primosFormateado = stride(from: 0, to: primosUnicos.count, by: 10).map { i in
            primosUnicos[i..<min(i + 10, primosUnicos.count)]
                .map { String(format: "%3d", $0) }
                .joined(separator: ", ")
        }.joined(separator: "\n")

        // Paso 4: Mostrar resultado
        return """
        Array generado (100 números):
        \(arrayFormateado)

        Primos únicos encontrados: \(primosUnicos.count)
        \(primosFormateado)
        """
    }
}

// MARK: - Ejercicio 9: Media Aritmética
// Reutiliza Basico_Exercise07 para obtener la suma

struct Basico_Exercise09: ExecutableExercise {
    let exerciseId = 9

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Contar elementos para calcular media después
        let numbers = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard !numbers.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números separados por coma")
        }

        // Paso 2: Obtener suma usando Basico_Exercise07 (valida rangos automáticamente)
        let ejercicioSuma = Basico_Exercise07()
        let resultadoSuma = try await ejercicioSuma.execute(input: input)

        // Paso 3: Extraer el número de "Suma: X"
        guard let sumaStr = resultadoSuma.split(separator: ":").last?.trimmingCharacters(in: .whitespaces),
              let suma = Double(sumaStr) else {
            throw ExerciseError.invalidInput("Error al calcular suma")
        }

        // Paso 4: Calcular media
        let media = suma / Double(numbers.count)

        // Paso 5: Mostrar resultado
        return "Media: \(media.formatted(.number.precision(.fractionLength(2))))"
    }
}

// MARK: - Ejercicio 10: Diccionario Alimentos (Ticket)

struct Basico_Exercise10: ExecutableExercise {
    let exerciseId = 10

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Diccionario con 10 alimentos y precios por kg
        let precios: [String: Double] = [
            "manzana": 2.50,
            "naranja": 1.80,
            "platano": 1.50,
            "plátano": 1.50,
            "uva": 3.20,
            "pera": 2.30,
            "melon": 1.20,
            "melón": 1.20,
            "sandia": 0.90,
            "sandía": 0.90,
            "fresa": 4.50,
            "kiwi": 3.80,
            "piña": 2.10,
            "mango": 3.50
        ]

        // Paso 2: Separar productos por ";"
        let items = input.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        guard !items.isEmpty else {
            throw ExerciseError.invalidInput("Formato: producto, kilos; producto, kilos (ej: manzana, 2; naranja, 1.5)")
        }

        // Paso 3: Procesar cada producto
        var lineasTicket: [String] = []
        var total: Double = 0

        for item in items {
            let parts = item.lowercased().split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

            guard parts.count == 2 else {
                throw ExerciseError.invalidInput("Formato incorrecto en: \(item)")
            }

            let producto = parts[0]
            guard let precioPorKg = precios[producto] else {
                throw ExerciseError.invalidInput("Producto no encontrado: \(producto). Disponibles: manzana, naranja, plátano, uva, pera, melón, sandía, fresa, kiwi, piña, mango")
            }

            guard let kilos = Double(parts[1]) else {
                throw ExerciseError.invalidInput("Kilos inválidos en: \(item)")
            }

            guard kilos > 0 && kilos <= 50 else {
                throw ExerciseError.outOfRange("Kilos deben estar entre 0.01 y 50")
            }

            let subtotal = precioPorKg * kilos
            total += subtotal

            // Formatear línea del ticket con alineación a la derecha
            func padLeft(_ str: String, _ length: Int) -> String {
                String(repeating: " ", count: max(0, length - str.count)) + str
            }

            let kilosStr = padLeft(kilos.formatted(.number.precision(.fractionLength(2))), 6)
            let precioStr = padLeft(precioPorKg.formatted(.number.precision(.fractionLength(2))), 5)
            let subtotalStr = padLeft(subtotal.formatted(.number.precision(.fractionLength(2))), 7)

            let linea = "\(producto.capitalized.padding(toLength: 10, withPad: " ", startingAt: 0))\(kilosStr) kg x \(precioStr)€ =\(subtotalStr)€"
            lineasTicket.append(linea)
        }

        // Paso 4: Construir ticket
        return """
        --- TICKET ---
        \(lineasTicket.joined(separator: "\n"))
        --------------
        TOTAL: \(total.formatted(.number.precision(.fractionLength(2))))€
        """
    }
}
