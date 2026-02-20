//
//  BasicosIntermediateExercises.swift
//  Ejercicios-iOS
//
//  Básicos - Ejercicios 11-20
//  Nivel: Intermedio
//

import Foundation

// MARK: - Ejercicio 11: Máximo Común Divisor
// Reutiliza IntroI_Exercise17 (algoritmo de Euclides)

struct Basico_Exercise11: ExecutableExercise {
    let exerciseId = 11

    @MainActor
    func execute(input: String) async throws -> String {
        let ejercicioMCD = IntroI_Exercise17()
        return try await ejercicioMCD.execute(input: input)
    }
}

// MARK: - Ejercicio 12: Decimal a Binario
// Convierte un número decimal (base 10) a binario (base 2) con 16 bits

struct Basico_Exercise12: ExecutableExercise {
    let exerciseId = 12

    @MainActor
    func execute(input: String) async throws -> String {
        guard let number = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero")
        }

        guard number >= 0 && number <= 65535 else {
            throw ExerciseError.outOfRange("El número debe estar entre 0 y 65535 (16 bits)")
        }

        // Caso especial: 0
        if number == 0 {
            return """
            0 a binario:
            ───────────────────────
            0 ÷ 2 = 0, resto 0
            ───────────────────────
            0 en binario = 00000000 00000000 (16 bits)
            """
        }

        var n = number
        var restos: [Int] = []
        var pasos: [String] = []

        // Algoritmo: dividir entre 2 y guardar restos
        while n > 0 {
            let resto = n % 2
            let cociente = n / 2
            pasos.append("\(n) ÷ 2 = \(cociente), resto \(resto)")
            restos.append(resto)
            n = cociente
        }

        // Binario = restos leídos de abajo hacia arriba
        let binarioSinPadding = restos.reversed().map(String.init).joined()

        // Rellenar con ceros a la izquierda hasta 16 bits
        let binario16 = String(repeating: "0", count: 16 - binarioSinPadding.count) + binarioSinPadding

        // Separar en grupos de 8 para legibilidad
        let grupo1 = String(binario16.prefix(8))
        let grupo2 = String(binario16.suffix(8))

        return """
        \(number) a binario:
        ───────────────────────
        \(pasos.joined(separator: "\n"))
        ───────────────────────
        \(number) en binario = \(grupo1) \(grupo2) (16 bits)
        """
    }
}

// MARK: - Ejercicio 13: Frecuencia de Letras
// Reutiliza Exercise04 (Algoritmia) y filtra solo letras para obtener Top 3

struct Basico_Exercise13: ExecutableExercise {
    let exerciseId = 13

    @MainActor
    func execute(input: String) async throws -> String {
        guard !input.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ExerciseError.invalidInput("Ingresa un texto")
        }

        // Reutilizar Exercise04 para obtener frecuencias
        let ejercicio = Exercise04()
        let frecuencias = ejercicio.frecuenciaCaracteres(input)

        // Filtrar solo letras (Exercise04 incluye todos los caracteres excepto espacios)
        let soloLetras = frecuencias.filter { $0.key.isLetter }

        guard !soloLetras.isEmpty else {
            throw ExerciseError.invalidInput("El texto no contiene letras")
        }

        // Ordenar por frecuencia (mayor a menor)
        let sorted = soloLetras.sorted { $0.value > $1.value }

        let todas = sorted.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        let top3 = sorted.prefix(3).map { "\($0.key): \($0.value)" }.joined(separator: ", ")

        return """
        Frecuencias: \(todas)
        Top 3 letras: \(top3)
        """
    }
}

// MARK: - Ejercicio 14: Área y Perímetro Triángulo
// Fórmula de Herón: s = (a+b+c)/2, área = √(s(s-a)(s-b)(s-c))
// Reutiliza IntroII_Exercise01 para clasificar el tipo de triángulo

struct Basico_Exercise14: ExecutableExercise {
    let exerciseId = 14

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer los tres lados
        let sides = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard sides.count == 3 else {
            throw ExerciseError.invalidInput("Ingresa los 3 lados separados por coma")
        }

        let (a, b, c) = (sides[0], sides[1], sides[2])

        // Paso 2: Validar rango de cada lado (1-100)
        guard a >= 1 && a <= 100 else {
            throw ExerciseError.outOfRange("El lado a debe estar entre 1 y 100")
        }
        guard b >= 1 && b <= 100 else {
            throw ExerciseError.outOfRange("El lado b debe estar entre 1 y 100")
        }
        guard c >= 1 && c <= 100 else {
            throw ExerciseError.outOfRange("El lado c debe estar entre 1 y 100")
        }

        // Paso 3: Verificar desigualdad triangular
        guard a + b > c && a + c > b && b + c > a else {
            throw ExerciseError.invalidInput("Los lados no forman un triángulo válido")
        }

        // Paso 4: Calcular perímetro
        let perimeter = a + b + c

        // Paso 5: Calcular semiperímetro
        let s = perimeter / 2

        // Paso 6: Calcular área con fórmula de Herón
        let area = sqrt(s * (s - a) * (s - b) * (s - c))

        // Paso 7: Reutilizar IntroII_Exercise01 para clasificar el tipo
        let clasificador = IntroII_Exercise01()
        let tipo = try await clasificador.execute(input: input)

        // Paso 8: Mostrar resultados
        return """
        Perímetro: \(perimeter.formatted(.number.precision(.fractionLength(2))))
        Área: \(area.formatted(.number.precision(.fractionLength(2))))
        Tipo: \(tipo)
        """
    }
}

// MARK: - Ejercicio 15: Bubble Sort
// Recorre comparando elementos adyacentes, intercambia si están mal.
// Repite hasta que no haya intercambios en una pasada completa.

struct Basico_Exercise15: ExecutableExercise {
    let exerciseId = 15

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer los números
        var numbers = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard !numbers.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números separados por coma")
        }

        // Paso 2: Validar cantidad máxima de elementos (20)
        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        // Paso 3: Validar rango de cada número (-1000 a 1000)
        guard numbers.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        let original = numbers.map(String.init).joined(separator: ", ")

        // Paso 4: Bubble Sort con optimización
        var huboIntercambio = true

        while huboIntercambio {
            huboIntercambio = false

            for j in 0..<(numbers.count - 1) {
                if numbers[j] > numbers[j + 1] {
                    numbers.swapAt(j, j + 1)
                    huboIntercambio = true
                }
            }
        }

        // Paso 5: Mostrar resultado
        let sorted = numbers.map(String.init).joined(separator: ", ")
        return """
        Original: [\(original)]
        Ordenado: [\(sorted)]
        """
    }
}

// MARK: - Ejercicio 16: Verificar Anagrama
// Dos palabras son anagramas si tienen las mismas letras en diferente orden
// Reglas: mayúsculas y acentos son intercambiables (A=a=á)

struct Basico_Exercise16: ExecutableExercise {
    let exerciseId = 16

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer dos palabras
        let parts = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        // Paso 2: Validar que sean 2 palabras
        guard parts.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa dos palabras separadas por coma")
        }

        // Paso 3: Normalizar (minúsculas + quitar acentos)
        let word1 = parts[0]
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)
        let word2 = parts[1]
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: nil)

        // Paso 4: Validar que no estén vacías
        guard !word1.isEmpty && !word2.isEmpty else {
            throw ExerciseError.invalidInput("Las palabras no pueden estar vacías")
        }

        // Paso 5: Validar rango (máx 50 caracteres cada una)
        guard word1.count <= 50 else {
            throw ExerciseError.outOfRange("La primera palabra debe tener máximo 50 caracteres")
        }
        guard word2.count <= 50 else {
            throw ExerciseError.outOfRange("La segunda palabra debe tener máximo 50 caracteres")
        }

        // Paso 6: Validar que solo contengan letras
        guard word1.allSatisfy({ $0.isLetter }) else {
            throw ExerciseError.invalidInput("La primera palabra solo puede contener letras")
        }
        guard word2.allSatisfy({ $0.isLetter }) else {
            throw ExerciseError.invalidInput("La segunda palabra solo puede contener letras")
        }

        // Paso 7: Ordenar letras y comparar
        let isAnagram = word1.sorted() == word2.sorted()

        // Paso 8: Mostrar resultado
        return isAnagram
            ? "\"\(parts[0])\" y \"\(parts[1])\" son anagramas"
            : "\"\(parts[0])\" y \"\(parts[1])\" no son anagramas"
    }
}

// MARK: - Ejercicio 17: Segundo Mayor
// Encuentra el segundo número más grande en un array (sin contar duplicados)

struct Basico_Exercise17: ExecutableExercise {
    let exerciseId = 17

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Leer los números
        let numbers = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        // Paso 2: Validar que haya al menos 2 números
        guard numbers.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 números separados por coma")
        }

        // Paso 3: Validar cantidad máxima (20)
        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        // Paso 4: Validar rango de cada número (-1000 a 1000)
        guard numbers.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        // Paso 5: Eliminar duplicados y ordenar de mayor a menor
        let unique = Array(Set(numbers)).sorted(by: >)

        // Paso 6: Validar que haya al menos 2 valores distintos
        guard unique.count >= 2 else {
            throw ExerciseError.invalidInput("Debe haber al menos 2 valores distintos")
        }

        // Paso 7: Obtener el segundo mayor
        let mayor = unique[0]
        let segundoMayor = unique[1]

        // Paso 8: Mostrar resultado
        return """
        Array: [\(numbers.map(String.init).joined(separator: ", "))]
        Mayor: \(mayor)
        Segundo mayor: \(segundoMayor)
        """
    }
}

// MARK: - Ejercicio 18: Números Triangulares
// Tn = n(n+1)/2 - Triángulo equilátero centrado

struct Basico_Exercise18: ExecutableExercise {
    let exerciseId = 18

    @MainActor
    func execute(input: String) async throws -> String {
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)), n > 0, n <= 50 else {
            throw ExerciseError.invalidInput("Ingresa un número entre 1 y 50")
        }

        // Dibujar triángulo equilátero centrado
        var triangulo = ""
        for fila in 1...n {
            let espacios = String(repeating: " ", count: n - fila)
            let asteriscos = String(repeating: "* ", count: fila)
            triangulo += espacios + asteriscos + "\n"
        }

        // Calcular la serie de números triangulares
        let serie = (1...n).map { $0 * ($0 + 1) / 2 }

        return """
        \(triangulo)
        Serie: \(serie.map(String.init).joined(separator: ", "))
        """
    }
}

// MARK: - Ejercicio 19: Rotación Array Derecha
// Rota los elementos k posiciones a la derecha (los del final pasan al principio)

struct Basico_Exercise19: ExecutableExercise {
    let exerciseId = 19

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Separar array y k por el "|"
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }

        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: elementos | posiciones (ej: 1,2,3,4,5 | 2)")
        }

        // Paso 2: Convertir string a array de enteros
        var array = parts[0].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        // Paso 3: Validar que el array no esté vacío
        guard !array.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 4: Validar cantidad máxima de elementos (20)
        guard array.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        // Paso 5: Validar rango de cada número (-1000 a 1000)
        guard array.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        // Paso 6: Obtener k (posiciones a rotar)
        guard let k = Int(parts[1]) else {
            throw ExerciseError.invalidInput("Las posiciones deben ser un número entero")
        }

        // Paso 7: Validar rango de k (0 a 100)
        guard k >= 0 && k <= 100 else {
            throw ExerciseError.outOfRange("Las posiciones deben estar entre 0 y 100")
        }

        // Guardar el original para mostrarlo después
        let original = array.map(String.init).joined(separator: ", ")

        // Paso 8: Calcular rotaciones efectivas con módulo
        let rotations = k % array.count

        // Paso 9: Rotar (si hay rotaciones que hacer)
        if rotations > 0 {
            let suffix = array.suffix(rotations)                  // Últimos elementos
            let prefix = array.prefix(array.count - rotations)    // Primeros elementos
            array = Array(suffix) + Array(prefix)                 // Juntar: suffix + prefix
        }

        // Paso 10: Mostrar resultado
        return """
        Original: [\(original)]
        Rotado \(k) posiciones: [\(array.map(String.init).joined(separator: ", "))]
        """
    }
}

// MARK: - Ejercicio 20: Año Bisiesto
// Reutiliza IntroII_Exercise12 (mismo algoritmo)

struct Basico_Exercise20: ExecutableExercise {
    let exerciseId = 20

    @MainActor
    func execute(input: String) async throws -> String {
        let ejercicioBisiesto = IntroII_Exercise12()
        return try await ejercicioBisiesto.execute(input: input)
    }
}
