//
//  BasicosAdvancedExercises.swift
//  Ejercicios-iOS
//
//  Básicos - Ejercicios 21-30
//  Nivel: Intermedio-Avanzado
//

import Foundation

// MARK: - Ejercicio 21: Búsqueda Binaria
// Divide el array en 2 en cada paso, comparando el elemento central con el buscado.

struct Basico_Exercise21: ExecutableExercise {
    let exerciseId = 21

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Separar array y valor por el "|"
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }

        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: elementos | valor (ej: 1,3,5,7,9 | 5)")
        }

        // Paso 2: Parsear el array
        let array = parts[0].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        // Paso 3: Validar que el array no esté vacío
        guard !array.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 4: Validar máximo 20 elementos
        guard array.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        // Paso 5: Validar rango de cada número (-1000 a 1000)
        guard array.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        // Paso 6: Eliminar duplicados (Set) y ordenar (Array)
        let sortedArray = Array(Set(array)).sorted()

        // Paso 7: Parsear el valor a buscar
        guard let target = Int(parts[1]) else {
            throw ExerciseError.invalidInput("El valor a buscar debe ser un número entero")
        }

        // Paso 8: Validar rango del valor a buscar (-1000 a 1000)
        guard target >= -1000 && target <= 1000 else {
            throw ExerciseError.outOfRange("El valor a buscar debe estar entre -1000 y 1000")
        }

        // Paso 9: Validar que el valor exista en el array
        guard sortedArray.contains(target) else {
            throw ExerciseError.invalidInput("El valor \(target) no existe en el array [\(sortedArray.map(String.init).joined(separator: ", "))]")
        }

        // Paso 10: Búsqueda Binaria
        var left = 0
        var right = sortedArray.count - 1
        var foundIndex = 0
        var found = false

        while left <= right && !found {
            let mid = (left + right) / 2

            if sortedArray[mid] == target {
                foundIndex = mid
                found = true
            } else if sortedArray[mid] < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }

        // Paso 11: Mostrar resultado
        return """
        Array ordenado: [\(sortedArray.map(String.init).joined(separator: ", "))]
        Valor \(target) encontrado en índice \(foundIndex)
        """
    }
}

// MARK: - Ejercicio 22: Números Perfectos
// Un número perfecto es igual a la suma de sus divisores propios (excluyendo el número mismo).

struct Basico_Exercise22: ExecutableExercise {
    let exerciseId = 22

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear el límite
        guard let limit = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero")
        }

        // Paso 2: Validar rango (2 a 1000)
        guard limit >= 2 && limit <= 1000 else {
            throw ExerciseError.outOfRange("El límite debe estar entre 2 y 1000")
        }

        // Paso 3: Función para verificar si es perfecto
        func esPerfecto(_ n: Int) -> Bool {
            guard n > 1 else { return false }
            let divisores = (1..<n).filter { n % $0 == 0 }
            return divisores.reduce(0, +) == n
        }

        // Paso 4: Buscar todos los perfectos hasta el límite
        let perfectos = (2...limit).filter { esPerfecto($0) }

        // Paso 5: Mostrar resultado
        if perfectos.isEmpty {
            return "No hay números perfectos hasta \(limit)"
        }

        return "Números perfectos hasta \(limit): \(perfectos.map(String.init).joined(separator: ", "))"
    }
}

// MARK: - Ejercicio 23: Número de Armstrong
// Un número de Armstrong es igual a la suma de sus dígitos elevados a la potencia del número de dígitos.
// Ejemplo: 153 = 1³ + 5³ + 3³ = 1 + 125 + 27 = 153

struct Basico_Exercise23: ExecutableExercise {
    let exerciseId = 23

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear el número
        guard let number = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero")
        }

        // Paso 2: Validar rango (0 a 999999)
        guard number >= 0 && number <= 999999 else {
            throw ExerciseError.outOfRange("El número debe estar entre 0 y 999999")
        }

        // Paso 3: Obtener dígitos
        let digits = String(number).compactMap { $0.wholeNumberValue }

        // Paso 4: Calcular potencia (número de dígitos)
        let power = digits.count

        // Paso 5: Sumar cada dígito elevado a la potencia
        let sum = digits.reduce(0) { $0 + Int(pow(Double($1), Double(power))) }

        // Paso 6: Verificar si es Armstrong
        let isArmstrong = sum == number

        // Paso 7: Mostrar cálculo
        let calculation = digits.map { "\($0)^\(power)" }.joined(separator: " + ")

        return """
        \(calculation) = \(sum)
        \(number) \(isArmstrong ? "es" : "no es") número de Armstrong
        """
    }
}

// MARK: - Ejercicio 24: Producto Escalar Vectores
// El producto escalar multiplica componentes correspondientes y suma los resultados.
// Fórmula: a·b = a₁×b₁ + a₂×b₂ + ... + aₙ×bₙ

struct Basico_Exercise24: ExecutableExercise {
    let exerciseId = 24

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Separar los dos vectores por "|"
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: vector1 | vector2 (ej: 1,2,3 | 4,5,6)")
        }

        // Paso 2: Parsear cada vector
        let v1 = parts[0].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        let v2 = parts[1].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        // Paso 3: Validar que ambos vectores tengan la misma longitud
        guard v1.count == v2.count else {
            throw ExerciseError.invalidInput("Los vectores deben tener la misma longitud")
        }

        // Paso 4: Validar mínimo 2 elementos
        guard v1.count >= 2 else {
            throw ExerciseError.outOfRange("Cada vector debe tener al menos 2 elementos")
        }

        // Paso 5: Validar máximo 10 elementos
        guard v1.count <= 10 else {
            throw ExerciseError.outOfRange("Cada vector debe tener máximo 10 elementos")
        }

        // Paso 6: Validar rango de cada número (-1000 a 1000)
        guard v1.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número del vector 1 debe estar entre -1000 y 1000")
        }
        guard v2.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número del vector 2 debe estar entre -1000 y 1000")
        }

        // Paso 7: Calcular producto escalar paso a paso
        var productos: [Int] = []
        var lineas: [String] = []

        for i in 0..<v1.count {
            let a = v1[i]
            let b = v2[i]
            let producto = a * b
            productos.append(producto)
            lineas.append("Posición \(i + 1): \(a) × \(b) = \(producto)")
        }

        let suma = productos.reduce(0, +)

        // Paso 8: Formatear salida
        let vectorA = v1.map(String.init).joined(separator: ", ")
        let vectorB = v2.map(String.init).joined(separator: ", ")
        let sumaStr = productos.map(String.init).joined(separator: " + ")

        return """
        Vector A: [\(vectorA)]
        Vector B: [\(vectorB)]

        \(lineas.joined(separator: "\n"))
        ─────────────────────
        Suma total: \(sumaStr) = \(suma)
        """
    }
}

// MARK: - Ejercicio 25: Criba de Eratóstenes
// Algoritmo para encontrar todos los primos hasta N.

struct Basico_Exercise25: ExecutableExercise {
    let exerciseId = 25

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear y validar rango (1 a 1000)
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)), n >= 1, n <= 1000 else {
            throw ExerciseError.invalidInput("Ingresa un número entre 1 y 1000")
        }

        // Paso 2: Crear array de candidatos (todos true inicialmente)
        var sieve = Array(repeating: true, count: n + 1)
        sieve[0] = false

        // Paso 3: Tachar múltiplos de cada primo
        var p = 2
        while p * p <= n {
            if sieve[p] {
                for i in stride(from: p * p, through: n, by: p) {
                    sieve[i] = false
                }
            }
            p += 1
        }

        // Paso 4: Extraer los primos (índices que quedaron en true)
        let primes = sieve.enumerated().compactMap { $1 ? $0 : nil }

        // Paso 5: Mostrar resultado
        return """
        Primos hasta \(n) (\(primes.count) encontrados):
        \(primes.map(String.init).joined(separator: ", "))
        """
    }
}

// MARK: - Ejercicio 26: Romano a Decimal
// Convierte un número romano a su valor decimal.

struct Basico_Exercise26: ExecutableExercise {
    let exerciseId = 26

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear input
        let roman = input.trimmingCharacters(in: .whitespaces).uppercased()
        guard !roman.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa un número romano")
        }

        // Paso 2: Tabla de valores
        let values: [Character: Int] = [
            "I": 1, "V": 5, "X": 10, "L": 50,
            "C": 100, "D": 500, "M": 1000
        ]

        // Paso 3: Convertir caracteres a valores (y validar)
        var valores: [Int] = []
        for char in roman {
            guard let value = values[char] else {
                throw ExerciseError.invalidInput("Carácter inválido: \(char)")
            }
            valores.append(value)
        }

        // Paso 4: Validar repeticiones
        let noRepetir = "VLD"
        for char in noRepetir {
            if roman.contains("\(char)\(char)") {
                throw ExerciseError.invalidInput("\(char) no puede repetirse")
            }
        }

        let maxTres = "IXCM"
        for char in maxTres {
            if roman.contains("\(char)\(char)\(char)\(char)") {
                throw ExerciseError.invalidInput("\(char) no puede aparecer más de 3 veces seguidas")
            }
        }

        // Paso 5: Validar restas válidas
        let restasValidas: [Character: [Character]] = [
            "I": ["V", "X"],
            "X": ["L", "C"],
            "C": ["D", "M"]
        ]

        let chars = Array(roman)
        for i in 0..<(chars.count - 1) {
            let actual = chars[i]
            let siguiente = chars[i + 1]

            if valores[i] < valores[i + 1] {
                if let permitidos = restasValidas[actual], !permitidos.contains(siguiente) {
                    throw ExerciseError.invalidInput("\(actual) no puede ir antes de \(siguiente)")
                }
            }
        }

        // Paso 6: Calcular de derecha a izquierda
        var result = 0
        var prevValue = 0

        for value in valores.reversed() {
            if value < prevValue {
                result -= value
            } else {
                result += value
            }
            prevValue = value
        }

        // Paso 7: Validar rango del resultado (1-3999)
        guard result >= 1 && result <= 3999 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 3999")
        }

        return "\(roman) = \(result)"
    }
}

// MARK: - Ejercicio 27: Formas de Dar Cambio
// Calcula combinaciones de monedas de euro para dar un cambio
// Usa DP para contar y backtracking para mostrar ejemplos ordenados por eficiencia

struct Basico_Exercise27: ExecutableExercise {
    let exerciseId = 27

    // Monedas de euro en céntimos (de mayor a menor)
    private let monedas = [200, 100, 50, 20, 10, 5, 2, 1]

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear la cantidad
        guard let cantidad = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa la cantidad en céntimos")
        }

        // Paso 2: Validar rango (1 a 2000 céntimos = 20€)
        guard cantidad >= 1 && cantidad <= 2000 else {
            throw ExerciseError.outOfRange("La cantidad debe estar entre 1 y 2000 céntimos (20€)")
        }

        // Paso 3: Contar total de combinaciones con DP
        let total = contarCombinaciones(cantidad: cantidad)

        // Paso 4: Buscar combinaciones con backtracking
        var combinaciones: [[Int: Int]] = []
        var actual: [Int: Int] = [:]
        buscarCombinaciones(
            cantidad: cantidad,
            indice: 0,
            actual: &actual,
            combinaciones: &combinaciones,
            limite: 100  // Buscar hasta 100 para luego ordenar
        )

        // Paso 5: Ordenar por número de monedas (menos = más eficiente)
        let ordenadas = combinaciones.sorted { combo1, combo2 in
            let total1 = combo1.values.reduce(0, +)
            let total2 = combo2.values.reduce(0, +)
            return total1 < total2
        }

        // Paso 6: Formatear las más eficientes (máximo 10)
        let mostrar = min(10, ordenadas.count)
        var lineas: [String] = []
        for (i, combo) in ordenadas.prefix(mostrar).enumerated() {
            let totalMonedas = combo.values.reduce(0, +)
            let partes = combo.keys.sorted(by: >).compactMap { moneda -> String? in
                guard let cant = combo[moneda], cant > 0 else { return nil }
                return "\(cant)×\(formatearMoneda(moneda))"
            }
            lineas.append("\(i + 1). \(partes.joined(separator: " + ")) → \(totalMonedas) monedas")
        }

        let monedasStr = monedas.map { formatearMoneda($0) }.joined(separator: ", ")

        return """
        Cantidad: \(formatearCantidad(cantidad))
        Monedas: [\(monedasStr)]
        ─────────────────────────────
        Total: \(total) formas de dar el cambio

        Las \(mostrar) más eficientes:
        \(lineas.joined(separator: "\n"))
        """
    }

    // DP para contar combinaciones (rápido)
    private func contarCombinaciones(cantidad: Int) -> Int {
        var dp = Array(repeating: 0, count: cantidad + 1)
        dp[0] = 1

        for moneda in monedas where moneda <= cantidad {
            for c in moneda...cantidad {
                dp[c] += dp[c - moneda]
            }
        }
        return dp[cantidad]
    }

    // Backtracking para listar combinaciones
    private func buscarCombinaciones(
        cantidad: Int,
        indice: Int,
        actual: inout [Int: Int],
        combinaciones: inout [[Int: Int]],
        limite: Int
    ) {
        // Parar si tenemos suficientes
        if combinaciones.count >= limite { return }

        // Combinación válida encontrada
        if cantidad == 0 {
            combinaciones.append(actual)
            return
        }

        // Sin más monedas
        if indice >= monedas.count { return }

        let moneda = monedas[indice]
        let maxUsar = cantidad / moneda

        for usar in stride(from: maxUsar, through: 0, by: -1) {
            if combinaciones.count >= limite { return }

            if usar > 0 {
                actual[moneda] = usar
            }

            buscarCombinaciones(
                cantidad: cantidad - (moneda * usar),
                indice: indice + 1,
                actual: &actual,
                combinaciones: &combinaciones,
                limite: limite
            )

            actual.removeValue(forKey: moneda)
        }
    }

    private func formatearMoneda(_ centimos: Int) -> String {
        centimos >= 100 ? "\(centimos / 100)€" : "\(centimos)c"
    }

    private func formatearCantidad(_ centimos: Int) -> String {
        centimos >= 100 ? "\((Double(centimos) / 100.0).formatted(.number.precision(.fractionLength(2...2))))€" : "\(centimos) céntimos"
    }
}

// MARK: - Ejercicio 28: Subsecuencia Creciente Más Larga (LIS)
// Algoritmo: Programación Dinámica O(n²)

struct Basico_Exercise28: ExecutableExercise {
    let exerciseId = 28

    @MainActor
    func execute(input: String) async throws -> String {
        // 1. Validar que no esté vacío
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // 2. Parsear números
        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        // 3. Validar que cada componente sea un número válido
        let numbers = try components.map { component -> Int in
            guard let number = Int(component) else {
                throw ExerciseError.invalidInput("'\(component)' no es un número válido")
            }
            return number
        }

        // 4. Validar cantidad (2-20 elementos)
        guard numbers.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 números")
        }
        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 números permitidos")
        }

        // 5. Validar rango de cada número (-1000 a 1000)
        guard numbers.allSatisfy({ (-1000...1000).contains($0) }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        // 6. Algoritmo LIS con programación dinámica
        let n = numbers.count
        var dp = Array(repeating: 1, count: n)      // Longitudes
        var parent = Array(repeating: -1, count: n) // "¿De quién vine?"

        for i in 1..<n {
            for j in 0..<i {
                if numbers[j] < numbers[i] && dp[j] + 1 > dp[i] {
                    dp[i] = dp[j] + 1
                    parent[i] = j
                }
            }
        }

        // 7. Encontrar el máximo
        let maxLength = dp.max() ?? 0
        var maxIndex = dp.firstIndex(of: maxLength) ?? 0

        // 8. Reconstruir siguiendo los padres
        var sequence: [Int] = []
        while maxIndex != -1 {
            sequence.append(numbers[maxIndex])
            maxIndex = parent[maxIndex]
        }
        sequence.reverse()

        return """
        Longitud: \(maxLength)
        Subsecuencia: \(sequence.map(String.init).joined(separator: ", "))
        """
    }
}

// MARK: - Ejercicio 29: Cifrado César
// Fórmula: E(x) = (x + k) mod 26
// Usa Unicode para ser escalable

struct Basico_Exercise29: ExecutableExercise {
    let exerciseId = 29

    @MainActor
    func execute(input: String) async throws -> String {
        // 1. Parsear input: mensaje | k
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: mensaje | k (ej: Hola Mundo | 3)")
        }

        let mensaje = parts[0]

        // 2. Validar mensaje (1-100 caracteres, solo letras y espacios)
        guard !mensaje.isEmpty && mensaje.count <= 100 else {
            throw ExerciseError.outOfRange("El mensaje debe tener entre 1 y 100 caracteres")
        }

        guard mensaje.allSatisfy({ $0.isLetter || $0.isWhitespace }) else {
            throw ExerciseError.invalidInput("El mensaje solo puede contener letras y espacios")
        }

        // 3. Validar k (-25 a 25)
        guard let k = Int(parts[1]) else {
            throw ExerciseError.invalidInput("k debe ser un número entero")
        }

        guard (-25...25).contains(k) else {
            throw ExerciseError.outOfRange("k debe estar entre -25 y 25")
        }

        // 4. Cifrar usando map + fórmula E(x) = (x + k) mod 26
        let cifrado = String(mensaje.map { cifrar($0, k: k) })

        return """
        Original: \(mensaje)
        Cifrado (k=\(k)): \(cifrado)
        """
    }

    /// E(x) = (x + k) mod 26
    private func cifrar(_ char: Character, k: Int) -> Character {
        guard let ascii = char.asciiValue else { return char }

        // Determinar base según mayúscula (65) o minúscula (97)
        let base: UInt8
        if (65...90).contains(ascii) {
            base = 65
        } else if (97...122).contains(ascii) {
            base = 97
        } else {
            return char  // No es letra, devolver sin cambios
        }

        // E(x) = (x + k) mod 26
        let x = Int(ascii - base)
        let nuevaPos = ((x + k) % 26 + 26) % 26

        return Character(UnicodeScalar(base + UInt8(nuevaPos)))
    }
}

// MARK: - Ejercicio 30: Distancia de Levenshtein (DP Iterativa)
// D(i,j) = min operaciones para transformar s1[0..i] en s2[0..j]

struct Basico_Exercise30: ExecutableExercise {
    let exerciseId = 30

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let parts = trimmed.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: palabra1|palabra2")
        }

        let s1 = parts[0].lowercased()
        let s2 = parts[1].lowercased()

        guard !s1.isEmpty && !s2.isEmpty else {
            throw ExerciseError.invalidInput("Las palabras no pueden estar vacías")
        }

        guard s1.count <= 100 && s2.count <= 100 else {
            throw ExerciseError.outOfRange("Cada palabra debe tener máximo 100 caracteres")
        }

        let distance = levenshteinDP(s1, s2)

        return """
        Palabra 1: "\(s1)"
        Palabra 2: "\(s2)"
        Distancia de Levenshtein: \(distance)
        """
    }

    /// Calcula Levenshtein usando DP iterativa (tabla)
    private func levenshteinDP(_ s1: String, _ s2: String) -> Int {
        let arr1 = Array(s1)
        let arr2 = Array(s2)
        let m = arr1.count
        let n = arr2.count

        // Crear tabla dp[m+1][n+1]
        var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

        // Caso base: transformar cadena vacía
        for i in 0...m { dp[i][0] = i }
        for j in 0...n { dp[0][j] = j }

        // Llenar la tabla
        for i in 1...m {
            for j in 1...n {
                if arr1[i - 1] == arr2[j - 1] {
                    // Caracteres iguales: no hay costo
                    dp[i][j] = dp[i - 1][j - 1]
                } else {
                    // Caracteres diferentes: elegir mínimo
                    dp[i][j] = 1 + min(
                        dp[i - 1][j],       // eliminación
                        dp[i][j - 1],       // inserción
                        dp[i - 1][j - 1]    // sustitución
                    )
                }
            }
        }

        return dp[m][n]
    }
}
