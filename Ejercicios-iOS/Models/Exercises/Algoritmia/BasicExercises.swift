//
//  BasicExercises.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

// MARK: - Ejercicio 1: Suma de Array con Reduce

struct Exercise01: ExecutableExercise {
    let exerciseId = 1

    func sumarArray(_ numeros: [Int]) -> Int {
        numeros.reduce(0, +)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let numbers = input.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numbers.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        guard numbers.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        let suma = sumarArray(numbers)
        return "Array: [\(numbers.map(String.init).joined(separator: ", "))]\nSuma: \(suma)"
    }
}

// MARK: - Ejercicio 2: Promedio de Pares con Filter y Reduce

struct Exercise02: ExecutableExercise {
    let exerciseId = 2

    func promedioPares(_ numeros: [Int]) -> Double {
        let pares = numeros.filter { $0 % 2 == 0 }
        guard !pares.isEmpty else { return 0 }
        let suma = pares.reduce(0, +)
        return Double(suma) / Double(pares.count)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let numbers = input.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numbers.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        guard numbers.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        let pares = numbers.filter { $0 % 2 == 0 }
        let promedio = promedioPares(numbers)

        return "Array: [\(numbers.map(String.init).joined(separator: ", "))]\nPares: [\(pares.map(String.init).joined(separator: ", "))]\nPromedio: \(promedio)"
    }
}

// MARK: - Ejercicio 3: Map a Factoriales (Recursivo)

struct Exercise03: ExecutableExercise {
    let exerciseId = 3

    func factorial(_ n: Int) -> Int {
        n <= 1 ? 1 : n * factorial(n - 1)
    }

    func factoriales(_ numeros: [Int]) -> [Int] {
        numeros.map { factorial($0) }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let numbers = input.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numbers.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard numbers.count <= 10 else {
            throw ExerciseError.outOfRange("Máximo 10 elementos permitidos")
        }

        guard numbers.allSatisfy({ $0 >= 0 && $0 <= 20 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre 0 y 20")
        }

        let resultado = factoriales(numbers)
        return "Array: [\(numbers.map(String.init).joined(separator: ", "))]\nFactoriales: [\(resultado.map(String.init).joined(separator: ", "))]"
    }
}

// MARK: - Ejercicio 4: Frecuencia de Caracteres

struct Exercise04: ExecutableExercise {
    let exerciseId = 4

    func frecuenciaCaracteres(_ texto: String) -> [Character: Int] {
        texto
            .lowercased()
            .filter { $0 != " " }
            .reduce(into: [Character: Int]()) { resultado, caracter in
                resultado[caracter, default: 0] += 1
            }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let texto = input.trimmingCharacters(in: .whitespaces)

        guard !texto.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard texto.count <= 100 else {
            throw ExerciseError.outOfRange("Máximo 100 caracteres permitidos")
        }

        let frecuencias = frecuenciaCaracteres(texto)
        let resultado = frecuencias
            .sorted { $0.value > $1.value }
            .map { "\"\($0.key)\": \($0.value)" }
            .joined(separator: ", ")

        return "Texto: \"\(texto)\"\nFrecuencias: [\(resultado)]"
    }
}

// MARK: - Ejercicio 5: Palíndromo Funcional

struct Exercise05: ExecutableExercise {
    let exerciseId = 5

    func esPalindromo(_ texto: String) -> Bool {
        let chars = Array(texto.lowercased().filter { $0.isLetter })
        let mitad = chars.count / 2

        return chars.prefix(mitad).enumerated().allSatisfy { index, char in
            char == chars[chars.count - 1 - index]
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let texto = input.trimmingCharacters(in: .whitespaces)

        guard !texto.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard texto.count <= 100 else {
            throw ExerciseError.outOfRange("Máximo 100 caracteres permitidos")
        }

        let resultado = esPalindromo(texto)
        return "\"\(texto)\" \(resultado ? "es palíndromo" : "no es palíndromo")"
    }
}

// MARK: - Ejercicio 6: Fibonacci con Memoización

struct Exercise06: ExecutableExercise {
    let exerciseId = 6

    func fibonacciMemoize(_ n: Int) -> Double {
        var cache: [Int: Double] = [:]

        func fib(_ n: Int) -> Double {
            if let result = cache[n] {
                return result
            }
            let r = n < 2 ? Double(n) : fib(n - 1) + fib(n - 2)
            cache[n] = r
            return r
        }

        return fib(n)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        guard n >= 0 && n <= 50 else {
            throw ExerciseError.outOfRange("El número debe estar entre 0 y 50")
        }

        let resultado = fibonacciMemoize(n)
        return "Fibonacci(\(n)) = \(resultado.formatted(.number.precision(.fractionLength(0))))"
    }
}

// MARK: - Ejercicio 7: Diccionario Número-Cuadrado

struct Exercise07: ExecutableExercise {
    let exerciseId = 7

    func numerosCuadrados(_ numeros: [Int]) -> [Int: Int] {
        Dictionary(uniqueKeysWithValues: numeros.map { ($0, $0 * $0) })
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let numbers = input.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numbers.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        guard numbers.allSatisfy({ $0 >= -100 && $0 <= 100 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -100 y 100")
        }

        let resultado = numerosCuadrados(numbers)
        let output = resultado
            .sorted { $0.key < $1.key }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: ", ")

        return "Array: [\(numbers.map(String.init).joined(separator: ", "))]\nCuadrados: [\(output)]"
    }
}

// MARK: - Ejercicio 8: Primeros N Números Primos

struct Exercise08: ExecutableExercise {
    let exerciseId = 8

    // Lógica según diagrama ejercicio 1 de Básicos (Leibniz: 1, 2, 3 son primos)
    static func esPrimo(_ num: Int) -> Bool {
        guard num > 0 else { return false }
        guard num > 3 else { return true }
        guard num % 2 != 0 && num % 3 != 0 else { return false }
        var i = 5
        while i * i <= num {
            if num % i == 0 || num % (i + 2) == 0 { return false }
            i += 6
        }
        return true
    }

    // Enfoque funcional
    func primerosPrimos(_ n: Int) -> [Int] {
        Array((1...).lazy.filter { Exercise08.esPrimo($0) }.prefix(n))
    }

    @MainActor
    func execute(input: String) async throws -> String {
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        guard n >= 1 && n <= 100 else {
            throw ExerciseError.outOfRange("N debe estar entre 1 y 100")
        }

        let primos = primerosPrimos(n)
        return "Primeros \(n) primos: [\(primos.map(String.init).joined(separator: ", "))]"
    }
}

// MARK: - Ejercicio 9: Contar Vocales

private extension Character {
    var isVowel: Bool {
        let normalized = String(self)
            .folding(options: .diacriticInsensitive, locale: nil)
            .lowercased()
        return "aeiou".contains(normalized)
    }
}

struct Exercise09: ExecutableExercise {
    let exerciseId = 9

    func contarVocales(_ texto: String) -> (total: Int, detalle: [Character: Int]) {
        let detalle = texto
            .filter { $0.isVowel }
            .reduce(into: [Character: Int]()) { dict, char in
                let normalized = Character(
                    String(char)
                        .folding(options: .diacriticInsensitive, locale: nil)
                        .lowercased()
                )
                dict[normalized, default: 0] += 1
            }
        let total = detalle.values.reduce(0, +)
        return (total, detalle)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let texto = input.trimmingCharacters(in: .whitespaces)

        guard !texto.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard texto.count <= 500 else {
            throw ExerciseError.outOfRange("Máximo 500 caracteres permitidos")
        }

        let resultado = contarVocales(texto)
        let detalleStr = resultado.detalle
            .sorted { $0.key < $1.key }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: ", ")

        return "Texto: \"\(texto)\"\nVocales encontradas: \(resultado.total) (\(detalleStr))"
    }
}

// MARK: - Ejercicio 10: Filtrar Palíndromos

struct Exercise10: ExecutableExercise {
    let exerciseId = 10

    func filtrarPalindromos(_ palabras: [String]) -> [String] {
        let ejercicio05 = Exercise05()
        return palabras
            .filter { ejercicio05.esPalindromo($0) }
            .sorted { $0.count < $1.count }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let palabras = input.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        guard !palabras.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard palabras.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 palabras permitidas")
        }

        let palindromos = filtrarPalindromos(palabras)

        if palindromos.isEmpty {
            return "Palabras: [\(palabras.joined(separator: ", "))]\nNo se encontraron palíndromos"
        }

        return "Palabras: [\(palabras.joined(separator: ", "))]\nPalíndromos (por longitud): [\(palindromos.joined(separator: ", "))]"
    }
}

// MARK: - Ejercicio 11: Busqueda Binaria Recursiva
// Implementa una funcion de busqueda binaria recursiva que funcione sobre cualquier array ordenado.

struct Exercise11: ExecutableExercise {
    let exerciseId = 11

    // MARK: - Funcion recursiva de busqueda binaria
    private func busquedaBinaria(_ array: [Int], _ L: Int, _ R: Int, _ x: Int) -> Int? {
        // Si L cruza a R, no hay donde buscar
        if L > R { return nil }

        // Calculo el punto medio
        let mid = (L + R) / 2

        // Comparo el del medio con lo que busco
        if array[mid] == x {
            return mid
        } else if array[mid] > x {
            // El del medio es MAS GRANDE -> busco a la IZQUIERDA
            return busquedaBinaria(array, L, mid - 1, x)
        } else {
            // El del medio es MAS PEQUENO -> busco a la DERECHA
            return busquedaBinaria(array, mid + 1, R, x)
        }
    }

    // MARK: - Execute
    @MainActor
    func execute(input: String) async throws -> String {
        // 1. Separar array | objetivo
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: numeros | objetivo (ej: 5,1,9,3,7 | 7)")
        }

        // 2. Parsear array
        let componentes = parts[0].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let numeros = try componentes.map { componente -> Int in
            guard let numero = Int(componente) else {
                throw ExerciseError.invalidInput("'\(componente)' no es un numero valido")
            }
            return numero
        }

        // 3. Validar cantidad (2-20 elementos)
        guard numeros.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 numeros")
        }
        guard numeros.count <= 20 else {
            throw ExerciseError.outOfRange("Maximo 20 numeros permitidos")
        }

        // 4. Validar rango (-1000 a 1000)
        guard numeros.allSatisfy({ (-1000...1000).contains($0) }) else {
            throw ExerciseError.outOfRange("Cada numero debe estar entre -1000 y 1000")
        }

        // 5. Eliminar duplicados y ordenar
        let arrayOrdenado = Array(Set(numeros)).sorted()

        // 6. Parsear objetivo
        guard let objetivo = Int(parts[1]) else {
            throw ExerciseError.invalidInput("El objetivo debe ser un numero")
        }

        // 7. Validar que el objetivo este en el array
        guard arrayOrdenado.contains(objetivo) else {
            throw ExerciseError.invalidInput("El numero \(objetivo) no existe en el array")
        }

        // 8. Busqueda binaria recursiva
        let indice = busquedaBinaria(arrayOrdenado, 0, arrayOrdenado.count - 1, objetivo)

        // 9. Output
        return """
        Array original: [\(numeros.map(String.init).joined(separator: ", "))]
        Array ordenado: [\(arrayOrdenado.map(String.init).joined(separator: ", "))]
        Buscar: \(objetivo)
        Encontrado en indice \(indice ?? -1)
        """
    }
}

// MARK: - Ejercicio 12: MCD Recursivo (Algoritmo de Euclides)
// MCD(a, b) = a, si b = 0
// MCD(a, b) = MCD(b, a mod b), si b != 0

struct Exercise12: ExecutableExercise {
    let exerciseId = 12

    // MARK: - Funcion recursiva MCD (Euclides)
    private func mcd(_ a: Int, _ b: Int) -> Int {
        // Caso base: si b es 0, el MCD es a
        if b == 0 { return a }
        // Caso recursivo: MCD(b, a mod b)
        return mcd(b, a % b)
    }

    // MARK: - Execute
    @MainActor
    func execute(input: String) async throws -> String {
        // 1. Parsear entrada
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // 2. Separar por coma
        let componentes = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard componentes.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: numero1, numero2 (ej: 48, 18)")
        }

        // 3. Parsear numeros
        guard let a = Int(componentes[0]) else {
            throw ExerciseError.invalidInput("'\(componentes[0])' no es un numero valido")
        }
        guard let b = Int(componentes[1]) else {
            throw ExerciseError.invalidInput("'\(componentes[1])' no es un numero valido")
        }

        // 4. Validar rango (0 a 10000)
        guard a >= 0 && a <= 10000 else {
            throw ExerciseError.outOfRange("El primer numero debe estar entre 0 y 10000")
        }
        guard b >= 0 && b <= 10000 else {
            throw ExerciseError.outOfRange("El segundo numero debe estar entre 0 y 10000")
        }

        // 5. MCD(0, 0) no esta definido
        guard !(a == 0 && b == 0) else {
            throw ExerciseError.invalidInput("MCD(0, 0) no esta definido")
        }

        // 6. Calcular MCD recursivo
        let resultado = mcd(a, b)

        // 7. Output
        return """
        MCD(\(a), \(b)) = \(resultado)
        """
    }
}

// MARK: - Ejercicio 13: Subsecuencia Creciente Mas Larga (LIS)
// Reutiliza Basico_Exercise28

struct Exercise13: ExecutableExercise {
    let exerciseId = 13
    private let lis = Basico_Exercise28()

    @MainActor
    func execute(input: String) async throws -> String {
        try await lis.execute(input: input)
    }
}

// MARK: - Ejercicio 14: Merge Sort Recursivo (Funcional)
// MergeSort(A) = A,                                    si |A| <= 1
//              = Merge(MergeSort(A1), MergeSort(A2)),  si |A| > 1

struct Exercise14: ExecutableExercise {
    let exerciseId = 14

    // Division funcional: usa prefix y dropFirst
    private func mergeSort(_ array: [Int]) -> [Int] {
        // Caso base: |A| <= 1 -> devolver A
        guard array.count > 1 else { return array }

        // Caso recursivo: |A| > 1 -> dividir y fusionar
        let mid = array.count / 2
        let left = mergeSort(Array(array.prefix(mid)))      // MergeSort(A1)
        let right = mergeSort(Array(array.dropFirst(mid)))  // MergeSort(A2)

        return merge(left, right)  // Merge(MergeSort(A1), MergeSort(A2))
    }

    // Fusion funcional: usa dropFirst, sin var, sin while
    private func merge(_ left: [Int], _ right: [Int]) -> [Int] {
        guard let l = left.first else { return right }
        guard let r = right.first else { return left }

        if l <= r {
            return [l] + merge(Array(left.dropFirst()), right)
        } else {
            return [r] + merge(left, Array(right.dropFirst()))
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let numbers = try components.map { component -> Int in
            guard let number = Int(component) else {
                throw ExerciseError.invalidInput("'\(component)' no es un numero valido")
            }
            return number
        }

        guard numbers.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 numeros")
        }
        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Maximo 20 numeros permitidos")
        }
        guard numbers.allSatisfy({ (-1000...1000).contains($0) }) else {
            throw ExerciseError.outOfRange("Cada numero debe estar entre -1000 y 1000")
        }

        let sorted = mergeSort(numbers)

        return """
        Original: [\(numbers.map(String.init).joined(separator: ", "))]
        Ordenado: [\(sorted.map(String.init).joined(separator: ", "))]
        """
    }
}

// MARK: - Ejercicio 15: Conjunto Potencia (Power Set)
// P(S) = { X | X ⊆ S }  →  todos los subconjuntos de S
// |P(S)| = 2^n  →  el número de subconjuntos es 2 elevado a n

struct Exercise15: ExecutableExercise {
    let exerciseId = 15

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        let numbers = try components.map { component -> Int in
            guard let number = Int(component) else {
                throw ExerciseError.invalidInput("'\(component)' no es un número válido")
            }
            return number
        }

        guard numbers.count <= 10 else {
            throw ExerciseError.outOfRange("Máximo 10 elementos (2^10 = 1024 subconjuntos)")
        }

        let result = powerSet(numbers)
        let originalString = numbers.map(String.init).joined(separator: ", ")
        let subconjuntosString = result.map { subconjunto in
            if subconjunto.isEmpty {
                return "  []"
            }
            return "  [\(subconjunto.map(String.init).joined(separator: ", "))]"
        }.joined(separator: "\n")

        return """
        Conjunto S: [\(originalString)]
        n = \(numbers.count) elementos
        |P(S)| = 2^\(numbers.count) = \(result.count) subconjuntos

        P(S) = {
        \(subconjuntosString)
        }
        """
    }

    /// Genera el conjunto potencia usando recursión
    private func powerSet(_ array: [Int]) -> [[Int]] {
        // Caso base: array vacío → solo hay un subconjunto: el vacío
        if array.isEmpty {
            return [[]]
        }

        // Tomo el primer elemento
        let primero = array[0]
        let resto = Array(array.dropFirst())

        // Genero todos los subconjuntos del resto (RECURSIÓN)
        let subconjuntosDelResto = powerSet(resto)

        // Para cada subconjunto, tengo 2 opciones:
        // 1. Dejarlo como está (NO incluyo el primero)
        // 2. Añadirle el primero (SÍ incluyo el primero)
        var resultado: [[Int]] = []

        for subconjunto in subconjuntosDelResto {
            resultado.append(subconjunto)              // sin el primero
            resultado.append([primero] + subconjunto)  // con el primero
        }

        return resultado
    }
}
