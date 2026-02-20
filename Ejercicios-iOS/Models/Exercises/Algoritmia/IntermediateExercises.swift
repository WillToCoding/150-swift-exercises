//
//  IntermediateExercises.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

// MARK: - Ejercicio 16: Triángulo de Pascal
// Cada elemento es el coeficiente binomial: C(n,k) = n! / (k! × (n-k)!)
// Usa map y recursión

struct Exercise16: ExecutableExercise {
    let exerciseId = 16

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard let n = Int(trimmed) else {
            throw ExerciseError.invalidInput("'\(trimmed)' no es un número válido")
        }

        guard n >= 0 && n <= 15 else {
            throw ExerciseError.outOfRange("El numero debe estar entre 0 y 15")
        }

        let triangulo = trianguloPascal(n)  // input n = filas 0 a n
        let resultado = formatearTriangulo(triangulo)

        return """
        TRIANGULO DE PASCAL (filas 0 a \(n))
        ────────────────────────────────────

        \(resultado)
        """
    }

    /// Factorial: n! = n × (n-1) × ... × 1
    private func factorial(_ n: Int) -> Int {
        n <= 1 ? 1 : n * factorial(n - 1)
    }

    /// Coeficiente binomial: C(n,k) = n! / (k! × (n-k)!)
    private func coeficienteBinomial(_ n: Int, _ k: Int) -> Int {
        factorial(n) / (factorial(k) * factorial(n - k))
    }

    /// Genera una fila del triángulo usando map
    private func filaTriangulo(_ n: Int) -> [Int] {
        (0...n).map { k in coeficienteBinomial(n, k) }
    }

    /// Genera el triángulo completo usando recursión
    private func trianguloPascal(_ n: Int) -> [[Int]] {
        // Caso base: fila 0
        if n == 0 {
            return [filaTriangulo(0)]
        }
        // Recursión: filas anteriores + fila actual
        return trianguloPascal(n - 1) + [filaTriangulo(n)]
    }

    /// Formatea el triangulo con ancho fijo por numero (alineado correctamente)
    private func formatearTriangulo(_ triangulo: [[Int]]) -> String {
        // Encontrar el numero mas grande para calcular ancho fijo
        let maxNumero = triangulo.flatMap { $0 }.max() ?? 1
        let anchoNumero = String(maxNumero).count

        // Calcular ancho total de la ultima fila
        let ultimaFila = triangulo.last ?? []
        let maxAncho = ultimaFila.count * (anchoNumero + 1) - 1

        return triangulo.map { fila in
            // Cada numero con ancho fijo, alineado a la derecha
            let filaStr = fila.map { numero in
                String(numero).leftPadding(toLength: anchoNumero, withPad: " ")
            }.joined(separator: " ")
            let espacios = String(repeating: " ", count: (maxAncho - filaStr.count) / 2)
            return espacios + filaStr
        }.joined(separator: "\n")
    }
}

// Extension para padding izquierdo
private extension String {
    func leftPadding(toLength length: Int, withPad pad: String) -> String {
        let toPad = length - self.count
        if toPad < 1 { return self }
        return String(repeating: pad, count: toPad) + self
    }
}

// MARK: - Ejercicio 17: Substring mas largo sin caracteres repetidos

struct Exercise17: ExecutableExercise {
    let exerciseId = 17

    // Sliding Window: O(n)
    func substringsMasLargos(_ s: String) -> (substrings: [String], longitud: Int) {
        let chars = Array(s)
        var left = 0
        var maxLongitud = 0
        var maxInicios: [Int] = []
        var caracteres: Set<Character> = []

        for right in 0..<chars.count {
            while caracteres.contains(chars[right]) {
                caracteres.remove(chars[left])
                left += 1
            }

            caracteres.insert(chars[right])

            let longitudActual = right - left + 1
            if longitudActual > maxLongitud {
                maxLongitud = longitudActual
                maxInicios = [left]
            } else if longitudActual == maxLongitud {
                maxInicios.append(left)
            }
        }

        let substrings = maxInicios.map { inicio in
            String(chars[inicio..<(inicio + maxLongitud)])
        }

        return (substrings, maxLongitud)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard trimmed.count >= 2 else {
            throw ExerciseError.outOfRange("Minimo 2 caracteres")
        }

        guard trimmed.count <= 500 else {
            throw ExerciseError.outOfRange("Maximo 500 caracteres")
        }

        let resultado = substringsMasLargos(trimmed)
        let lista = resultado.substrings.enumerated()
            .map { "  \($0.offset + 1). \"\($0.element)\"" }
            .joined(separator: "\n")

        return """
        SUBSTRING MAS LARGO SIN REPETIDOS
        ──────────────────────────────────
        Entrada: "\(trimmed)"
        Longitud maxima: \(resultado.longitud)

        Encontrados (\(resultado.substrings.count)):
        \(lista)
        """
    }
}

// MARK: - Ejercicio 18: Criba de Eratóstenes (Funcional)
// Algoritmo: Para cada primo p, eliminar sus múltiplos (k·p con k >= 2)
// Enfoque: Recursivo y funcional (sin mutación, usando filter)

struct Exercise18: ExecutableExercise {
    let exerciseId = 18

    @MainActor
    func execute(input: String) async throws -> String {
        // Parsear entrada
        guard let limite = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero")
        }

        // Validar rango
        guard limite >= 2 && limite <= 10000 else {
            throw ExerciseError.outOfRange("El límite debe estar entre 2 y 10000")
        }

        // Generar candidatos: S = {2, 3, 4, ..., N}
        let candidatos = Array(2...limite)

        // Aplicar criba funcional recursiva
        let primos = cribaFuncional(candidatos)

        return """
        Primos hasta \(limite): \(primos.count) encontrados
        [\(primos.map(String.init).joined(separator: ", "))]
        """
    }

    /// Criba de Eratóstenes recursiva y funcional
    /// - Para cada primo p, filtra sus múltiplos
    /// - Devuelve solo los números primos
    private func cribaFuncional(_ numeros: [Int]) -> [Int] {
        // Caso base: lista vacía
        guard let primo = numeros.first else { return [] }

        // Optimización: si primo² > último, todos los restantes son primos
        guard primo * primo <= (numeros.last ?? 0) else { return numeros }

        // Filtrar: quitar múltiplos del primo actual (k·p con k >= 2)
        let sinMultiplos = numeros.filter { $0 == primo || $0 % primo != 0 }

        // Recursión: primo actual + criba del resto
        return [primo] + cribaFuncional(Array(sinMultiplos.dropFirst()))
    }
}

// MARK: - Ejercicio 19: Frecuencia de Palabras
// Cuenta cada palabra en un texto y ordena descendentemente por frecuencia

struct Exercise19: ExecutableExercise {
    let exerciseId = 19

    // Función que devuelve un diccionario con la frecuencia de cada palabra
    func frecuenciaPalabras(_ texto: String) -> [String: Int] {
        // Separar en palabras (quitar puntuación, pasar a minúsculas)
        let palabras = texto.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        // Contar frecuencia con reduce (funcional)
        return palabras.reduce(into: [String: Int]()) { dict, palabra in
            dict[palabra, default: 0] += 1
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let texto = input.trimmingCharacters(in: .whitespaces)

        // Validar entrada vacía
        guard !texto.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Validar longitud máxima (500 caracteres)
        guard texto.count <= 500 else {
            throw ExerciseError.outOfRange("El texto debe tener máximo 500 caracteres")
        }

        // Llamar a la función
        let frecuencias = frecuenciaPalabras(texto)

        // Validar que haya palabras
        guard !frecuencias.isEmpty else {
            throw ExerciseError.invalidInput("No se encontraron palabras válidas")
        }

        let totalPalabras = frecuencias.values.reduce(0, +)
        
        // Validar mínimo 2 palabras
        guard totalPalabras >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 palabras")
        }

        // Ordenar descendente por frecuencia
        let ordenado = frecuencias.sorted { $0.value > $1.value }

        // Formatear salida
        let resultado = ordenado.map { "\($0.key): \($0.value)" }.joined(separator: ", ")

        return """
        Texto: "\(texto)"
        Palabras encontradas: \(totalPalabras)
        ─────────────────────────────
        Frecuencias: \(resultado)
        """
    }
}

// MARK: - Ejercicio 20: Divisores (Recursivo)
// Encuentra todos los divisores de un número usando recursión
// Optimizado: solo prueba hasta √N

struct Exercise20: ExecutableExercise {
    let exerciseId = 20

    @MainActor
    func execute(input: String) async throws -> String {
        // Parsear entrada
        guard let numero = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero")
        }

        // Validar rango (1 a 100000)
        guard numero >= 1 && numero <= 100000 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 100000")
        }

        // Buscar divisores con recursión (optimizado hasta √N)
        let divisores = buscarDivisores(numero, candidato: 1).sorted()

        return """
        Número: \(numero)
        Divisores: [\(divisores.map(String.init).joined(separator: ", "))]
        Total: \(divisores.count) divisores
        """
    }

    /// Función recursiva optimizada (solo hasta √N)
    private func buscarDivisores(_ numero: Int, candidato: Int) -> [Int] {
        // Caso base: candidato² > numero
        guard candidato * candidato <= numero else { return [] }

        if numero % candidato == 0 {
            let divisorAlto = numero / candidato

            if candidato == divisorAlto {
                // Raíz exacta (ej: 4 en 16), añadir solo una vez
                return [candidato] + buscarDivisores(numero, candidato: candidato + 1)
            } else {
                // Añadir ambos: candidato y divisorAlto
                return [candidato, divisorAlto] + buscarDivisores(numero, candidato: candidato + 1)
            }
        } else {
            return buscarDivisores(numero, candidato: candidato + 1)
        }
    }
}

// MARK: - Ejercicio 21: Potencia x^n (Divide y Vencerás)
// Implementa una función recursiva para calcular x^n

struct Exercise21: ExecutableExercise {
    let exerciseId = 21

    // Recursion lineal: x^n = x * x^(n-1) - O(n)
    func potenciaLineal(_ x: Int, _ n: Int) -> Int {
        if n == 0 { return 1 }
        return x * potenciaLineal(x, n - 1)
    }

    // Divide y venceras: x^n = (x^(n/2))^2 - O(log n)
    func potencia(_ x: Int, _ n: Int) -> Int {
        if n == 0 { return 1 }

        let mitad = potencia(x, n / 2)

        if n % 2 == 0 {
            return mitad * mitad            // n par: (x^(n/2))²
        } else {
            return x * mitad * mitad        // n impar: x × (x^(n/2))²
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Formato: x,n (base,exponente)
        let parts = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: base,exponente (ej: 2,8)")
        }

        guard let x = Int(parts[0]), let n = Int(parts[1]) else {
            throw ExerciseError.invalidInput("Debes ingresar dos números enteros")
        }

        guard x >= -15 && x <= 15 else {
            throw ExerciseError.outOfRange("La base debe estar entre -15 y 15")
        }

        guard n >= 0 && n <= 15 else {
            throw ExerciseError.outOfRange("El exponente debe estar entre 0 y 15")
        }

        let resultado = potenciaLineal(x, n)

        return """
        POTENCIA x^n (Recursion)
        ────────────────────────
        Base (x): \(x)
        Exponente (n): \(n)

        Resultado: \(x)^\(n) = \(resultado)
        """
    }
}

// MARK: - Ejercicio 22: Dos Números que Suman Objetivo

struct Exercise22: ExecutableExercise {
    let exerciseId = 22

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Parsear: 2,7,11,15|9
        let partes = trimmed.split(separator: "|")

        guard partes.count == 2 else {
            throw ExerciseError.invalidInput("Formato: números|objetivo. Ejemplo: 2,7,11,15|9")
        }

        let numeros = partes[0].split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard numeros.count >= 2 else {
            throw ExerciseError.invalidInput("Mínimo 2 números")
        }

        guard numeros.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 números")
        }

        guard numeros.allSatisfy({ $0 >= -100 && $0 <= 100 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -100 y 100")
        }

        guard let objetivo = Int(partes[1].trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("El objetivo debe ser un número válido")
        }

        // Llamar a la función
        let resultado = buscarParesQueSuman(numeros, objetivo: objetivo)

        let arrayStr = numeros.map(String.init).joined(separator: ", ")

        if resultado.isEmpty {
            return "Array: [\(arrayStr)]\nObjetivo: \(objetivo)\n\nNo hay pares que sumen \(objetivo)"
        } else {
            let paresStr = resultado.map { "(\($0[0]), \($0[1]))" }.joined(separator: ", ")
            return "Array: [\(arrayStr)]\nObjetivo: \(objetivo)\n\nPares encontrados (\(resultado.count)): \(paresStr)"
        }
    }

    // Función con enfoque funcional - devuelve todos los pares diferentes
    private func buscarParesQueSuman(_ array: [Int], objetivo: Int) -> Set<[Int]> {
        Set(
            array.enumerated().compactMap { (i, num) in
                array.dropFirst(i + 1).first { $0 + num == objetivo }.map { [min(num, $0), max(num, $0)] }
            }
        )
    }
}

// MARK: - Ejercicio 23: Aplanar Array Anidado

struct Exercise23: ExecutableExercise {
    let exerciseId = 23

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Parsear: el usuario ingresa grupos separados por |
        // Ejemplo: 1,2,3|4,5|6,7,8
        let grupos = trimmed.split(separator: "|")

        // Validar cantidad de grupos (2-10)
        guard grupos.count >= 2 else {
            throw ExerciseError.invalidInput("Mínimo 2 grupos separados por |. Ejemplo: 1,2,3|4,5|6,7,8")
        }

        guard grupos.count <= 10 else {
            throw ExerciseError.outOfRange("Máximo 10 grupos")
        }

        var matriz: [[Int]] = []

        for grupo in grupos {
            let numeros = grupo.split(separator: ",")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

            // Validar elementos por grupo (1-10)
            guard !numeros.isEmpty else {
                throw ExerciseError.invalidInput("Cada grupo debe tener al menos 1 número")
            }

            guard numeros.count <= 10 else {
                throw ExerciseError.outOfRange("Máximo 10 elementos por grupo")
            }

            matriz.append(numeros)
        }

        // Llamar a la función que pide el enunciado
        let aplanado = aplanar(matriz)

        // Formatear salida
        let matrizStr = matriz.map { "[\($0.map(String.init).joined(separator: ", "))]" }.joined(separator: ", ")
        let aplanadoStr = aplanado.map(String.init).joined(separator: ", ")

        return "Matriz: [\(matrizStr)]\n\nAplanado: [\(aplanadoStr)]"
    }

    // Función que pide el enunciado
    private func aplanar(_ array: [[Int]]) -> [Int] {
        array.flatMap { $0 }
    }
}

// MARK: - Ejercicio 24: Permutaciones de Array (Recursivo)

struct Exercise24: ExecutableExercise {
    let exerciseId = 24

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let numeros = trimmed.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numeros.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números válidos separados por coma")
        }

        guard numeros.count <= 5 else {
            throw ExerciseError.outOfRange("Máximo 5 elementos (5! = 120 permutaciones)")
        }

        guard numeros.allSatisfy({ $0 >= -100 && $0 <= 100 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -100 y 100")
        }

        let resultado = permutaciones(numeros)

        let arrayStr = numeros.map(String.init).joined(separator: ", ")
        let permutacionesStr = resultado.map { "[\($0.map(String.init).joined(separator: ", "))]" }.joined(separator: "\n")

        return "Array: [\(arrayStr)]\n\nPermutaciones (\(resultado.count)):\n\(permutacionesStr)"
    }

    // Función recursiva para generar permutaciones
    private func permutaciones(_ array: [Int]) -> [[Int]] {
        guard array.count > 1 else { return [array] }

        var resultado: [[Int]] = []

        for i in 0..<array.count {
            let elemento = array[i]
            var resto = array
            resto.remove(at: i)

            let permsDelResto = permutaciones(resto)

            for j in 0..<permsDelResto.count {
                let permutacion = permsDelResto[j]
                resultado.append([elemento] + permutacion)
            }
        }

        return resultado
    }
}

// MARK: - Ejercicio 25: Distancia de Levenshtein (DP Recursiva)
// D(i,j) = min operaciones para transformar s1[0..i] en s2[0..j]
// Usa la fórmula recursiva directamente

struct Exercise25: ExecutableExercise {
    let exerciseId = 25

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

        guard s1.count <= 10 && s2.count <= 10 else {
            throw ExerciseError.outOfRange("Cada palabra debe tener máximo 10 caracteres (recursión sin memoización)")
        }

        let arr1 = Array(s1)
        let arr2 = Array(s2)
        let distance = levenshteinRecursivo(arr1, arr2, arr1.count, arr2.count)

        return """
        Palabra 1: "\(s1)"
        Palabra 2: "\(s2)"
        Distancia de Levenshtein: \(distance)
        """
    }

    /// D(i,j) usando la fórmula recursiva del PDF:
    /// D(i,j) = max(i,j)                           si min(i,j) = 0
    /// D(i,j) = min(D(i-1,j)+1, D(i,j-1)+1, D(i-1,j-1)+δ)  en otro caso
    /// δ(a,b) = 0 si a=b, 1 si a≠b
    private func levenshteinRecursivo(_ s1: [Character], _ s2: [Character], _ i: Int, _ j: Int) -> Int {
        // Caso base: si alguna cadena está vacía
        if min(i, j) == 0 {
            return max(i, j)
        }

        // δ(si, tj) = 0 si iguales, 1 si diferentes
        let delta = s1[i - 1] == s2[j - 1] ? 0 : 1

        // D(i,j) = min(eliminar, insertar, sustituir)
        return min(
            levenshteinRecursivo(s1, s2, i - 1, j) + 1,        // eliminar
            levenshteinRecursivo(s1, s2, i, j - 1) + 1,        // insertar
            levenshteinRecursivo(s1, s2, i - 1, j - 1) + delta // sustituir
        )
    }
}

// MARK: - Ejercicio 26: Caminos Únicos en Cuadrícula (Memoización)
// Solo puedes moverte hacia abajo (↓) o hacia la derecha (→)
// f(m,n) = 1 si m=1 o n=1, f(m-1,n) + f(m,n-1) en otro caso

struct Exercise26: ExecutableExercise {
    let exerciseId = 26

    /// Calcula caminos únicos usando recursión con memoización
    /// Patrón similar al ejercicio 6 (Fibonacci)
    func caminosUnicos(_ m: Int, _ n: Int) -> Int {
        var cache: [String: Int] = [:]           // Cache: "filas,cols" -> resultado

        func caminos(_ filas: Int, _ cols: Int) -> Int {
            // Caso base: borde superior o izquierdo → un solo camino
            if filas == 1 || cols == 1 {
                return 1
            }

            // Verificar si ya está calculado
            let key = "\(filas),\(cols)"
            if let result = cache[key] {
                return result
            }

            // Recursión: caminos desde arriba + caminos desde la izquierda
            let result = caminos(filas - 1, cols) + caminos(filas, cols - 1)
            cache[key] = result                  // Guardar en cache
            return result
        }

        return caminos(m, n)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Parsear: filas,columnas
        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: filas,columnas (ej: 3,3)")
        }

        guard let filas = Int(components[0]), let columnas = Int(components[1]) else {
            throw ExerciseError.invalidInput("Debes ingresar dos números enteros")
        }

        guard filas >= 1 && filas <= 20 else {
            throw ExerciseError.outOfRange("Las filas deben estar entre 1 y 20")
        }

        guard columnas >= 1 && columnas <= 20 else {
            throw ExerciseError.outOfRange("Las columnas deben estar entre 1 y 20")
        }

        let resultado = caminosUnicos(filas, columnas)

        // Visualización de la cuadrícula
        let maxVisual = 8
        let mostrarCompleta = filas <= maxVisual && columnas <= maxVisual

        let grid: String
        if mostrarCompleta {
            grid = (0..<filas).map { fila in
                (0..<columnas).map { col in
                    if fila == 0 && col == 0 { return "S" }
                    if fila == filas - 1 && col == columnas - 1 { return "E" }
                    return "·"
                }.joined(separator: " ")
            }.joined(separator: "\n")
        } else {
            grid = """
            S · · · · ...
            · · · · · ...
            · · · · · ...
            : : : : :
            · · · · · · E

            (\(filas)×\(columnas) - demasiado grande para visualizar)
            """
        }

        return """
        CAMINOS ÚNICOS EN CUADRÍCULA
        ────────────────────────────
        Dimensiones: \(filas) × \(columnas)

        \(grid)

        S = Start (inicio)
        E = End (destino)
        Movimientos: solo ↓ y →

        Caminos únicos: \(resultado)
        """
    }
}

// MARK: - Ejercicio 27: Suma de Primos

struct Exercise27: ExecutableExercise {
    let exerciseId = 27

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let numeros = trimmed.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numeros.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números válidos separados por coma")
        }

        guard numeros.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 números permitidos")
        }

        guard numeros.allSatisfy({ $0 >= 1 && $0 <= 10000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre 1 y 10000")
        }

        // Usar filter y reduce como pide el enunciado
        let primos = numeros.filter { Exercise08.esPrimo($0) } // Sin duplicados: Set(numeros).filter { Exercise08.esPrimo($0) }
        let suma = primos.reduce(0, +)

        let arrayStr = numeros.map(String.init).joined(separator: ", ")
        let primosStr = primos.map(String.init).joined(separator: ", ")

        return "Array: [\(arrayStr)]\nPrimos: [\(primosStr)]\nSuma: \(suma)"
    }
}

// MARK: - Ejercicio 28: Rotación Array Izquierda (Funcional)

struct Exercise28: ExecutableExercise {
    let exerciseId = 28

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let parts = trimmed.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: array|k (ejemplo: 1,2,3,4,5|2)")
        }

        let numeros = parts[0].split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard !numeros.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números válidos")
        }

        guard numeros.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 elementos permitidos")
        }

        guard numeros.allSatisfy({ $0 >= -1000 && $0 <= 1000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        guard let k = Int(parts[1]) else {
            throw ExerciseError.invalidInput("k debe ser un número entero")
        }

        guard k >= 0 && k <= 100 else {
            throw ExerciseError.outOfRange("k debe estar entre 0 y 100")
        }

        // Estilo funcional: función pura que retorna nuevo array
        let rotado = rotarIzquierda(numeros, k)

        let originalStr = numeros.map(String.init).joined(separator: ", ")
        let rotadoStr = rotado.map(String.init).joined(separator: ", ")

        return "Original: [\(originalStr)]\nRotado \(k) izquierda: [\(rotadoStr)]"
    }

    // Función pura: no muta, retorna nuevo array
    private func rotarIzquierda(_ array: [Int], _ k: Int) -> [Int] {
        guard !array.isEmpty else { return [] }
        let efectivo = k % array.count
        return Array(array.dropFirst(efectivo) + array.prefix(efectivo))
    }
}

// MARK: - Ejercicio 29: Eliminar Caracteres Duplicados

struct Exercise29: ExecutableExercise {
    let exerciseId = 29

    @MainActor
    func execute(input: String) async throws -> String {
        let texto = input.trimmingCharacters(in: .whitespaces)

        guard !texto.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard texto.count <= 100 else {
            throw ExerciseError.outOfRange("Máximo 100 caracteres permitidos")
        }

        let resultado = eliminarDuplicados(texto)

        return "Original: \"\(texto)\"\nSin duplicados: \"\(resultado)\""
    }

    // Estilo funcional con reduce
    private func eliminarDuplicados(_ texto: String) -> String {
        var vistos = Set<Character>()
        return texto.reduce("") { resultado, caracter in
            if vistos.contains(caracter) {
                return resultado
            } else {
                vistos.insert(caracter)
                return resultado + String(caracter)
            }
        }
    }
}

// MARK: - Ejercicio 30: Cifrado César
// Reutiliza Basico_Exercise29 (misma lógica)
// E(x) = (x + k) mod 26 | D(x) = (x - k) mod 26

struct Exercise30: ExecutableExercise {
    let exerciseId = 30

    @MainActor
    func execute(input: String) async throws -> String {
        // Reutilizar la implementación de Básicos Exercise29
        let basico29 = Basico_Exercise29()
        return try await basico29.execute(input: input)
    }
}
