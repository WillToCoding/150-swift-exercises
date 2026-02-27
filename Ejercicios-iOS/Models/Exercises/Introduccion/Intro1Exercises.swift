//
//  Intro1Exercises.swift
//  EjerciciosAlgoritmia
//
//  Introducción I - Ejercicios 1-20
//  Nivel: Iniciación
//  Enfoque: Diagramas de flujo, pseudocódigo, fundamentos
//

import Foundation

// MARK: - Ejercicio 1: Suma de Dos Números
// Pseudocódigo: Validar ambos números (1-99), luego sumar

struct IntroI_Exercise01: ExecutableExercise {
    let exerciseId = 1

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer los dos números
        let numbers = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard numbers.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa dos números separados por coma")
        }

        let firstNumber = numbers[0]
        let secondNumber = numbers[1]

        // Paso 4: Validar firstNumber (> 0 y <= 99)
        guard firstNumber > 0 && firstNumber <= 99 else {
            throw ExerciseError.outOfRange("El primer número debe estar entre 1 y 99")
        }

        // Paso 7: Validar secondNumber (> 0 y <= 99)
        guard secondNumber > 0 && secondNumber <= 99 else {
            throw ExerciseError.outOfRange("El segundo número debe estar entre 1 y 99")
        }

        // Paso 8: Calcular resultado = firstNumber + secondNumber
        let resultado = firstNumber + secondNumber

        // Paso 9: Mostrar resultado
        return "\(formatNumber(firstNumber)) + \(formatNumber(secondNumber)) = \(formatNumber(resultado))"
    }

    private func formatNumber(_ n: Double) -> String {
        n.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(n)) : String(n)
    }
}

// MARK: - Ejercicio 2: Celsius a Fahrenheit
// Pseudocódigo: Validar celsius (0-100), aplicar fórmula F = C × 9/5 + 32

struct IntroI_Exercise02: ExecutableExercise {
    let exerciseId = 2

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer celsius
        guard let celsius = Double(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número válido")
        }

        // Paso 4: Validar celsius (> 0 y <= 100)
        guard celsius > 0 && celsius <= 100 else {
            throw ExerciseError.outOfRange("Los grados Celsius deben estar entre 1 y 100")
        }

        // Paso 5: Declarar variable fahrenheit
        var fahrenheit: Double

        // Paso 6: Calcular fahrenheit = celsius × 9/5 + 32
        fahrenheit = celsius * (9.0 / 5.0) + 32.0

        // Paso 7: Mostrar resultado
        return "\(formatNumber(celsius))°C × 9/5 + 32 = \(fahrenheit.formatted(.number.precision(.fractionLength(2))))°F"
    }

    private func formatNumber(_ n: Double) -> String {
        n.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(n)) : String(n)
    }
}

// MARK: - Ejercicio 3: Área de Triángulo
// Pseudocódigo: Validar base (1-10), validar altura (1-10), calcular área = (base × altura) / 2

struct IntroI_Exercise03: ExecutableExercise {
    let exerciseId = 3

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer base y altura
        let values = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard values.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa base y altura separados por coma")
        }

        let base = values[0]
        let altura = values[1]

        // Paso 4: Validar base (> 0 y <= 10)
        guard base > 0 && base <= 10 else {
            throw ExerciseError.outOfRange("La base debe estar entre 1 y 10")
        }

        // Paso 7: Validar altura (> 0 y <= 10)
        guard altura > 0 && altura <= 10 else {
            throw ExerciseError.outOfRange("La altura debe estar entre 1 y 10")
        }

        // Paso 8: Declarar variable area
        var area: Double

        // Paso 9: Calcular area = (base × altura) / 2
        area = (base * altura) / 2.0

        // Paso 10: Mostrar resultado
        return "(\(formatNumber(base)) × \(formatNumber(altura))) / 2 = \(formatNumber(area))"
    }

    private func formatNumber(_ n: Double) -> String {
        n.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(n)) : String(n)
    }
}

// MARK: - Ejercicio 4: Par o Impar
// Pseudocódigo: Validar number (1-99), calcular módulo 2, if/else para resultado

struct IntroI_Exercise04: ExecutableExercise {
    let exerciseId = 4

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer number
        guard let number = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar number (> 0 y <= 99)
        guard number > 0 && number <= 99 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 99")
        }

        // Paso 5-6: Declarar y calcular resultado = number % 2
        let resultado = number % 2

        // Paso 7: Si resultado == 0
        if resultado == 0 {
            // Paso 8: Mostrar "Es par"
            return "\(number) es par"
        } else {
            // Paso 9: Mostrar "Es impar"
            return "\(number) es impar"
        }
        // Paso 10: FIN
    }
}

// MARK: - Ejercicio 5: Aprobado o Suspenso
// Pseudocódigo: Validar nota (0-10), if nota >= 5 entonces Aprobado, sino Suspenso

struct IntroI_Exercise05: ExecutableExercise {
    let exerciseId = 5

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer nota
        guard let nota = Double(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa una calificación válida")
        }

        // Paso 4: Validar nota (>= 0 y <= 10)
        guard nota >= 0 && nota <= 10 else {
            throw ExerciseError.outOfRange("La calificación debe estar entre 0 y 10")
        }

        // Paso 5: Si nota >= 5
        if nota >= 5 {
            // Paso 6: Mostrar "Aprobado"
            return "Aprobado ✓"
        } else {
            // Paso 7: Mostrar "Suspenso"
            return "Suspenso ✗"
        }
        // Paso 8: FIN
    }
}

// MARK: - Ejercicio 5.2: Aprobado o Suspenso (Nota de Corte)
// Pseudocódigo: Validar nota (0-10), validar corte (5-10), if nota >= corte entonces Aprobado

struct IntroI_Exercise05_2: ExecutableExercise {
    let exerciseId = 5 // Base ID for matching

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer nota y corte
        let components = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        guard components.count == 2,
              let nota = Double(components[0]),
              let corte = Double(components[1]) else {
            throw ExerciseError.invalidFormat("Ingresa nota y nota de corte separadas por coma (ej: 6.5, 7)")
        }

        // Paso 4: Validar nota (>= 0 y <= 10)
        guard nota >= 0 && nota <= 10 else {
            throw ExerciseError.outOfRange("La calificación debe estar entre 0 y 10")
        }

        // Paso 7: Validar corte (>= 5 y <= 10)
        guard corte >= 5 && corte <= 10 else {
            throw ExerciseError.outOfRange("La nota de corte debe estar entre 5 y 10")
        }

        // Paso 8: Si nota >= corte
        if nota >= corte {
            // Paso 9: Mostrar "Aprobado"
            return "\(formatNumber(nota)) con nota de corte \(formatNumber(corte)): Aprobado ✓"
        } else {
            // Paso 10: Mostrar "Suspenso"
            return "\(formatNumber(nota)) con nota de corte \(formatNumber(corte)): Suspenso ✗"
        }
        // Paso 11: FIN
    }

    private func formatNumber(_ n: Double) -> String {
        n.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(n)) : String(n)
    }
}

// MARK: - Ejercicio 6: Positivo, Negativo o Cero
// Pseudocódigo: Leer number, if > 0 positivo, elif = 0 cero, else negativo

struct IntroI_Exercise06: ExecutableExercise {
    let exerciseId = 6

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer number
        guard let number = Double(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número válido")
        }

        // Paso 4: Si number > 0
        if number > 0 {
            // Paso 5: Mostrar "Es positivo"
            return "El número es positivo"
        } else {
            // Paso 6: Si number == 0
            if number == 0 {
                // Paso 7: Mostrar "Es cero"
                return "El número es cero"
            } else {
                // Paso 8: Mostrar "Es negativo"
                return "El número es negativo"
            }
        }
        // Paso 9: FIN
    }
}

// MARK: - Ejercicio 7: Primeros 10 Números Naturales
// Pseudocódigo: number = 1, while number <= 10: mostrar, incrementar

struct IntroI_Exercise07: ExecutableExercise {
    let exerciseId = 7

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2: Variable number = 1
        var number = 1
        var result: [String] = []

        // Paso 3: Si number <= 10
        while number <= 10 {
            // Paso 4: Mostrar "number"
            result.append(String(number))

            // Paso 5: Calcular number = number + 1
            number = number + 1

            // Volver a 3 (implícito en while)
        }

        // Paso 6: FIN - Mostrar todos los números
        return result.joined(separator: ", ")
    }
}

// MARK: - Ejercicio 8: Suma de Primeros N Números
// Pseudocódigo: Validar number (1-100), contador = 1, suma = 0, while contador <= number

struct IntroI_Exercise08: ExecutableExercise {
    let exerciseId = 8

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer number
        guard let number = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar number (>= 1 y <= 100)
        guard number >= 1 && number <= 100 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 100")
        }

        // Paso 5: Variable contador = 1
        var contador = 1

        // Paso 6: Variable suma = 0
        var suma = 0

        // Paso 7: Si contador <= number
        while contador <= number {
            // Paso 8: Calcular suma = suma + contador
            suma = suma + contador

            // Paso 9: Calcular contador = contador + 1
            contador = contador + 1

            // Paso 10: Volver a 7 (implícito en while)
        }

        // Paso 11: Mostrar "suma"
        return "Suma de los primeros \(number) números: \(suma)"
    }
}

// MARK: - Ejercicio 9: Fibonacci (10 términos)
// Pseudocódigo: anterior=0, actual=1, contador=1, siguiente=0, while contador <= 10

struct IntroI_Exercise09: ExecutableExercise {
    let exerciseId = 9

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2: Variable anterior = 0
        var anterior = 0

        // Paso 3: Variable actual = 1
        var actual = 1

        // Paso 4: Variable contador = 1
        var contador = 1

        // Paso 5: Variable siguiente = 0
        var siguiente = 0

        var result: [String] = []

        // Paso 6: Si contador <= 10
        while contador <= 10 {
            // Paso 7: Mostrar "anterior"
            result.append(String(anterior))

            // Paso 8: Calcular siguiente = anterior + actual
            siguiente = anterior + actual

            // Paso 9: Calcular anterior = actual
            anterior = actual

            // Paso 10: Calcular actual = siguiente
            actual = siguiente

            // Paso 11: Calcular contador = contador + 1
            contador = contador + 1

            // Paso 12: Volver a 6 (implícito en while)
        }

        // Paso 13: FIN - Mostrar todos los términos
        return result.joined(separator: ", ")
    }
}

// MARK: - Ejercicio 10: Factorial
// Pseudocódigo: Validar (>= 0 y <= 20), acumuladorProducto=1, siguienteNumero=n, while >= 1 multiplicar y decrementar

struct IntroI_Exercise10: ExecutableExercise {
    let exerciseId = 10

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer numeroIntroducido
        guard let numeroIntroducido = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar (>= 0 y <= 20)
        guard numeroIntroducido >= 0 && numeroIntroducido <= 20 else {
            throw ExerciseError.outOfRange("El número debe estar entre 0 y 20")
        }

        // Paso 5: Variable acumuladorProducto = 1
        var acumuladorProducto = 1

        // Paso 6: Variable siguienteNumero = numeroIntroducido
        var siguienteNumero = numeroIntroducido

        // Paso 7: Si siguienteNumero >= 1
        while siguienteNumero >= 1 {
            // Paso 8: acumuladorProducto = acumuladorProducto × siguienteNumero
            acumuladorProducto = acumuladorProducto * siguienteNumero

            // Paso 9: siguienteNumero = siguienteNumero - 1
            siguienteNumero = siguienteNumero - 1

            // Paso 10: Volver a 7 (implícito en while)
        }

        // Paso 11: Mostrar acumuladorProducto
        return "\(numeroIntroducido)! = \(acumuladorProducto)"
    }
}

// MARK: - Ejercicio 11: Suma de Pares
// Pseudocódigo: Validar >= 1, sumaDePares=0, numeroEnCurso=1, while <= N, si MOD 2 == 0 sumar

struct IntroI_Exercise11: ExecutableExercise {
    let exerciseId = 11

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer limiteSuperiorN
        guard let limiteSuperiorN = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar (>= 1 o <= 100) - "o" se usa como "y" en la academia
        guard limiteSuperiorN >= 1 && limiteSuperiorN <= 100 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 100")
        }

        // Paso 5: Variable sumaDePares = 0
        var sumaDePares = 0

        // Paso 6: Variable numeroEnCurso = 1
        var numeroEnCurso = 1

        // Paso 7: Si numeroEnCurso <= limiteSuperiorN
        while numeroEnCurso <= limiteSuperiorN {
            // Paso 8: Si numeroEnCurso MOD 2 == 0
            if numeroEnCurso % 2 == 0 {
                // Paso 9: sumaDePares = sumaDePares + numeroEnCurso
                sumaDePares = sumaDePares + numeroEnCurso
            }
            // Paso 10-11: numeroEnCurso = numeroEnCurso + 1
            numeroEnCurso = numeroEnCurso + 1
            // Paso 12: Volver a 7 (implícito en while)
        }

        // Paso 13: Mostrar sumaDePares
        return "Suma de pares entre 1 y \(limiteSuperiorN): \(sumaDePares)"
    }
}

// MARK: - Ejercicio 12: Suma de Impares
// Pseudocódigo: Validar >= 1 o <= 100, sumaDeImpares=0, numeroEnCurso=1, while <= N, si MOD 2 == 1 sumar

struct IntroI_Exercise12: ExecutableExercise {
    let exerciseId = 12

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer limiteSuperiorN
        guard let limiteSuperiorN = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar (>= 1 o <= 100) - "o" se usa como "y" en la academia
        guard limiteSuperiorN >= 1 && limiteSuperiorN <= 100 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 100")
        }

        // Paso 5: Variable sumaDeImpares = 0
        var sumaDeImpares = 0

        // Paso 6: Variable numeroEnCurso = 1
        var numeroEnCurso = 1

        // Paso 7: Si numeroEnCurso <= limiteSuperiorN
        while numeroEnCurso <= limiteSuperiorN {
            // Paso 8: Si numeroEnCurso MOD 2 == 1
            if numeroEnCurso % 2 == 1 {
                // Paso 9: sumaDeImpares = sumaDeImpares + numeroEnCurso
                sumaDeImpares = sumaDeImpares + numeroEnCurso
            }
            // Paso 10-12: numeroEnCurso = numeroEnCurso + 1
            numeroEnCurso = numeroEnCurso + 1
            // Paso 11/13: Volver a 7 (implícito en while)
        }

        // Paso 14: Mostrar sumaDeImpares
        return "Suma de impares entre 1 y \(limiteSuperiorN): \(sumaDeImpares)"
    }
}

// MARK: - Ejercicio 13: Número en Rango
// Pseudocódigo: Validar cotas y valor (1-100), intercambiar si cotaInferior > cotaSuperior, determinar si está en rango

struct IntroI_Exercise13: ExecutableExercise {
    let exerciseId = 13

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer cotaInferior, cotaSuperior, valorObjetivo
        let values = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard values.count == 3 else {
            throw ExerciseError.invalidInput("Ingresa: cotaInferior, cotaSuperior, valorObjetivo (separados por comas)")
        }

        var cotaInferior = values[0]
        var cotaSuperior = values[1]
        let valorObjetivo = values[2]

        // Paso 4-5: Validar cotaInferior (> 0 y <= 100)
        guard cotaInferior > 0 && cotaInferior <= 100 else {
            throw ExerciseError.outOfRange("La cota inferior debe estar entre 1 y 100")
        }

        // Paso 8-9: Validar cotaSuperior (> 0 y <= 100)
        guard cotaSuperior > 0 && cotaSuperior <= 100 else {
            throw ExerciseError.outOfRange("La cota superior debe estar entre 1 y 100")
        }

        // Paso 12-13: Validar valorObjetivo (> 0 y <= 100)
        guard valorObjetivo > 0 && valorObjetivo <= 100 else {
            throw ExerciseError.outOfRange("El valor objetivo debe estar entre 1 y 100")
        }

        // Paso 14-15: Si cotaInferior > cotaSuperior, intercambiar usando auxiliar
        if cotaInferior > cotaSuperior {
            let auxiliar = cotaInferior
            cotaInferior = cotaSuperior
            cotaSuperior = auxiliar
        }

        // Paso 17-18: Si valorObjetivo >= cotaInferior Y valorObjetivo <= cotaSuperior
        if valorObjetivo >= cotaInferior && valorObjetivo <= cotaSuperior {
            return "\(valorObjetivo) está dentro del rango [\(cotaInferior), \(cotaSuperior)]"
        } else {
            return "\(valorObjetivo) NO está dentro del rango [\(cotaInferior), \(cotaSuperior)]"
        }
        // Paso 19: FIN
    }
}

// MARK: - Ejercicio 14: Número Primo
// Pseudocódigo: Optimización 6k±1 para verificar primalidad

struct IntroI_Exercise14: ExecutableExercise {
    let exerciseId = 14

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer num
        guard let num = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar num > 0 y num <= 1,000,000,000
        guard num > 0 && num <= 1_000_000_000 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 1.000.000.000")
        }

        // Paso 5: Si num <= 3, es primo (según Leibniz, incluye 1)
        if num <= 3 {
            return "\(num) es primo"
        }

        // Paso 6: Si divisible por 2 o 3, no es primo
        if num % 2 == 0 || num % 3 == 0 {
            return "\(num) NO es primo"
        }

        // Paso 7: Variable i = 5
        var i = 5

        // Paso 8-11: Loop mientras (i × i) <= num
        while i * i <= num {
            // Paso 9: Si divisible por i o (i + 2), no es primo
            if num % i == 0 || num % (i + 2) == 0 {
                return "\(num) NO es primo"
            }
            // Paso 10: i = i + 6
            i = i + 6
            // Paso 11: Volver a 8 (implícito en while)
        }

        // Paso 12: Si sale del loop, es primo
        return "\(num) es primo"
        // Paso 14: FIN
    }
}

// MARK: - Ejercicio 15: Primos Menores que N
// Pseudocódigo: Usa DeterminarSiEsPrimo (Ejercicio 14) como subrutina

struct IntroI_Exercise15: ExecutableExercise {
    let exerciseId = 15

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer limiteSuperior
        guard let limiteSuperior = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar limiteSuperior >= 1 y <= 1,000,000
        guard limiteSuperior >= 1 && limiteSuperior <= 1_000_000 else {
            throw ExerciseError.outOfRange("El límite debe estar entre 1 y 1.000.000")
        }

        // Paso 5: Variable candidatoActual = 1 (Leibniz considera 1 primo)
        var candidatoActual = 1

        // Paso 6: Variable esPrimoActual = false
        var esPrimoActual = false

        // Array para almacenar los primos encontrados
        var primosEncontrados: [Int] = []

        // Paso 7-12: Loop mientras candidatoActual < limiteSuperior
        while candidatoActual < limiteSuperior {
            // Paso 8: esPrimoActual = DeterminarSiEsPrimo(candidatoActual)
            esPrimoActual = await determinarSiEsPrimo(candidatoActual)

            // Paso 9: Si esPrimoActual == true
            if esPrimoActual {
                // Paso 10: MOSTRAR "candidatoActual"
                primosEncontrados.append(candidatoActual)
                // Paso 11: candidatoActual = candidatoActual + 1
                candidatoActual = candidatoActual + 1
            } else {
                // Paso 12: candidatoActual = candidatoActual + 1
                candidatoActual = candidatoActual + 1
            }
            // Volver a 7 (implícito en while)
        }

        // Paso 13: FIN - Retornar resultado
        return primosEncontrados.isEmpty
            ? "No hay números primos menores que \(limiteSuperior)"
            : primosEncontrados.map { String($0) }.joined(separator: ", ")
    }

    // Subrutina: DeterminarSiEsPrimo - Usa Ejercicio 14
    private func determinarSiEsPrimo(_ num: Int) async -> Bool {
        let ejercicio14 = IntroI_Exercise14()
        do {
            let resultado = try await ejercicio14.execute(input: String(num))
            return resultado.contains("es primo") && !resultado.contains("NO")
        } catch {
            return false
        }
    }
}

// MARK: - Ejercicio 16: MCM
// Pseudocódigo: Algoritmo de Euclides para MCD, luego MCM = (a × b) / MCD

struct IntroI_Exercise16: ExecutableExercise {
    let exerciseId = 16

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-5: Leer primerNumero y segundoNumero
        let numbers = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard numbers.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa dos números separados por coma")
        }

        let primerNumero = numbers[0]
        let segundoNumero = numbers[1]

        // Paso 6: Validar primerNumero >= 1 y <= 100
        guard primerNumero >= 1 && primerNumero <= 100 else {
            throw ExerciseError.outOfRange("El primer número debe estar entre 1 y 100")
        }

        // Paso 7: Validar segundoNumero >= 1 y <= 100
        guard segundoNumero >= 1 && segundoNumero <= 100 else {
            throw ExerciseError.outOfRange("El segundo número debe estar entre 1 y 100")
        }

        // Paso 8-9: Copiar valores para el algoritmo de Euclides
        var a = primerNumero
        var b = segundoNumero

        // Paso 10-13: Algoritmo de Euclides (mientras b != 0)
        while b != 0 {
            // Paso 11: resto = a MOD b
            let resto = a % b
            // Paso 12: a = b
            a = b
            // Paso 13: b = resto
            b = resto
            // Volver a 10 (implícito en while)
        }

        // Paso 14: mcd = a
        let mcd = a

        // Paso 15: mcm = (primerNumero × segundoNumero) / mcd
        let mcm = (primerNumero * segundoNumero) / mcd

        // Paso 16: MOSTRAR "mcm"
        return "MCM(\(primerNumero), \(segundoNumero)) = \(mcm)"
        // Paso 17: FIN
    }
}

// MARK: - Ejercicio 17: MCD
// Pseudocódigo: Algoritmo de Euclides para encontrar el Máximo Común Divisor

struct IntroI_Exercise17: ExecutableExercise {
    let exerciseId = 17

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-5: Leer primerNumero y segundoNumero
        let numbers = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard numbers.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa dos números separados por coma")
        }

        let primerNumero = numbers[0]
        let segundoNumero = numbers[1]

        // Paso 6: Validar primerNumero >= 1 y <= 100
        guard primerNumero >= 1 && primerNumero <= 100 else {
            throw ExerciseError.outOfRange("El primer número debe estar entre 1 y 100")
        }

        // Paso 7: Validar segundoNumero >= 1 y <= 100
        guard segundoNumero >= 1 && segundoNumero <= 100 else {
            throw ExerciseError.outOfRange("El segundo número debe estar entre 1 y 100")
        }

        // Paso 8-9: Copiar valores para el algoritmo de Euclides
        var a = primerNumero
        var b = segundoNumero

        // Paso 10-13: Algoritmo de Euclides (mientras b != 0)
        while b != 0 {
            // Paso 11: resto = a MOD b
            let resto = a % b
            // Paso 12: a = b
            a = b
            // Paso 13: b = resto
            b = resto
            // Volver a 10 (implícito en while)
        }

        // Paso 14: mcd = a
        let mcd = a

        // Paso 15: MOSTRAR "mcd"
        return "MCD(\(primerNumero), \(segundoNumero)) = \(mcd)"
        // Paso 16: FIN
    }
}

// MARK: - Ejercicio 18: Pirámide de Asteriscos
// Pseudocódigo: Validar altura (1-20), calcular espacios y asteriscos por fila

struct IntroI_Exercise18: ExecutableExercise {
    let exerciseId = 18

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer altura
        guard let altura = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar altura >= 1 y altura <= 20
        guard altura >= 1 && altura <= 20 else {
            throw ExerciseError.outOfRange("La altura debe estar entre 1 y 20")
        }

        // Paso 5: filaActual = 1
        var filaActual = 1
        var pyramid = ""

        // Paso 6: Si filaActual <= altura
        while filaActual <= altura {
            // Paso 7: numEspacios = altura - filaActual
            let numEspacios = altura - filaActual

            // Paso 8: cantidadAsteriscos = (filaActual × 2) - 1
            let cantidadAsteriscos = (filaActual * 2) - 1

            // Paso 9: MOSTRAR espacios + asteriscos + nueva línea
            let espacios = String(repeating: " ", count: numEspacios)
            let asteriscos = String(repeating: "*", count: cantidadAsteriscos)
            pyramid += espacios + asteriscos + "\n"

            // Paso 10: filaActual = filaActual + 1
            filaActual = filaActual + 1

            // Volver a 6 (implícito en while)
        }

        // Paso 11: FIN
        return pyramid
    }
}

// MARK: - Ejercicio 19: Número Palíndromo
// Pseudocódigo: Invertir número dígito a dígito con MOD 10 y comparar con original

struct IntroI_Exercise19: ExecutableExercise {
    let exerciseId = 19

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: PREGUNTAR y Variable num = Respuesta
        guard var num = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Si (num >= 0 o num <= 999999999)
        guard num >= 0 && num <= 999999999 else {
            throw ExerciseError.outOfRange("El número debe estar entre 0 y 999.999.999")
        }

        // Paso 5: Variable numOriginal = num
        let numOriginal = num

        // Paso 6: Variable numInvertido = 0
        var numInvertido = 0

        // Paso 7: Si (num > 0)
        while num > 0 {
            // Paso 8: CÁLCULO ultimoDigito = num MOD 10
            let ultimoDigito = num % 10

            // Paso 9: CÁLCULO numInvertido = (numInvertido * 10) + ultimoDigito
            numInvertido = (numInvertido * 10) + ultimoDigito

            // Paso 10: CÁLCULO num = num / 10
            num = num / 10

            // Paso 11: Volver a 7 (implícito en while)
        }

        // Paso 12: Si (numOriginal == numInvertido)
        if numOriginal == numInvertido {
            // Paso 13: MOSTRAR "Es palíndromo"
            return "\(numOriginal) es palíndromo"
        } else {
            // Paso 14: MOSTRAR "No es palíndromo"
            return "\(numOriginal) NO es palíndromo"
        }
        // Paso 15: FIN
    }
}

// MARK: - Ejercicio 20: Distancia entre Puntos
// Pseudocódigo: Validar 4 coordenadas (-100 a 100), calcular deltaX, deltaY, aplicar sqrt (proceso predefinido)

struct IntroI_Exercise20: ExecutableExercise {
    let exerciseId = 20

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3, 5-6, 8-9, 11-12: Leer x₁, y₁, x₂, y₂
        let coords = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard coords.count == 4 else {
            throw ExerciseError.invalidInput("Ingresa: x1, y1, x2, y2 (separados por comas)")
        }

        let x1 = coords[0]
        let y1 = coords[1]
        let x2 = coords[2]
        let y2 = coords[3]

        // Paso 4: Si (x₁ >= -100 o x₁ <= 100)
        guard x1 >= -100 && x1 <= 100 else {
            throw ExerciseError.outOfRange("x₁ debe estar entre -100 y 100")
        }

        // Paso 7: Si (y₁ >= -100 o y₁ <= 100)
        guard y1 >= -100 && y1 <= 100 else {
            throw ExerciseError.outOfRange("y₁ debe estar entre -100 y 100")
        }

        // Paso 10: Si (x₂ >= -100 o x₂ <= 100)
        guard x2 >= -100 && x2 <= 100 else {
            throw ExerciseError.outOfRange("x₂ debe estar entre -100 y 100")
        }

        // Paso 13: Si (y₂ >= -100 o y₂ <= 100)
        guard y2 >= -100 && y2 <= 100 else {
            throw ExerciseError.outOfRange("y₂ debe estar entre -100 y 100")
        }

        // Paso 14: CÁLCULO deltaX = x₂ - x₁
        let deltaX = x2 - x1

        // Paso 15: CÁLCULO deltaY = y₂ - y₁
        let deltaY = y2 - y1

        // Paso 16: CÁLCULO distancia = sqrt((deltaX × deltaX) + (deltaY × deltaY))
        let distancia = sqrt((deltaX * deltaX) + (deltaY * deltaY))

        // Paso 17: MOSTRAR "distancia"
        return """
        Punto 1: (\(formatNumber(x1)), \(formatNumber(y1)))
        Punto 2: (\(formatNumber(x2)), \(formatNumber(y2)))
        Distancia: \(distancia.formatted(.number.precision(.fractionLength(2))))
        """
        // Paso 18: FIN
    }

    private func formatNumber(_ n: Double) -> String {
        n.truncatingRemainder(dividingBy: 1) == 0 ? String(Int(n)) : String(n)
    }
}
