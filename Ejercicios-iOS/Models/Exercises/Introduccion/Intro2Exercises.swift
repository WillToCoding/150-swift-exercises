//
//  Intro2Exercises.swift
//  EjerciciosAlgoritmia
//
//  Introducción II - Ejercicios 1-20
//  Nivel: Intermedio
//  Enfoque: Condicionales anidados, bucles anidados, algoritmos matemáticos
//

import Foundation

// MARK: - Ejercicio 1: Clasificación de Triángulo

struct IntroII_Exercise01: ExecutableExercise {
    let exerciseId = 1

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3, 5-6, 8-9: Leer los tres lados
        let sides = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard sides.count == 3 else {
            throw ExerciseError.invalidInput("Ingresa tres lados separados por comas")
        }

        let (lado1, lado2, lado3) = (sides[0], sides[1], sides[2])

        // Paso 4: Si (lado1 > 0 y lado1 <= 100)
        guard lado1 > 0 && lado1 <= 100 else {
            throw ExerciseError.outOfRange("lado1 debe estar entre 1 y 100")
        }

        // Paso 7: Si (lado2 > 0 y lado2 <= 100)
        guard lado2 > 0 && lado2 <= 100 else {
            throw ExerciseError.outOfRange("lado2 debe estar entre 1 y 100")
        }

        // Paso 10: Si (lado3 > 0 y lado3 <= 100)
        guard lado3 > 0 && lado3 <= 100 else {
            throw ExerciseError.outOfRange("lado3 debe estar entre 1 y 100")
        }

        // Paso 11: Si (lado1 == lado2 y lado2 == lado3)
        if lado1 == lado2 && lado2 == lado3 {
            // Paso 12: MOSTRAR "Equilátero"
            return "Equilátero"
        } else if lado1 == lado2 || lado2 == lado3 || lado1 == lado3 {
            // Paso 13-14: Si algún par es igual → "Isósceles"
            return "Isósceles"
        } else {
            // Paso 15: MOSTRAR "Escaleno"
            return "Escaleno"
        }
    }
}

// MARK: - Ejercicio 2: Rangos de Calificación (A-F)

struct IntroII_Exercise02: ExecutableExercise {
    let exerciseId = 2

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer la calificación
        guard let nota = Double(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa una calificación válida")
        }

        // Paso 4: Si (nota >= 0 y nota <= 100)
        guard nota >= 0 && nota <= 100 else {
            throw ExerciseError.outOfRange("La calificación debe estar entre 0 y 100")
        }

        // Pasos 5-13: Evaluación en cascada
        let letra: String

        // Paso 5: Si (nota >= 90)
        if nota >= 90 {
            // Paso 6: MOSTRAR "A"
            letra = "A"
        // Paso 7: Si (nota >= 80)
        } else if nota >= 80 {
            // Paso 8: MOSTRAR "B"
            letra = "B"
        // Paso 9: Si (nota >= 70)
        } else if nota >= 70 {
            // Paso 10: MOSTRAR "C"
            letra = "C"
        // Paso 11: Si (nota >= 60)
        } else if nota >= 60 {
            // Paso 12: MOSTRAR "D"
            letra = "D"
        } else {
            // Paso 13: MOSTRAR "F"
            letra = "F"
        }

        // Paso 14: FIN
        return letra
    }
}

// MARK: - Ejercicio 3: Días del Mes

struct IntroII_Exercise03: ExecutableExercise {
    let exerciseId = 3

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer el mes
        guard let mes = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número de mes válido (1-12)")
        }

        // Paso 4: Si (mes >= 1 y mes <= 12)
        guard mes >= 1 && mes <= 12 else {
            throw ExerciseError.outOfRange("El mes debe estar entre 1 y 12")
        }

        // Pasos 5-9: Determinar días del mes
        let dias: String

        // Paso 5: Si (mes == 1 o mes == 3 o mes == 5 o mes == 7 o mes == 8 o mes == 10 o mes == 12)
        if mes == 1 || mes == 3 || mes == 5 || mes == 7 || mes == 8 || mes == 10 || mes == 12 {
            // Paso 6: MOSTRAR "31 días"
            dias = "31 días"
        // Paso 7: Si (mes == 4 o mes == 6 o mes == 9 o mes == 11)
        } else if mes == 4 || mes == 6 || mes == 9 || mes == 11 {
            // Paso 8: MOSTRAR "30 días"
            dias = "30 días"
        } else {
            // Paso 9: MOSTRAR "28 o 29 días"
            dias = "28 o 29 días"
        }

        // Paso 10: FIN
        return dias
    }
}

// MARK: - Ejercicio 4: Tablero de Ajedrez

struct IntroII_Exercise04: ExecutableExercise {
    let exerciseId = 4

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: INICIO
        var board = ""

        // Paso 2: Variable fila = 0
        var fila = 0

        // Paso 3: Mientras (fila < 8)
        while fila < 8 {
            // Paso 4: Variable columna = 0
            var columna = 0

            // Paso 5: Mientras (columna < 8)
            while columna < 8 {
                // Paso 6: Si ((fila + columna) % 2 == 0)
                if (fila + columna) % 2 == 0 {
                    board += "*"
                } else {
                    board += " "
                }
                // Paso 7: columna = columna + 1
                columna += 1
            }
            // Paso 8: MOSTRAR "\n"
            board += "\n"
            // Paso 9: fila = fila + 1
            fila += 1
        }
        // Paso 10: FIN
        return board
    }
}

// MARK: - Ejercicio 5: Rombo de Asteriscos

struct IntroII_Exercise05: ExecutableExercise {
    let exerciseId = 5

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Pedir altura del rombo
        guard let altura = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero positivo impar")
        }

        // Paso 4: Si (altura >= 1 y altura <= 21 y altura % 2 == 1)
        guard altura >= 1 && altura <= 21 && altura % 2 == 1 else {
            throw ExerciseError.invalidInput("El número debe ser impar y estar entre 1 y 21")
        }

        // Paso 1: INICIO
        var rombo = ""

        // Paso 5: mitad = (altura + 1) / 2
        let mitad = (altura + 1) / 2

        // Paso 6: filaActual = 1
        var filaActual = 1

        // BUCLE 1: Parte superior (expandiendo)
        // Paso 7: Mientras (filaActual <= mitad)
        while filaActual <= mitad {
            // Paso 8: numEspacios = mitad - filaActual
            let numEspacios = mitad - filaActual
            // Paso 9: cantidadAsteriscos = (filaActual × 2) - 1
            let cantidadAsteriscos = (filaActual * 2) - 1
            // Paso 10: MOSTRAR espacios + asteriscos + nueva línea
            rombo += String(repeating: " ", count: numEspacios)
            rombo += String(repeating: "*", count: cantidadAsteriscos)
            rombo += "\n"
            // Paso 11: filaActual = filaActual + 1
            filaActual += 1
        }

        // BUCLE 2: Parte inferior (contrayendo)
        // Paso 12: filaActual = mitad - 1
        filaActual = mitad - 1

        // Paso 13: Mientras (filaActual >= 1)
        while filaActual >= 1 {
            // Paso 14: numEspacios = mitad - filaActual
            let numEspacios = mitad - filaActual
            // Paso 15: cantidadAsteriscos = (filaActual × 2) - 1
            let cantidadAsteriscos = (filaActual * 2) - 1
            // Paso 16: MOSTRAR espacios + asteriscos + nueva línea
            rombo += String(repeating: " ", count: numEspacios)
            rombo += String(repeating: "*", count: cantidadAsteriscos)
            rombo += "\n"
            // Paso 17: filaActual = filaActual - 1
            filaActual -= 1
        }

        // Paso 18: FIN
        return rombo
    }
}

// MARK: - Ejercicio 6: Tablas de Multiplicar

struct IntroII_Exercise06: ExecutableExercise {
    let exerciseId = 6

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: INICIO
        var result = ""

        // Paso 2: Variable tabla = 1
        var tabla = 1

        // Paso 3: Mientras (tabla <= 10)
        while tabla <= 10 {
            // Paso 4: MOSTRAR "Tabla del \(tabla):"
            result += "Tabla del \(tabla):\n"

            // Paso 5: Variable multipli = 1
            var multipli = 1

            // Paso 6: Mientras (multipli <= 10)
            while multipli <= 10 {
                // Paso 7: resultado = tabla * multipli
                let resultado = tabla * multipli

                // Paso 8: MOSTRAR "\(tabla) x \(multipli) = \(resultado)"
                result += "\(tabla) x \(multipli) = \(resultado)\n"

                // Paso 9: multipli = multipli + 1
                multipli += 1
            }
            result += "\n"

            // Paso 10: tabla = tabla + 1
            tabla += 1
        }
        // Paso 11: FIN
        return result
    }
}

// MARK: - Ejercicio 7: Contar Pares e Impares

struct IntroII_Exercise07: ExecutableExercise {
    let exerciseId = 7

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer n
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero positivo")
        }

        // Paso 4: Validar rango
        guard n >= 1 && n <= 1000 else {
            throw ExerciseError.invalidInput("El número debe estar entre 1 y 1000")
        }

        // Paso 5-6: Inicializar contadores
        var contadorPares = 0
        var contadorImpares = 0

        // Paso 7: Inicializar numeroActual
        var numeroActual = 1

        // Paso 8-13: Bucle mientras numeroActual <= n
        while numeroActual <= n {
            // Paso 9: Verificar si es par
            if numeroActual % 2 == 0 {
                // Paso 10: Incrementar contadorPares
                contadorPares += 1
            } else {
                // Paso 11: Incrementar contadorImpares
                contadorImpares += 1
            }
            // Paso 12: Incrementar numeroActual
            numeroActual += 1
        }

        // Paso 14: Mostrar resultado
        return """
        Del 1 al \(n):
        Pares: \(contadorPares)
        Impares: \(contadorImpares)
        """
    }
}

// MARK: - Ejercicio 8: Divisibles por 3

struct IntroII_Exercise08: ExecutableExercise {
    let exerciseId = 8

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer n
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero positivo")
        }

        // Paso 4: Validar rango
        guard n >= 1 && n <= 100 else {
            throw ExerciseError.invalidInput("El número debe estar entre 1 y 100")
        }

        // Paso 5: Inicializar contador
        var contadorDivisibles = 0

        // Paso 6: Inicializar numeroActual
        var numeroActual = 1

        // Paso 7-11: Bucle mientras numeroActual <= n
        while numeroActual <= n {
            // Paso 8: Verificar si es divisible por 3
            if numeroActual % 3 == 0 {
                // Paso 9: Incrementar contador
                contadorDivisibles += 1
            }
            // Paso 10: Incrementar numeroActual
            numeroActual += 1
        }

        // Paso 12: Mostrar resultado
        return "Divisibles por 3 (del 1 al \(n)): \(contadorDivisibles)"
    }
}

// MARK: - Ejercicio 9: Suma de Cuadrados

struct IntroII_Exercise09: ExecutableExercise {
    let exerciseId = 9

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer n
        guard let n = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero positivo")
        }

        // Paso 4: Validar rango
        guard n >= 1 && n <= 100 else {
            throw ExerciseError.invalidInput("El número debe estar entre 1 y 100")
        }

        // Paso 5: Inicializar acumulador
        var sumaCuadrados = 0

        // Paso 6: Inicializar contador
        var numeroActual = 1

        // Paso 7-10: Bucle mientras numeroActual <= n
        while numeroActual <= n {
            // Paso 8: Calcular y acumular el cuadrado
            sumaCuadrados = sumaCuadrados + (numeroActual * numeroActual)
            // Paso 9: Incrementar numeroActual
            numeroActual += 1
        }

        // Paso 11: Mostrar resultado
        return "Suma de cuadrados (1 a \(n)): \(sumaCuadrados)"
    }
}

// MARK: - Ejercicio 10: Raíz Cuadrada (Newton-Raphson)

struct IntroII_Exercise10: ExecutableExercise {
    let exerciseId = 10

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer el número
        guard let a = Double(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número válido")
        }

        // Paso 4: Validar rango (a > 0 y a <= 1000000)
        guard a > 0 && a <= 1000000 else {
            throw ExerciseError.invalidInput("El número debe ser mayor que 0 y menor o igual a 1000000")
        }

        // Paso 5: Variable x₀ = a
        var x0 = a
        var x1 = 0.0

        // Paso 6-9: Bucle mientras |x₁ - x₀| > 0.001
        repeat {
            // Paso 6: CÁLCULO x₁ = (x₀ + a / x₀) / 2
            x1 = (x0 + a / x0) / 2

            // Paso 7: Si |x₁ - x₀| > 0.001 → seguir, si no → salir
            if abs(x1 - x0) <= 0.001 {
                break
            }

            // Paso 8: CÁLCULO x₀ = x₁
            x0 = x1
            // Paso 9: Volver a 6
        } while true

        // Paso 10: MOSTRAR resultado
        return "Raíz cuadrada: \(String(format: "%.4f", x1))"
    }
}

// MARK: - Ejercicio 11: Encontrar el Mínimo

struct IntroII_Exercise11: ExecutableExercise {
    let exerciseId = 11

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer los 10 números
        let listaNumeros = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard listaNumeros.count == 10 else {
            throw ExerciseError.invalidInput("Debes ingresar exactamente 10 números separados por comas")
        }

        // Paso 4: Variable minimo = listaNumeros[0]
        var minimo = listaNumeros[0]

        // Paso 5: Variable indice = 1
        var indice = 1

        // Paso 6-10: Bucle mientras indice < 10
        while indice < 10 {
            // Paso 7: Si listaNumeros[indice] < minimo
            if listaNumeros[indice] < minimo {
                // Paso 8: minimo = listaNumeros[indice]
                minimo = listaNumeros[indice]
            }
            // Paso 9: indice = indice + 1
            indice += 1
        }

        // Paso 11: Mostrar resultado
        return "El mínimo es: \(String(format: "%.0f", minimo))"
    }
}

// MARK: - Ejercicio 12: Año Bisiesto

struct IntroII_Exercise12: ExecutableExercise {
    let exerciseId = 12

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer el año
        guard let año = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un año válido")
        }

        // Paso 4: Validar rango (año >= 1 y año <= 9999)
        guard año >= 1 && año <= 9999 else {
            throw ExerciseError.invalidInput("El año debe estar entre 1 y 9999")
        }

        // Paso 5: Si (año % 400 == 0) → es bisiesto
        if año % 400 == 0 {
            return "\(año) ES bisiesto"
        }

        // Paso 6: Si (año % 100 == 0) → NO es bisiesto
        if año % 100 == 0 {
            return "\(año) NO es bisiesto"
        }

        // Paso 7: Si (año % 4 == 0) → es bisiesto, si no → NO es bisiesto
        if año % 4 == 0 {
            return "\(año) ES bisiesto"
        } else {
            return "\(año) NO es bisiesto"
        }
    }
}

// MARK: - Ejercicio 13: Valor Absoluto

struct IntroII_Exercise13: ExecutableExercise {
    let exerciseId = 13

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer el número
        guard var num = Double(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número válido")
        }

        // Paso 4: Si (num < 0)
        if num < 0 {
            // Paso 5: num = num × (-1)
            num = num * (-1)
        }

        // Paso 6: Mostrar resultado
        return "Valor absoluto: \(String(format: "%.0f", num))"
    }
}

// MARK: - Ejercicio 14: Cuadrado Perfecto

struct IntroII_Exercise14: ExecutableExercise {
    let exerciseId = 14

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3: Leer el número
        guard let num = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Validar num >= 0
        guard num >= 0 else {
            throw ExerciseError.invalidInput("El número debe ser no negativo")
        }

        // Paso 5: Variable i = 0
        var i = 0

        // Paso 6-9: Bucle mientras i * i <= num
        while i * i <= num {
            // Paso 7: Si i * i == num → es cuadrado perfecto
            if i * i == num {
                // Paso 11: Mostrar "es cuadrado perfecto"
                return "\(num) ES cuadrado perfecto (\(i)²)"
            }
            // Paso 8: i = i + 1
            i += 1
        }

        // Paso 10: Mostrar "no es cuadrado perfecto"
        return "\(num) NO es cuadrado perfecto"
    }
}

// MARK: - Ejercicio 15: Ecuación de Segundo Grado

struct IntroII_Exercise15: ExecutableExercise {
    let exerciseId = 15

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3, 5-6, 8-9: Leer los coeficientes a, b, c
        let coefficients = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        guard coefficients.count == 3 else {
            throw ExerciseError.invalidInput("Ingresa a, b, c separados por comas")
        }

        let (a, b, c) = (coefficients[0], coefficients[1], coefficients[2])

        // Paso 4: Si (a >= -1000 y a <= 1000 y a != 0)
        guard a >= -1000 && a <= 1000 && a != 0 else {
            throw ExerciseError.invalidInput("'a' debe estar entre -1000 y 1000, y no puede ser 0")
        }

        // Paso 7: Si (b >= -1000 y b <= 1000)
        guard b >= -1000 && b <= 1000 else {
            throw ExerciseError.invalidInput("'b' debe estar entre -1000 y 1000")
        }

        // Paso 10: Si (c >= -1000 y c <= 1000)
        guard c >= -1000 && c <= 1000 else {
            throw ExerciseError.invalidInput("'c' debe estar entre -1000 y 1000")
        }

        // Paso 11: CÁLCULO discriminante = (b * b) - (4 * a * c)
        let discriminante = b * b - 4 * a * c

        // Paso 12: Si (discriminante > 0)
        if discriminante > 0 {
            // Paso 13: CÁLCULO x1 = (-b + sqrt(discriminante)) / (2 * a)
            let x1 = (-b + discriminante.squareRoot()) / (2 * a)
            // Paso 14: CÁLCULO x2 = (-b - sqrt(discriminante)) / (2 * a)
            let x2 = (-b - discriminante.squareRoot()) / (2 * a)
            // Paso 15: MOSTRAR "x1 = x1, x2 = x2"
            return """
            Ecuación: \(a)x² + \(b)x + \(c) = 0
            Discriminante: \(discriminante)
            x₁ = \(String(format: "%.2f", x1))
            x₂ = \(String(format: "%.2f", x2))
            """
        // Paso 16: Si (discriminante == 0)
        } else if discriminante == 0 {
            // Paso 17: CÁLCULO x = -b / (2 * a)
            let x = -b / (2 * a)
            // Paso 18: MOSTRAR "Solución única: x"
            return """
            Ecuación: \(a)x² + \(b)x + \(c) = 0
            Discriminante: \(discriminante)
            Solución única: x = \(String(format: "%.2f", x))
            """
        } else {
            // Paso 19: MOSTRAR "No hay soluciones reales"
            return """
            Ecuación: \(a)x² + \(b)x + \(c) = 0
            Discriminante: \(discriminante)
            No hay soluciones reales
            """
        }
        // Paso 20: FIN
    }
}

// MARK: - Ejercicio 16: Potencia

struct IntroII_Exercise16: ExecutableExercise {
    let exerciseId = 16

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 2-3, 5-6: Leer base y exponente
        let values = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard values.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa base y exponente separados por coma")
        }

        let (base, exponente) = (values[0], values[1])

        // Paso 4: Si (base >= -100 y base <= 100)
        guard base >= -100 && base <= 100 else {
            throw ExerciseError.invalidInput("La base debe estar entre -100 y 100")
        }

        // Paso 7: Si (exponente >= 0 y exponente <= 20)
        guard exponente >= 0 && exponente <= 20 else {
            throw ExerciseError.invalidInput("El exponente debe estar entre 0 y 20")
        }

        // Paso 8: Variable resultado = 1
        var resultado = 1
        // Paso 9: Variable contador = 0
        var contador = 0

        // Paso 10: Si (contador < exponente)
        while contador < exponente {
            // Paso 11: CÁLCULO resultado = resultado × base
            resultado *= base
            // Paso 12: CÁLCULO contador = contador + 1
            contador += 1
            // Paso 13: Volver a 10
        }

        // Paso 14: MOSTRAR "base ^ exponente = resultado"
        return "\(base)^\(exponente) = \(resultado)"
        // Paso 15: FIN
    }
}

// MARK: - Ejercicio 17: Adivina el Número

struct IntroII_Exercise17: ExecutableExercise {
    let exerciseId = 17

    // Paso 2: Variable numeroSecreto = NumeroAleatorio(1, 100)
    @MainActor private static var secretNumber = Int.random(in: 1...100)
    // Paso 3: Variable intentos = 0
    @MainActor private static var intentos = 0

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: INICIO

        // Paso 4-5: PREGUNTAR "¿Cuál es tu intento?" y leer respuesta
        guard let intento = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número del 1 al 100")
        }

        // Paso 6: Si (intento >= 1 y intento <= 100)
        guard intento >= 1 && intento <= 100 else {
            // Si es NO voy a 4 (pedir otro intento)
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 100")
        }

        // Paso 7: CÁLCULO intentos = intentos + 1
        IntroII_Exercise17.intentos += 1

        // Paso 8: Si (intento == numeroSecreto)
        if intento == IntroII_Exercise17.secretNumber {
            // Paso 12: MOSTRAR "¡Correcto! Lo lograste en [intentos] intentos"
            let totalIntentos = IntroII_Exercise17.intentos
            // Reiniciar para nueva partida
            IntroII_Exercise17.secretNumber = Int.random(in: 1...100)
            IntroII_Exercise17.intentos = 0
            return "🎉 ¡Correcto! Lo lograste en \(totalIntentos) intentos"
        }

        // Paso 9: Si (intento < numeroSecreto)
        if intento < IntroII_Exercise17.secretNumber {
            // Paso 10: MOSTRAR "El número secreto es MAYOR"
            return "📈 El número secreto es MAYOR que \(intento)"
        } else {
            // Paso 11: MOSTRAR "El número secreto es MENOR"
            return "📉 El número secreto es MENOR que \(intento)"
        }
        // Paso 13: FIN
    }
}

// MARK: - Ejercicio 18: Suma de Dígitos Recursiva

struct IntroII_Exercise18: ExecutableExercise {
    let exerciseId = 18

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: INICIO

        // Paso 2-3: PREGUNTAR "¿Cuál es el número?" y leer respuesta
        guard let num = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número entero válido")
        }

        // Paso 4: Si (num >= 0 y num <= 999999999)
        guard num >= 0 && num <= 999999999 else {
            // Si es NO voy a 2
            throw ExerciseError.invalidInput("El número debe estar entre 0 y 999999999")
        }

        var current = num
        var steps: [String] = []

        // Paso 5: Si (num >= 10) - bucle externo
        while current >= 10 {
            // Paso 6: Variable suma = 0
            var suma = 0
            var temp = current
            var digitos: [Int] = []

            // Paso 7: Si (num > 0) - bucle interno
            while temp > 0 {
                // Paso 8: CÁLCULO suma = suma + (num % 10)
                let digito = temp % 10
                suma = suma + digito
                digitos.insert(digito, at: 0)
                // Paso 9: CÁLCULO num = num / 10, Volver a 7
                temp = temp / 10
            }

            steps.append("\(digitos.map { String($0) }.joined(separator: "+")) = \(suma)")

            // Paso 10: CÁLCULO num = suma, Volver a 5
            current = suma
        }

        // Paso 11: MOSTRAR "Resultado: num"
        if steps.isEmpty {
            return "El número \(num) ya tiene un solo dígito: \(current)"
        }

        return """
        Proceso:
        \(steps.joined(separator: " → "))

        Resultado final: \(current)
        """
        // Paso 12: FIN
    }
}

// MARK: - Ejercicio 19: Día de la Semana (Zeller)

struct IntroII_Exercise19: ExecutableExercise {
    let exerciseId = 19

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: INICIO

        // Paso 2-3: PREGUNTAR día y Variable q
        let values = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard values.count == 3 else {
            throw ExerciseError.invalidInput("Ingresa día, mes, año separados por comas")
        }

        let q = values[0]      // día
        let mes = values[1]    // mes
        var año = values[2]    // año

        // Paso 4: Si (q >= 1 y q <= 31)
        guard q >= 1 && q <= 31 else {
            throw ExerciseError.outOfRange("El día debe estar entre 1 y 31")
        }

        // Paso 7: Si (mes >= 1 y mes <= 12)
        guard mes >= 1 && mes <= 12 else {
            throw ExerciseError.outOfRange("El mes debe estar entre 1 y 12")
        }

        // Paso 10: Si (año >= 1 y año <= 9999)
        guard año >= 1 && año <= 9999 else {
            throw ExerciseError.outOfRange("El año debe estar entre 1 y 9999")
        }

        // Paso 11-14: Ajuste para Zeller (enero y febrero son meses 13 y 14 del año anterior)
        var m: Int
        if mes <= 2 {
            // Paso 12: m = mes + 12
            m = mes + 12
            // Paso 13: año = año - 1
            año = año - 1
        } else {
            // Paso 14: m = mes
            m = mes
        }

        // Paso 15: K = año % 100
        let K = año % 100
        // Paso 16: J = año / 100
        let J = año / 100

        // Paso 17: Fórmula de Zeller
        var h = (q + (13 * (m + 1)) / 5 + K + K / 4 + J / 4 - 2 * J) % 7

        // Paso 18-19: Ajuste para valores negativos
        if h < 0 {
            h = h + 7
        }

        // Paso 20: MOSTRAR "Día de la semana: h"
        let dias = ["Sábado", "Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes"]

        return """
        Fecha: \(q)/\(values[1])/\(values[2])
        Día de la semana: \(dias[h])
        """
        // Paso 21: FIN
    }
}

// MARK: - Ejercicio 20: Calcular Edad

struct IntroII_Exercise20: ExecutableExercise {
    let exerciseId = 20

    // Subproceso EsBisiesto - Usa Ejercicio 12
    private func esBisiesto(_ año: Int) async -> Bool {
        let ejercicio12 = IntroII_Exercise12()
        do {
            let resultado = try await ejercicio12.execute(input: String(año))
            return resultado.contains("ES bisiesto")
        } catch {
            return false
        }
    }

    // Subproceso DiasMes - Usa Ejercicio 3 + Ejercicio 12
    private func diasMes(_ mes: Int, _ año: Int) async -> Int {
        let ejercicio3 = IntroII_Exercise03()
        do {
            let resultado = try await ejercicio3.execute(input: String(mes))
            if resultado.contains("31") {
                return 31
            } else if resultado.contains("30") {
                return 30
            } else {
                // Febrero: 28 o 29 según si es bisiesto
                return await esBisiesto(año) ? 29 : 28
            }
        } catch {
            return 0
        }
    }

    // Subproceso DiaDelAño(día, mes, año)
    private func diaDelAño(_ día: Int, _ mes: Int, _ año: Int) async -> Int {
        var total = 0
        var i = 1
        while i < mes {
            let dias = await diasMes(i, año)
            total = total + dias
            i = i + 1
        }
        total = total + día
        return total
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Paso 1: INICIO
        let values = input.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
        guard values.count == 3 else {
            throw ExerciseError.invalidInput("Ingresa día, mes, año de nacimiento separados por comas")
        }

        let diaNac = values[0]
        let mesNac = values[1]
        let añoNac = values[2]

        // Pasos 2-4: Obtener fecha actual
        let now = Date()
        let calendar = Calendar.current
        let diaHoy = calendar.component(.day, from: now)      // Subproceso DiaActual()
        let mesHoy = calendar.component(.month, from: now)    // Subproceso MesActual()
        let añoHoy = calendar.component(.year, from: now)     // Subproceso AñoActual()

        // Paso 7: Validar mes (1-12)
        guard mesNac >= 1 && mesNac <= 12 else {
            throw ExerciseError.outOfRange("El mes debe estar entre 1 y 12")
        }

        // Paso 10: Validar año (1900 - añoHoy)
        guard añoNac >= 1900 && añoNac <= añoHoy else {
            throw ExerciseError.outOfRange("El año debe estar entre 1900 y \(añoHoy)")
        }

        // Paso 11: Calcular días del mes - Usa Ejercicio 3
        let diasDelMes = await diasMes(mesNac, añoNac)

        // Paso 14-15: Validar día (1 - diasDelMes)
        guard diaNac >= 1 && diaNac <= diasDelMes else {
            throw ExerciseError.outOfRange("El mes \(mesNac) solo tiene \(diasDelMes) días")
        }

        // Pasos 16-17: Inicializar variables
        var diasVida = 0
        var i = añoNac

        // Pasos 18-24: Bucle - sumar días de cada año completo - Usa Ejercicio 12
        while i < añoHoy {
            let bisiesto = await esBisiesto(i)
            if bisiesto {
                diasVida = diasVida + 366
            } else {
                diasVida = diasVida + 365
            }
            i = i + 1
        }

        // Paso 25: Restar días hasta fecha de nacimiento
        let diasNacimiento = await diaDelAño(diaNac, mesNac, añoNac)
        diasVida = diasVida - diasNacimiento

        // Paso 26: Sumar días hasta hoy
        let diasHoyEnAño = await diaDelAño(diaHoy, mesHoy, añoHoy)
        diasVida = diasVida + diasHoyEnAño

        // Paso 27: Calcular edad
        let edadExacta = Double(diasVida) / 365.25
        let edadTruncada = floor(edadExacta * 100) / 100
        let edad = Int(edadExacta)

        // Paso 28: Mostrar resultado
        return """
        Fecha de nacimiento: \(diaNac)/\(mesNac)/\(añoNac)
        Fecha actual: \(diaHoy)/\(mesHoy)/\(añoHoy)
        Días vividos: \(diasVida) (\(edadTruncada) años)

        Tienes \(edad) años
        """
    }
}
