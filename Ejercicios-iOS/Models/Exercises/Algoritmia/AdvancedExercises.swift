//
//  AdvancedExercises.swift
//  EjerciciosAlgoritmia
//
//  Created by Juan Carlos on 6/12/25.
//

import Foundation

// MARK: - Ejercicio 31: Número de Armstrong
// Un número de Armstrong es igual a la suma de sus dígitos elevados a la potencia del número de dígitos.
// N = Σ dᵢᵐ donde m es el número de dígitos
// Ejemplo: 153 = 1³ + 5³ + 3³ = 1 + 125 + 27 = 153

struct Exercise31: ExecutableExercise {
    let exerciseId = 31

    /// Verifica si un número es de Armstrong usando reduce
    /// N = Σ dᵢᵐ (suma de dígitos elevados a la potencia del número de dígitos)
    func esArmstrong(_ number: Int) -> (calculation: String, sum: Int) {
        let digits = String(number).compactMap { $0.wholeNumberValue } // Obtener dígitos
        let power = digits.count  // Calcular potencia (número de dígitos)
        let sum = digits.reduce(0) { $0 + Int(pow(Double($1), Double(power))) }  // Sumar cada dígito elevado a la potencia
        let calculation = digits.map { "\($0)^\(power)" }.joined(separator: " + ") // Mostrar cálculo
        return (calculation, sum)
    }

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

        // Paso 3: Calcular Armstrong
        let result = esArmstrong(number)

        // Paso 4: Verificar si es Armstrong
        let isArmstrong = result.sum == number

        // Paso 5: Mostrar resultado
        return """
        \(result.calculation) = \(result.sum)
        \(number) \(isArmstrong ? "es" : "no es") número de Armstrong
        """
    }
}

// MARK: - Ejercicio 32: Prefijo Común Más Largo
// Dado un array de String, encuentra el prefijo común más largo entre ellos
// Ejemplo: ["flower", "flow", "flight"] → "fl"

struct Exercise32: ExecutableExercise {
    let exerciseId = 32

    /// Encuentra el prefijo común más largo usando métodos funcionales (reduce, zip, prefix, map)
    func prefijoComun(_ palabras: [String]) -> String {
        guard let primera = palabras.first else { return "" }

        return palabras.reduce(primera) { prefijo, palabra in
            String(zip(prefijo, palabra)
                .prefix { $0 == $1 }
                .map { $0.0 })
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear las palabras
        let palabras = input.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }

        // Paso 2: Validar que haya palabras
        guard !palabras.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 3: Validar cantidad (2-20 palabras)
        guard palabras.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 palabras")
        }

        guard palabras.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 palabras permitidas")
        }

        // Paso 4: Validar longitud de cada palabra (1-50 caracteres)
        guard palabras.allSatisfy({ !$0.isEmpty && $0.count <= 50 }) else {
            throw ExerciseError.outOfRange("Cada palabra debe tener entre 1 y 50 caracteres")
        }

        // Paso 5: Encontrar prefijo común
        let prefijo = prefijoComun(palabras)

        // Paso 6: Mostrar resultado
        let palabrasStr = palabras.joined(separator: ", ")

        if prefijo.isEmpty {
            return """
            Palabras: [\(palabrasStr)]
            Prefijo común: (ninguno)
            """
        } else {
            return """
            Palabras: [\(palabrasStr)]
            Prefijo común: "\(prefijo)"
            """
        }
    }
}

// MARK: - Ejercicio 33: Número Catalán (Recursivo)
// Fórmula del PDF: Cn = (2n)! / ((n+1)! × n!)
// Significado combinatorio: paréntesis válidos, árboles binarios, caminos, etc.

struct Exercise33: ExecutableExercise {
    let exerciseId = 33

    /// Factorial recursivo (usa Double para soportar hasta n=15)
    func factorial(_ n: Int) -> Double {
        n <= 1 ? 1 : Double(n) * factorial(n - 1)
    }

    /// Número Catalán usando la fórmula del PDF
    /// Cn = (2n)! / ((n+1)! × n!)
    func catalan(_ n: Int) -> Int {
        let numerador = factorial(2 * n)                      // (2n)!
        let denominador = factorial(n + 1) * factorial(n)     // (n+1)! × n!
        return Int(numerador / denominador)
    }

    /// Genera todas las combinaciones válidas de n pares de paréntesis
    func generarParentesis(_ n: Int) -> [String] {
        var resultado: [String] = []

        func backtrack(_ actual: String, _ abiertos: Int, _ cerrados: Int) {
            // Caso base: tenemos n pares completos
            if actual.count == n * 2 {
                resultado.append(actual)
                return
            }

            // Añadir '(' si quedan abiertos por usar
            if abiertos < n {
                backtrack(actual + "(", abiertos + 1, cerrados)
            }

            // Añadir ')' si hay abiertos sin cerrar
            if cerrados < abiertos {
                backtrack(actual + ")", abiertos, cerrados + 1)
            }
        }

        backtrack("", 0, 0)
        return resultado
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard let n = Int(trimmed) else {
            throw ExerciseError.invalidInput("Debes ingresar un número entero válido")
        }

        guard n >= 0 && n <= 13 else {
            throw ExerciseError.outOfRange("n debe estar entre 0 y 13")
        }

        let resultado = catalan(n)

        // Generar paréntesis (máximo 50 mostrados)
        var parentesisStr = ""
        if n >= 1 {
            let parentesis = generarParentesis(n)
            let limite = 50
            let mostrar = parentesis.count <= limite
                ? parentesis
                : Array(parentesis.prefix(limite))
            let lista = mostrar.enumerated()
                .map { "  \($0.offset + 1). \($0.element)" }
                .joined(separator: "\n")
            let truncado = parentesis.count > limite
                ? "\n  ... y \(parentesis.count - limite) más"
                : ""
            parentesisStr = "\n\nParéntesis válidos con \(n) pares (\(parentesis.count) total):\n\(lista)\(truncado)"
        }

        return """
        NÚMERO CATALÁN
        ──────────────
        Fórmula: Cn = (2n)! / ((n+1)! × n!)

        n = \(n)
        C\(n) = (2×\(n))! / ((\(n)+1)! × \(n)!)
        C\(n) = \(2*n)! / (\(n+1)! × \(n)!)
        C\(n) = \(resultado)\(parentesisStr)
        """
    }
}

// MARK: - Ejercicio 34: Apariciones Consecutivas
// Recorre un array y devuelve un diccionario con todas las rachas consecutivas de cada número
// Ejemplo: [1,1,1,2,2,3,1,1] → [1: [3,2], 2: [2], 3: [1]]

struct Exercise34: ExecutableExercise {
    let exerciseId = 34

    /// Cuenta las apariciones consecutivas de cada número
    /// Devuelve [número: [rachas]] - ej: [1: [3, 2], 2: [2], 3: [1]]
    func aparicionesConsecutivas(_ numeros: [Int]) -> [Int: [Int]] {
        guard !numeros.isEmpty else { return [:] }

        var resultado: [Int: [Int]] = [:]
        var actual = numeros[0]  // Número actual
        var contador = 1          // Contador de racha

        for i in 1..<numeros.count {
            if numeros[i] == actual {
                contador += 1  // Sigue la racha
            } else {
                // Racha terminó, guardar
                resultado[actual, default: []].append(contador)
                actual = numeros[i]
                contador = 1
            }
        }

        // Guardar última racha
        resultado[actual, default: []].append(contador)

        return resultado
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear los números
        let numeros = try input.split(separator: ",")
            .map { componente -> Int in
                let trimmed = componente.trimmingCharacters(in: .whitespaces)
                guard let numero = Int(trimmed) else {
                    throw ExerciseError.invalidInput("'\(trimmed)' no es un número válido")
                }
                return numero
            }

        // Paso 2: Validar que haya números
        guard !numeros.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 3: Validar cantidad (2-50 números)
        guard numeros.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 números")
        }

        guard numeros.count <= 50 else {
            throw ExerciseError.outOfRange("Máximo 50 números permitidos")
        }

        // Paso 4: Calcular apariciones consecutivas
        let resultado = aparicionesConsecutivas(numeros)

        // Paso 5: Formatear resultado
        let arrayStr = numeros.map(String.init).joined(separator: ", ")

        let detalles = resultado
            .sorted { $0.key < $1.key }
            .map { numero, rachas in
                let rachasStr = rachas.map(String.init).joined(separator: ", ")
                let veces = rachas.count == 1 ? "1 vez" : "\(rachas.count) veces"
                return "• \(numero): [\(rachasStr)] (\(veces))"
            }
            .joined(separator: "\n")

        // Paso 6: Mostrar resultado
        return """
        Array: [\(arrayStr)]

        Apariciones consecutivas:
        \(detalles)
        """
    }
}

// MARK: - Ejercicio 35: Inserción Binaria (Recursiva)
// Dado un array ordenado y un número objetivo, determina el índice donde insertar
// para conservar el orden, usando búsqueda binaria recursiva O(log n)
// f(izq, der) = izq si izq >= der, f(medio+1, der) o f(izq, medio) en otro caso

struct Exercise35: ExecutableExercise {
    let exerciseId = 35

    /// Encuentra el índice donde insertar el objetivo para mantener el orden
    /// Usa recurrencia: f(izq, der) depende de f(izq', der')
    func insercionBinaria(_ array: [Int], _ objetivo: Int, _ izq: Int, _ der: Int) -> Int {
        // Caso base: rango vacío
        if izq >= der {
            return izq
        }

        let medio = (izq + der) / 2

        if array[medio] < objetivo {
            return insercionBinaria(array, objetivo, medio + 1, der)  // Recursión derecha
        } else {
            return insercionBinaria(array, objetivo, izq, medio)      // Recursión izquierda
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear entrada (formato: array|objetivo)
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }

        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: números|objetivo (ej: 1,3,5,7|4)")
        }

        // Paso 2: Parsear el array
        let numeros = try parts[0].split(separator: ",").map { componente -> Int in
            let trimmed = componente.trimmingCharacters(in: .whitespaces)
            guard let numero = Int(trimmed) else {
                throw ExerciseError.invalidInput("'\(trimmed)' no es un número válido")
            }
            return numero
        }

        // Paso 3: Parsear el objetivo
        guard let objetivo = Int(parts[1]) else {
            throw ExerciseError.invalidInput("El objetivo debe ser un número entero")
        }

        // Paso 4: Validar que haya números
        guard !numeros.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 5: Validar cantidad (1-50 números)
        guard numeros.count <= 50 else {
            throw ExerciseError.outOfRange("Máximo 50 números permitidos")
        }

        // Paso 6: Ordenar el array (por si no está ordenado)
        let arrayOrdenado = numeros.sorted()

        // Paso 7: Encontrar posición de inserción (recursivo)
        let indice = insercionBinaria(arrayOrdenado, objetivo, 0, arrayOrdenado.count)

        // Paso 8: Crear array resultante (para mostrar)
        var arrayResultante = arrayOrdenado
        arrayResultante.insert(objetivo, at: indice)

        // Paso 9: Mostrar resultado
        let arrayStr = arrayOrdenado.map(String.init).joined(separator: ", ")
        let resultadoStr = arrayResultante.map(String.init).joined(separator: ", ")

        return """
        Array ordenado: [\(arrayStr)]
        Objetivo: \(objetivo)

        Índice de inserción: \(indice)

        Resultado: [\(resultadoStr)]
        """
    }
}

// MARK: - Ejercicio 36: Combinaciones de k en k
// Fórmula: C(n,k) = n! / (k! × (n-k)!)

struct Exercise36: ExecutableExercise {
    let exerciseId = 36

    /// Factorial recursivo con operador ternario
    func factorial(_ n: Int) -> Int {
        n <= 1 ? 1 : n * factorial(n - 1)
    }

    /// Fórmula del coeficiente binomial
    func coeficienteBinomial(_ n: Int, _ k: Int) -> Int {
        factorial(n) / (factorial(k) * factorial(n - k))
    }

    /// Genera combinaciones recursivamente
    /// Casos base necesarios para la recursión interna (no para input del usuario)
    func combinaciones(_ array: [Int], _ k: Int) -> [[Int]] {
        if k == 0 { return [[]] }        // Caso base: elegir 0 = combinación vacía
        if array.count < k { return [] } // Caso base: no hay suficientes elementos

        let primero = array[0]
        let resto = Array(array.dropFirst())

        let conPrimero = combinaciones(resto, k - 1).map { [primero] + $0 }
        let sinPrimero = combinaciones(resto, k)

        return conPrimero + sinPrimero
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Formato esperado: "1,2,3,4|2"
        let parts = trimmed.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: números|k (ej: 1,2,3,4|2)")
        }

        // Parsear array
        let numeros = try parts[0].split(separator: ",").map { componente -> Int in
            let str = componente.trimmingCharacters(in: .whitespaces)
            guard let num = Int(str) else {
                throw ExerciseError.invalidInput("'\(str)' no es un número válido")
            }
            return num
        }

        // Parsear k
        guard let k = Int(parts[1]) else {
            throw ExerciseError.invalidInput("'\(parts[1])' no es un valor válido para k")
        }

        let n = numeros.count

        // Validaciones
        guard n >= 1 && n <= 10 else {
            throw ExerciseError.outOfRange("n debe estar entre 1 y 10")
        }

        guard k >= 1 else {
            throw ExerciseError.outOfRange("k debe ser al menos 1")
        }

        guard k <= n else {
            throw ExerciseError.invalidInput("k (\(k)) no puede ser mayor que n (\(n))")
        }

        // Calcular
        let resultado = combinaciones(numeros, k)
        let total = coeficienteBinomial(n, k)

        // Formatear
        let arrayStr = numeros.map(String.init).joined(separator: ", ")
        let combinacionesStr = resultado.map { "[\($0.map(String.init).joined(separator: ", "))]" }.joined(separator: ", ")

        return """
        COMBINACIONES (n=\(n), k=\(k))
        ──────────────────────────────
        Array: [\(arrayStr)]

        Fórmula: C(\(n),\(k)) = \(n)! / (\(k)! × \(n - k)!) = \(total)
        Total generadas: \(resultado.count) ✓

        Combinaciones:
        \(combinacionesStr)
        """
    }
}

// MARK: - Ejercicio 37: Lista Enlazada - Inversión
// Define una estructura simple de lista enlazada y escribe una función recursiva para invertirla.
// Una lista enlazada es una estructura de datos donde cada elemento (nodo)
// contiene un valor y un puntero (referencia) al siguiente nodo.

/// Nodo de lista enlazada simple
private final class ListNode {
    var value: Int
    var next: ListNode?

    init(value: Int, next: ListNode? = nil) {
        self.value = value
        self.next = next
    }
}

struct Exercise37: ExecutableExercise {
    let exerciseId = 37

    /// Crea una lista enlazada a partir de un array de enteros
    private func crearLista(_ valores: [Int]) -> ListNode? {
        guard let primero = valores.first else { return nil }

        let cabeza = ListNode(value: primero)
        var actual = cabeza

        for valor in valores.dropFirst() {
            let nuevoNodo = ListNode(value: valor)
            actual.next = nuevoNodo
            actual = nuevoNodo
        }

        return cabeza
    }

    /// Invierte la lista enlazada de forma recursiva
    /// Caso base: lista vacía o un solo nodo → ya está invertida
    /// Recursión: invertir el resto, luego invertir la conexión actual
    private func invertirRecursivo(_ nodo: ListNode?) -> ListNode? {
        // Caso base: lista vacía o un solo nodo
        guard let actual = nodo, let siguiente = actual.next else {
            return nodo
        }

        // Recursión: invertir el resto de la lista
        let nuevaCabeza = invertirRecursivo(siguiente)

        // Invertir la conexión: el siguiente ahora apunta a mí
        siguiente.next = actual
        actual.next = nil  // Yo ahora soy el último

        return nuevaCabeza
    }

    /// Convierte la lista enlazada a String para visualización
    private func listaAString(_ nodo: ListNode?) -> String {
        var resultado: [String] = []
        var actual = nodo

        while let n = actual {
            resultado.append(String(n.value))
            actual = n.next
        }

        return resultado.joined(separator: " -> ") + " -> nil"
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear entrada
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 2: Convertir a array de enteros
        let numeros = try trimmed.split(separator: ",").map { componente -> Int in
            let str = componente.trimmingCharacters(in: .whitespaces)
            guard let num = Int(str) else {
                throw ExerciseError.invalidInput("'\(str)' no es un número válido")
            }
            return num
        }

        // Paso 3: Validar cantidad (2-20 números)
        guard numeros.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 números")
        }

        guard numeros.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 números permitidos")
        }

        // Paso 4: Validar rango (-1000 a 1000)
        guard numeros.allSatisfy({ (-1000...1000).contains($0) }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -1000 y 1000")
        }

        // Paso 5: Crear lista y guardar su representación
        let lista = crearLista(numeros)
        let strOriginal = listaAString(lista)

        // Paso 6: Invertir y guardar su representación
        let listaInvertida = invertirRecursivo(lista)
        let strInvertida = listaAString(listaInvertida)

        // Paso 7: Mostrar resultado
        return """
        LISTA ENLAZADA - INVERSIÓN RECURSIVA
        ─────────────────────────────────────

        Valores de entrada: [\(numeros.map(String.init).joined(separator: ", "))]

        Lista original:  \(strOriginal)
        Lista invertida: \(strInvertida)
        """
    }
}

// MARK: - Ejercicio 38: QuickSort Funcional
// QuickSort(A) = A,                                               si |A| <= 1
// QuickSort(A) = QuickSort({x ∈ A | x < p}) ∪ {p} ∪ QuickSort({x ∈ A | x >= p}), si |A| > 1

struct Exercise38: ExecutableExercise {
    let exerciseId = 38

    /// QuickSort puramente funcional usando filter (sin var, sin while)
    /// Traduce directamente la fórmula matemática:
    /// {x ∈ A | x < p} → filter { $0 < pivot }
    /// {x ∈ A | x >= p} → filter { $0 >= pivot }
    private func quickSort(_ array: [Int]) -> [Int] {
        // Caso base: |A| <= 1 → devolver A
        guard let pivot = array.first, array.count > 1 else {
            return array
        }

        // Caso recursivo: dividir y conquistar
        let rest = Array(array.dropFirst())
        let lesser = rest.filter { $0 < pivot }    // {x ∈ A | x < p}
        let greater = rest.filter { $0 >= pivot }  // {x ∈ A | x >= p}

        // QuickSort(menores) ∪ {pivote} ∪ QuickSort(mayores)
        return quickSort(lesser) + [pivot] + quickSort(greater)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Parsear números
        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let numbers = try components.map { component -> Int in
            guard let number = Int(component) else {
                throw ExerciseError.invalidInput("'\(component)' no es un numero valido")
            }
            return number
        }

        // Validar cantidad (2-20)
        guard numbers.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 numeros")
        }
        guard numbers.count <= 20 else {
            throw ExerciseError.outOfRange("Maximo 20 numeros permitidos")
        }

        // Validar rango (-1000 a 1000)
        guard numbers.allSatisfy({ (-1000...1000).contains($0) }) else {
            throw ExerciseError.outOfRange("Cada numero debe estar entre -1000 y 1000")
        }

        // Ejecutar QuickSort funcional
        let sorted = quickSort(numbers)

        return """
        Original: [\(numbers.map(String.init).joined(separator: ", "))]
        Ordenado: [\(sorted.map(String.init).joined(separator: ", "))]
        """
    }
}

// MARK: - Ejercicio 39: Algoritmo de Kadane (Recursión + Memoización)
// Encuentra el subarray contiguo con la suma máxima
// Fórmulas:
//   max_ending_here = max(aᵢ, max_ending_here + aᵢ)
//   max_so_far = max(max_so_far, max_ending_here)

struct Exercise39: ExecutableExercise {
    let exerciseId = 39

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Validar entrada
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Paso 2: Parsear array
        let numeros = trimmed.split(separator: ",").compactMap {
            Int($0.trimmingCharacters(in: .whitespaces))
        }

        guard !numeros.isEmpty else {
            throw ExerciseError.invalidInput("Ingresa números separados por coma")
        }

        guard numeros.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 números")
        }

        guard numeros.count <= 50 else {
            throw ExerciseError.outOfRange("Máximo 50 números permitidos")
        }

        guard numeros.allSatisfy({ $0 >= -10000 && $0 <= 10000 }) else {
            throw ExerciseError.outOfRange("Cada número debe estar entre -10000 y 10000")
        }

        // Paso 3: Aplicar Kadane
        let (suma, subarray) = kadane(numeros)

        // Paso 4: Formatear salida
        let arrayStr = numeros.map(String.init).joined(separator: ", ")
        let subarrayStr = subarray.map(String.init).joined(separator: ", ")

        return """
        ALGORITMO DE KADANE
        ───────────────────
        Array: [\(arrayStr)]

        Subarray con suma máxima: [\(subarrayStr)]
        Suma máxima: \(suma)
        """
    }

    /// Algoritmo de Kadane con recursión y memoización
    private func kadane(_ array: [Int]) -> (suma: Int, subarray: [Int]) {
        // Cache: i → max_ending_here en posición i
        var cache: [Int: Int] = [:]

        /// Recurrencia del enunciado:
        /// max_ending_here = max(aᵢ, max_ending_here + aᵢ)
        func maxEndingHere(_ i: Int) -> Int {
            // Caso base
            if i == 0 { return array[0] }

            // Memoización
            if let result = cache[i] { return result }

            // Fórmula: max_ending_here = max(aᵢ, max_ending_here + aᵢ)
            let ai = array[i]
            let result = max(ai, maxEndingHere(i - 1) + ai)

            cache[i] = result
            return result
        }

        // Fórmula: max_so_far = max(max_so_far, max_ending_here)
        var maxSoFar = Int.min
        var fin = 0

        for i in 0..<array.count {
            let maxHere = maxEndingHere(i)
            if maxHere > maxSoFar {
                maxSoFar = maxHere
                fin = i
            }
        }

        // Reconstruir subarray
        var inicio = fin
        var suma = array[fin]
        while inicio > 0 && suma < maxSoFar {
            inicio -= 1
            suma += array[inicio]
        }

        return (maxSoFar, Array(array[inicio...fin]))
    }
}

// MARK: - Ejercicio 40: Conversión a Base Arbitraria (Recursivo)
// Convierte un número decimal a cualquier base entre 2 y 16
// N = d₀ + d₁×b + d₂×b² + ... + dₘ×bᵐ

struct Exercise40: ExecutableExercise {
    let exerciseId = 40

    /// Convierte un dígito (0-15) a su representación en string
    /// 0-9 → "0"-"9", 10-15 → "A"-"F"
    func digito(_ n: Int) -> String {
        let digitos = "0123456789ABCDEF"
        let index = digitos.index(digitos.startIndex, offsetBy: n)
        return String(digitos[index])
    }

    /// Convierte un número a la base indicada usando recursión
    /// Caso base: numero < base → un solo dígito
    /// Recursión: convertir(cociente) + digito(resto)
    func convertirBase(_ numero: Int, _ base: Int) -> String {
        // Caso base: si el número es menor que la base, es un solo dígito
        if numero < base {
            return digito(numero)
        }

        // Recursión: convertir el cociente + añadir el resto
        let cociente = numero / base
        let resto = numero % base

        return convertirBase(cociente, base) + digito(resto)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: Parsear entrada (formato: número|base)
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }

        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: número|base (ej: 255|16)")
        }

        // Paso 2: Parsear el número
        guard let numero = Int(parts[0]) else {
            throw ExerciseError.invalidInput("El número debe ser un entero")
        }

        // Paso 3: Parsear la base
        guard let base = Int(parts[1]) else {
            throw ExerciseError.invalidInput("La base debe ser un entero")
        }

        // Paso 4: Validar número (positivo)
        guard numero >= 0 else {
            throw ExerciseError.outOfRange("El número debe ser >= 0")
        }

        // Paso 5: Validar base (2-16)
        guard base >= 2 && base <= 16 else {
            throw ExerciseError.outOfRange("La base debe estar entre 2 y 16")
        }

        // Paso 6: Convertir a la base (recursivo)
        let resultado = convertirBase(numero, base)

        // Paso 7: Mostrar resultado
        return """
        Número: \(numero) (base 10)
        Base destino: \(base)

        Resultado: \(resultado)
        """
    }
}

// MARK: - Ejercicio 41: Mínimo de Monedas (Coin Change)
// Fórmula del PDF:
// C(A) = 0,                      si A = 0
// C(A) = min{C(A - ci) + 1},     si A > 0

struct Exercise41: ExecutableExercise {
    let exerciseId = 41

    private let monedas = [200, 100, 50, 20, 10, 5, 2, 1]  // céntimos

    /// Implementación exacta de la fórmula del PDF usando DP
    /// C(A) = min{C(A - ci) + 1}
    func minimoMonedas(_ cantidad: Int) -> (minimo: Int, monedasUsadas: [Int]) {
        var dp = Array(repeating: Int.max, count: cantidad + 1)
        dp[0] = 0

        for c in 1...cantidad {
            for moneda in monedas where moneda <= c {
                if dp[c - moneda] != Int.max {
                    dp[c] = min(dp[c], dp[c - moneda] + 1)
                }
            }
        }

        // Reconstruir: busco qué moneda me lleva al valor correcto
        var monedasUsadas: [Int] = []
        var restante = cantidad
        while restante > 0 {
            for moneda in monedas where moneda <= restante {
                if dp[restante - moneda] == dp[restante] - 1 {
                    monedasUsadas.append(moneda)
                    restante -= moneda
                    break
                }
            }
        }

        return (dp[cantidad], monedasUsadas)
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard let cantidad = Int(trimmed) else {
            throw ExerciseError.invalidInput("Debes ingresar un número entero")
        }

        guard cantidad >= 1 && cantidad <= 10000 else {
            throw ExerciseError.outOfRange("La cantidad debe estar entre 1 y 10000 céntimos")
        }

        let resultado = minimoMonedas(cantidad)

        // Formatear las monedas usadas
        let monedasTexto = resultado.monedasUsadas
            .map { formatearMoneda($0) }
            .joined(separator: " + ")

        return """
        ═══════════════════════════════════════
               MÍNIMO DE MONEDAS
        ═══════════════════════════════════════

        Cantidad: \(formatearCantidad(cantidad))
        Monedas disponibles: 2€, 1€, 50c, 20c, 10c, 5c, 2c, 1c

        ───────────────────────────────────────
        Mínimo de monedas: \(resultado.minimo)
        ───────────────────────────────────────

        Solución: \(monedasTexto)

        ═══════════════════════════════════════
        """
    }

    private func formatearMoneda(_ centimos: Int) -> String {
        centimos >= 100 ? "\(centimos / 100)€" : "\(centimos)c"
    }

    private func formatearCantidad(_ centimos: Int) -> String {
        centimos >= 100 ? "\((Double(centimos) / 100.0).formatted(.number.precision(.fractionLength(2...2))))€" : "\(centimos) céntimos"
    }
}

// MARK: - Ejercicio 42: Paréntesis Válidos (Backtracking)
// Genera todas las combinaciones válidas de n pares de paréntesis
// Reutiliza generarParentesis() del Exercise33

struct Exercise42: ExecutableExercise {
    let exerciseId = 42

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard let n = Int(trimmed) else {
            throw ExerciseError.invalidInput("Debes ingresar un número entero válido")
        }

        guard n >= 1 && n <= 13 else {
            throw ExerciseError.outOfRange("n debe estar entre 1 y 13")
        }

        // Reutilizar función del ejercicio 33
        let combinaciones = Exercise33().generarParentesis(n)

        // Mostrar todas o limitar si son muchas
        let limite = 50
        let mostrar = combinaciones.count <= limite
            ? combinaciones
            : Array(combinaciones.prefix(limite))

        let lista = mostrar.enumerated()
            .map { "  \($0.offset + 1). \($0.element)" }
            .joined(separator: "\n")

        let truncado = combinaciones.count > limite
            ? "\n  ... y \(combinaciones.count - limite) más"
            : ""

        return """
        PARÉNTESIS VÁLIDOS (Backtracking)
        ──────────────────────────────────
        n = \(n) pares

        Total combinaciones: \(combinaciones.count) (= C\(n))

        Combinaciones:
        \(lista)\(truncado)
        """
    }
}

// MARK: - Ejercicio 43: Mediana
// Fórmula del PDF:
// Mediana(X) = X[(n+1)/2],                    si n es impar
// Mediana(X) = (X[n/2] + X[n/2 + 1]) / 2,     si n es par

struct Exercise43: ExecutableExercise {
    let exerciseId = 43

    /// Calcula la mediana usando la fórmula del PDF
    /// Los índices del PDF empiezan en 1, Swift en 0 (restamos 1)
    func mediana(_ numeros: [Double]) -> Double {
        let X = numeros.sorted()  // Método funcional
        let n = X.count

        return n % 2 == 1
            ? X[(n + 1) / 2 - 1]           // X[(n+1)/2]
            : (X[n/2 - 1] + X[n/2]) / 2    // (X[n/2] + X[n/2+1]) / 2
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Parsear números separados por comas
        let components = trimmed.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        let numeros = try components.map { component -> Double in
            guard let number = Double(component) else {
                throw ExerciseError.invalidInput("'\(component)' no es un número válido")
            }
            return number
        }

        // Validar cantidad de elementos (1-50)
        guard numeros.count >= 1 else {
            throw ExerciseError.invalidInput("Ingresa al menos 1 número")
        }

        guard numeros.count <= 50 else {
            throw ExerciseError.outOfRange("Máximo 50 números permitidos")
        }

        // Validar rango de valores (-10000 a 10000)
        guard numeros.allSatisfy({ $0 >= -10000 && $0 <= 10000 }) else {
            throw ExerciseError.outOfRange("Los valores deben estar entre -10000 y 10000")
        }

        // Calcular mediana (sorted() está dentro de la función)
        let resultado = mediana(numeros)

        // Formatear salida
        let arrayStr = numeros.map { $0.formatted() }.joined(separator: ", ")
        let ordenadoStr = numeros.sorted().map { $0.formatted() }.joined(separator: ", ")
        let n = numeros.count

        let resultadoStr = resultado.formatted()

        return """
        MEDIANA
        ───────
        Array original: [\(arrayStr)]
        Array ordenado: [\(ordenadoStr)]
        n = \(n) (\(n % 2 == 1 ? "impar" : "par"))

        Mediana = \(resultadoStr)
        """
    }
}

// MARK: - Ejercicio 44: Distancia de Levenshtein (Recursión + Memoización)
// D(i,j) = max(i,j) si min(i,j) = 0
// D(i,j) = min(D(i-1,j)+1, D(i,j-1)+1, D(i-1,j-1)+δ) en otro caso
// δ(a,b) = 0 si a=b, 1 si a≠b

struct Exercise44: ExecutableExercise {
    let exerciseId = 44

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

        let distance = levenshteinMemoizado(Array(s1), Array(s2))

        return """
        Palabra 1: "\(s1)"
        Palabra 2: "\(s2)"
        Distancia de Levenshtein: \(distance)
        (recursión con memoización)
        """
    }

    /// Calcula Levenshtein usando recursión con memoización (estilo diccionario)
    func levenshteinMemoizado(_ s1: [Character], _ s2: [Character]) -> Int {
        let m = s1.count
        let n = s2.count

        // Cache para memoización: clave "i,j" → distancia calculada
        var cache: [String: Int] = [:]

        // Función recursiva con memoización
        func D(_ i: Int, _ j: Int) -> Int {
            // Caso base: si alguna cadena está vacía
            if min(i, j) == 0 {
                return max(i, j)
            }

            // Verificar si ya está en cache
            let key = "\(i),\(j)"
            if let result = cache[key] {
                return result
            }

            // Calcular δ(si, tj): 0 si iguales, 1 si diferentes
            let delta = s1[i - 1] == s2[j - 1] ? 0 : 1

            // D(i,j) = min(eliminación, inserción, sustitución)
            let result = min(
                D(i - 1, j) + 1,           // eliminación
                D(i, j - 1) + 1,           // inserción
                D(i - 1, j - 1) + delta    // sustitución (o nada si iguales)
            )

            // Guardar en cache
            cache[key] = result
            return result
        }

        return D(m, n)
    }
}

// MARK: - Ejercicio 45: Mini Intérprete Aritmético
// Evalúa expresiones respetando precedencia:
// 1ª Agrupación: (), [], {}
// 2ª Potencias y Raíces: ^, sqrt()
// 3ª Multiplicación/División: *, /
// 4ª Suma/Resta: +, -
//
// Recursive Descent Parsing:
// Expresión = Término (('+' | '-') Término)*
// Término   = Potencia (('*' | '/') Potencia)*
// Potencia  = Factor ('^' Potencia)?          (asociativo por derecha)
// Factor    = Número | '(' Expr ')' | '[' Expr ']' | '{' Expr '}' | 'sqrt(' Expr ')'

struct Exercise45: ExecutableExercise {
    let exerciseId = 45

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard trimmed.count <= 100 else {
            throw ExerciseError.outOfRange("La expresion debe tener maximo 100 caracteres")
        }

        // Validar caracteres permitidos
        let caracteresValidos = Set("0123456789+-*/^()[]{}. sqrtSQRT")
        guard trimmed.allSatisfy({ caracteresValidos.contains($0) }) else {
            throw ExerciseError.invalidInput("Caracteres no permitidos. Usa: numeros, +, -, *, /, ^, (), [], {}, sqrt()")
        }

        // Tokenizar
        var tokenizer = Tokenizer(input: trimmed)
        let tokens = try tokenizer.tokenize()
        let tokensStr = tokens.map { $0.description }.joined(separator: " ")

        // Parsear y evaluar
        var parser = ArithmeticParser(tokens: tokens)
        let resultado = try parser.parseExpression()

        // Verificar que se consumió toda la entrada
        if parser.pos < tokens.count {
            throw ExerciseError.invalidFormat("Expresion mal formada cerca de '\(tokens[parser.pos])'")
        }

        // Formatear resultado
        func formatNum(_ n: Double) -> String {
            n.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", n) : String(format: "%.4g", n)
        }
        let resultadoStr = formatNum(resultado)

        // Formatear pasos del análisis sintáctico
        let pasosStr = parser.pasos.isEmpty ? "  (expresión simple)" : parser.pasos.map { "  \($0)" }.joined(separator: "\n")

        return """
        MINI INTÉRPRETE ARITMÉTICO
        ──────────────────────────
        Expresión: \(trimmed)

        Tokens: \(tokensStr)

        Análisis sintáctico:
        \(pasosStr)

        Precedencia aplicada:
          1º ()[]{}  Agrupación
          2º ^ sqrt  Potencias y raíces
          3º * /     Multiplicación y división
          4º + -     Suma y resta

        Resultado: \(resultadoStr)
        """
    }
}

// MARK: - Token

private enum Token: CustomStringConvertible {
    case number(Double)
    case op(Character)        // +, -, *, /, ^
    case lparen(Character)    // (, [, {
    case rparen(Character)    // ), ], }
    case sqrt

    var description: String {
        switch self {
        case .number(let n):
            return n.truncatingRemainder(dividingBy: 1) == 0 ? "[\(Int(n))]" : "[\(n)]"
        case .op(let c): return "[\(c)]"
        case .lparen(let c): return "[\(c)]"
        case .rparen(let c): return "[\(c)]"
        case .sqrt: return "[sqrt]"
        }
    }
}

// MARK: - Tokenizer

private struct Tokenizer {
    let input: String
    var pos: String.Index

    init(input: String) {
        self.input = input
        self.pos = input.startIndex
    }

    mutating func tokenize() throws -> [Token] {
        var tokens: [Token] = []

        while pos < input.endIndex {
            let char = input[pos]

            if char.isWhitespace {
                advance()
            } else if char.isNumber || (char == "." && peek(1)?.isNumber == true) {
                tokens.append(try parseNumber())
            } else if "+-*/^".contains(char) {
                tokens.append(.op(char))
                advance()
            } else if "([{".contains(char) {
                tokens.append(.lparen(char))
                advance()
            } else if ")]}".contains(char) {
                tokens.append(.rparen(char))
                advance()
            } else if char.lowercased() == "s" {
                // Intentar leer "sqrt"
                if readWord("sqrt") {
                    tokens.append(.sqrt)
                } else {
                    throw ExerciseError.invalidInput("Caracter inesperado: '\(char)'")
                }
            } else {
                throw ExerciseError.invalidInput("Caracter inesperado: '\(char)'")
            }
        }

        return tokens
    }

    mutating func parseNumber() throws -> Token {
        var numStr = ""

        while pos < input.endIndex && (input[pos].isNumber || input[pos] == ".") {
            numStr.append(input[pos])
            advance()
        }

        guard let number = Double(numStr) else {
            throw ExerciseError.invalidInput("Numero invalido: '\(numStr)'")
        }

        return .number(number)
    }

    mutating func readWord(_ word: String) -> Bool {
        let start = pos
        for char in word.lowercased() {
            guard pos < input.endIndex && input[pos].lowercased() == String(char) else {
                pos = start
                return false
            }
            advance()
        }
        return true
    }

    func peek(_ offset: Int) -> Character? {
        guard let idx = input.index(pos, offsetBy: offset, limitedBy: input.endIndex) else { return nil }
        return idx < input.endIndex ? input[idx] : nil
    }

    mutating func advance() {
        pos = input.index(after: pos)
    }
}

// MARK: - Parser Aritmético (Recursive Descent)

private struct ArithmeticParser {
    let tokens: [Token]
    var pos: Int = 0
    var pasos: [String] = []

    private func formatNum(_ n: Double) -> String {
        n.truncatingRemainder(dividingBy: 1) == 0
            ? Int(n).formatted()
            : n.formatted(.number.precision(.fractionLength(0...4)))
    }

    /// Expresión = Término (('+' | '-') Término)*
    mutating func parseExpression() throws -> Double {
        var result = try parseTerm()

        while pos < tokens.count {
            if case .op(let c) = current(), c == "+" {
                advance()
                let right = try parseTerm()
                pasos.append("\(formatNum(result)) + \(formatNum(right)) = \(formatNum(result + right))")
                result += right
            } else if case .op(let c) = current(), c == "-" {
                advance()
                let right = try parseTerm()
                pasos.append("\(formatNum(result)) - \(formatNum(right)) = \(formatNum(result - right))")
                result -= right
            } else {
                break
            }
        }
        return result
    }

    /// Término = Potencia (('*' | '/') Potencia)*
    mutating func parseTerm() throws -> Double {
        var result = try parsePower()

        while pos < tokens.count {
            if case .op(let c) = current(), c == "*" {
                advance()
                let right = try parsePower()
                pasos.append("\(formatNum(result)) * \(formatNum(right)) = \(formatNum(result * right))")
                result *= right
            } else if case .op(let c) = current(), c == "/" {
                advance()
                let divisor = try parsePower()
                guard divisor != 0 else {
                    throw ExerciseError.invalidInput("Division por cero")
                }
                pasos.append("\(formatNum(result)) / \(formatNum(divisor)) = \(formatNum(result / divisor))")
                result /= divisor
            } else {
                break
            }
        }
        return result
    }

    /// Potencia = Factor ('^' Potencia)?  (asociativo por derecha)
    mutating func parsePower() throws -> Double {
        let base = try parseFactor()

        if case .op(let c) = current(), c == "^" {
            advance()
            let exponente = try parsePower()  // Recursión para asociatividad derecha
            let resultado = pow(base, exponente)
            pasos.append("\(formatNum(base)) ^ \(formatNum(exponente)) = \(formatNum(resultado))")
            return resultado
        }

        return base
    }

    /// Factor = Número | '(' Expr ')' | '[' Expr ']' | '{' Expr '}' | 'sqrt(' Expr ')'
    mutating func parseFactor() throws -> Double {
        // Manejar signo negativo unario
        if case .op(let c) = current(), c == "-" {
            advance()
            return -(try parseFactor())
        }

        // Manejar signo positivo unario (ignorar, es redundante)
        if case .op(let c) = current(), c == "+" {
            advance()
            return try parseFactor()
        }

        // sqrt(expr)
        if case .sqrt = current() {
            advance()
            guard case .lparen(let p) = current(), p == "(" else {
                throw ExerciseError.invalidFormat("Se esperaba '(' despues de sqrt")
            }
            advance()
            let valor = try parseExpression()
            guard case .rparen(let p) = current(), p == ")" else {
                throw ExerciseError.invalidFormat("Falta ')' para cerrar sqrt")
            }
            advance()
            guard valor >= 0 else {
                throw ExerciseError.invalidInput("No se puede calcular raiz de numero negativo")
            }
            let resultado = Foundation.sqrt(valor)
            pasos.append("sqrt(\(formatNum(valor))) = \(formatNum(resultado))")
            return resultado
        }

        // Agrupadores: (), [], {}
        if case .lparen(let open) = current() {
            advance()
            let result = try parseExpression()
            let expectedClose: Character = open == "(" ? ")" : (open == "[" ? "]" : "}")
            guard case .rparen(let close) = current(), close == expectedClose else {
                throw ExerciseError.invalidFormat("Falta '\(expectedClose)' para cerrar '\(open)'")
            }
            advance()
            return result
        }

        // Número
        if case .number(let n) = current() {
            advance()
            return n
        }

        throw ExerciseError.invalidFormat("Se esperaba un numero o expresion")
    }

    // MARK: - Helpers

    func current() -> Token {
        pos < tokens.count ? tokens[pos] : .op("\0")
    }

    mutating func advance() {
        pos += 1
    }
}
