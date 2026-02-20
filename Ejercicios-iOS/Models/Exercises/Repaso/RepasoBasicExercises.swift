//
//  RepasoBasicExercises.swift
//  Ejercicios-iOS
//
//  Repaso - Ejercicios 1-10
//  Nivel: Básico
//

import Foundation

// MARK: - Ejercicio 1: Tipos Primitivos
// Tipos del enunciado: Int, Double, String, Bool, Character
// var → variable (puede cambiar) | let → constante (inmutable)

struct Repaso_Exercise01: ExecutableExercise {
    let exerciseId = 1

    @MainActor
    func execute(input: String) async throws -> String {
        // Int
        var intVar: Int = 25
        let intOriginal = intVar
        let intLet: Int = 1999
        intVar = 30

        // Double
        var doubleVar: Double = 19.99
        let doubleOriginal = doubleVar
        let doubleLet: Double = 3.14159265359
        doubleVar = 29.99

        // String
        var stringVar: String = "Swift"
        let stringOriginal = stringVar
        let stringLet: String = "Hola mundo"
        stringVar = "SwiftUI"

        // Bool
        var boolVar: Bool = true
        let boolOriginal = boolVar
        let boolLet: Bool = false
        boolVar = false

        // Character
        var charVar: Character = "A"
        let charOriginal = charVar
        let charLet: Character = "@"
        charVar = "Z"

        return """
        ═══════════════════════════════════════════
        TIPOS PRIMITIVOS EN SWIFT
        ═══════════════════════════════════════════

        Int (Enteros):
           var edad: Int = \(intOriginal) -> \(intVar)
           let añoNacimiento: Int = \(intLet)
           // Números enteros sin decimales
           // Precisión según el SO (32 o 64 bits)
           // Usar para: contadores, edades, índices, años

        Double (Decimales):
           var precio: Double = \(doubleOriginal) -> \(doubleVar)
           let pi: Double = \(doubleLet)
           // Hasta 15 dígitos decimales de precisión
           // Usar para: precios, coordenadas, cálculos precisos

        String (Texto):
           var nombre: String = "\(stringOriginal)" -> "\(stringVar)"
           let saludo: String = "\(stringLet)"
           // Cadena de caracteres
           // Usar para: nombres, mensajes, cualquier texto

        Bool (Booleano):
           var activo: Bool = \(boolOriginal) -> \(boolVar)
           let esAdmin: Bool = \(boolLet)
           // Solo dos valores: true o false
           // Usar para: estados, condiciones, flags

        Character (Carácter):
           var inicial: Character = "\(charOriginal)" -> "\(charVar)"
           let simbolo: Character = "\(charLet)"
           // Un solo carácter (String es [Character])
           // Usar para: recorrer strings, representar un símbolo

        ═══════════════════════════════════════════
        var -> variable (puede cambiar)
        let -> constante (inmutable) - preferir let
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 2: Operaciones Aritméticas
// Tipos numéricos: Int, Double, Float, UInt
// Operaciones: +, -, *, /, % con paréntesis y conversiones

struct Repaso_Exercise02: ExecutableExercise {
    let exerciseId = 2

    @MainActor
    func execute(input: String) async throws -> String {
        // Declaración de 4 tipos numéricos distintos
        let entero: Int = 10
        let decimal: Double = 3.5
        let flotante: Float = 2.5
        let sinSigno: UInt = 5

        // Operaciones básicas
        let suma = entero + 5
        let resta = entero - 3
        let multiplicacion = entero * 4
        let division = decimal / 2.0
        let modulo = entero % 3

        // Operaciones con paréntesis (precedencia)
        let sinParentesis = entero + 5 * 2
        let conParentesis = (entero + 5) * 2

        // Conversiones de tipo
        let intADouble = Double(entero) + decimal
        let floatADouble = Double(flotante) + decimal
        let uintAInt = Int(sinSigno) + entero

        return """
        ═══════════════════════════════════════════
        OPERACIONES ARITMÉTICAS EN SWIFT
        ═══════════════════════════════════════════

        Declaración de variables:
           let entero: Int = \(entero)
           let decimal: Double = \(decimal)
           let flotante: Float = \(flotante)
           let sinSigno: UInt = \(sinSigno)

        ───────────────────────────────────────────
        Operaciones básicas:

           1. Suma:           \(entero) + 5 = \(suma)
           2. Resta:          \(entero) - 3 = \(resta)
           3. Multiplicación: \(entero) * 4 = \(multiplicacion)
           4. División:       \(decimal) / 2.0 = \(division)
           5. Módulo:         \(entero) % 3 = \(modulo)

        ───────────────────────────────────────────
        Precedencia con paréntesis:

           6. \(entero) + 5 * 2 = \(sinParentesis)    (primero * luego +)
           7. (\(entero) + 5) * 2 = \(conParentesis)    (paréntesis primero)

        ───────────────────────────────────────────
        Conversiones de tipo:

           8. Double(\(entero)) + \(decimal) = \(intADouble)
              // Int a Double para operar con Double

           9. Double(\(flotante)) + \(decimal) = \(floatADouble)
              // Float a Double para mayor precisión

          10. Int(\(sinSigno)) + \(entero) = \(uintAInt)
              // UInt a Int para operar con Int

        ═══════════════════════════════════════════
        Swift requiere conversión explícita entre tipos
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 3: Verificar Múltiplo
// Recibe dos números (enteros o decimales) y determina si el primero es múltiplo del segundo
// Argumenta qué ocurre con decimales vs enteros

struct Repaso_Exercise03: ExecutableExercise {
    let exerciseId = 3

    @MainActor
    func execute(input: String) async throws -> String {
        let parts = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        guard parts.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa dos números separados por coma")
        }

        guard let num1 = Double(parts[0]), let num2 = Double(parts[1]) else {
            throw ExerciseError.invalidInput("Ambos valores deben ser números válidos")
        }

        guard num2 != 0 else {
            throw ExerciseError.invalidInput("El segundo número no puede ser 0 (división por cero)")
        }

        // Formatear número: entero sin decimales, decimal con precisión
        func formatNumber(_ n: Double) -> String {
            n.truncatingRemainder(dividingBy: 1) == 0
                ? n.formatted(.number.precision(.fractionLength(0)))
                : n.formatted(.number.precision(.fractionLength(2)))
        }

        // Detectar si alguno tiene decimales
        let isNum1Int = num1.truncatingRemainder(dividingBy: 1) == 0
        let isNum2Int = num2.truncatingRemainder(dividingBy: 1) == 0
        let hasDecimals = !isNum1Int || !isNum2Int

        // Calcular resto (módulo para Double)
        let remainder = num1.truncatingRemainder(dividingBy: num2)
        let isMultiple = abs(remainder) < 0.0001

        let num1Str = formatNumber(num1)
        let num2Str = formatNumber(num2)

        var result = "\(num1Str) \(isMultiple ? "es" : "NO es") múltiplo de \(num2Str)"

        // Nota explicativa si hay decimales
        if hasDecimals {
            let restoStr = remainder.formatted(.number.precision(.fractionLength(6)))
            result += "\n\nNota: El concepto de múltiplo es matemáticamente exacto"
            result += "\npara enteros. Con decimales, se verifica si el resto"
            result += "\nde la división es cercano a cero."
            result += "\nResto: \(restoStr)"
        }

        return result
    }
}

// MARK: - Ejercicio 4: Números Pares (Bucles)
// Implementa for-in y repeat-while mostrando pares del 2 al 40
// Explica diferencias en sintaxis y flujo de ejecución

struct Repaso_Exercise04: ExecutableExercise {
    let exerciseId = 4

    @MainActor
    func execute(input: String) async throws -> String {
        // Usando for-in
        var paresForIn: [Int] = []
        for i in 2...40 where i % 2 == 0 {
            paresForIn.append(i)
        }

        // Usando repeat-while
        var paresRepeatWhile: [Int] = []
        var num = 2
        repeat {
            paresRepeatWhile.append(num)
            num += 2
        } while num <= 40

        let listaForIn = paresForIn.map(String.init).joined(separator: ", ")
        let listaRepeatWhile = paresRepeatWhile.map(String.init).joined(separator: ", ")

        return """
        ═══════════════════════════════════════════
        BUCLES EN SWIFT: for-in vs repeat-while
        ═══════════════════════════════════════════

        FOR-IN con where:
        ───────────────────────────────────────────
        for i in 2...40 where i % 2 == 0 {
            // se ejecuta solo si cumple la condición
        }

        Resultado: \(listaForIn)

        REPEAT-WHILE:
        ───────────────────────────────────────────
        var num = 2
        repeat {
            // se ejecuta al menos una vez
            num += 2
        } while num <= 40

        Resultado: \(listaRepeatWhile)

        ═══════════════════════════════════════════
        DIFERENCIAS:
        ═══════════════════════════════════════════

        for-in:
        - Itera sobre una secuencia conocida (2...40)
        - La condición where filtra antes de ejecutar
        - Más declarativo y legible
        - Ideal cuando conoces el rango

        repeat-while:
        - Ejecuta el bloque AL MENOS UNA VEZ
        - Evalúa la condición al final de cada iteración
        - Más imperativo, controlas el incremento
        - Ideal cuando no sabes cuántas iteraciones
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 5: Suma Impares y Producto Pares
// Crea 15 números aleatorios y usa bucles tradicionales

struct Repaso_Exercise05: ExecutableExercise {
    let exerciseId = 5

    @MainActor
    func execute(input: String) async throws -> String {
        // Generar 15 números aleatorios
        var numeros: [Int] = []
        for _ in 1...15 {
            numeros.append(Int.random(in: 1...50))
        }

        // Separar, sumar y multiplicar en un solo bucle
        var impares: [Int] = []
        var pares: [Int] = []
        var sumaImpares = 0
        var productoPares = 1

        for num in numeros {
            if num % 2 == 0 {
                pares.append(num)
                productoPares *= num
            } else {
                impares.append(num)
                sumaImpares += num
            }
        }

        let listaNumeros = numeros.map(String.init).joined(separator: ", ")
        let listaImpares = impares.isEmpty ? "ninguno" : impares.map(String.init).joined(separator: " + ")
        let listaPares = pares.isEmpty ? "ninguno" : pares.map(String.init).joined(separator: " x ")

        return """
        ═══════════════════════════════════════════
        SUMA IMPARES Y PRODUCTO PARES
        ═══════════════════════════════════════════

        Array generado (15 números aleatorios):
        [\(listaNumeros)]

        ───────────────────────────────────────────
        IMPARES:
        \(listaImpares) = \(sumaImpares)

        PARES:
        \(listaPares) = \(productoPares)
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 6: Persona Más Alta y Baja
// Construye un diccionario con 8 personas y alturas (cm), encuentra la más alta y más baja

struct Repaso_Exercise06: ExecutableExercise {
    let exerciseId = 6

    @MainActor
    func execute(input: String) async throws -> String {
        let nombres = ["Ana", "Luis", "María", "Carlos", "Elena", "Pedro", "Laura", "Miguel"]

        // Construir diccionario con alturas aleatorias
        var personas: [String: Int] = [:]
        for nombre in nombres {
            personas[nombre] = Int.random(in: 150...200)
        }

        // Ordenar por altura
        let ordenadas = personas.sorted { $0.value < $1.value }

        guard let masBaja = ordenadas.first,
              let masAlta = ordenadas.last else {
            return "No hay personas en el diccionario"
        }

        // Formatear lista ordenada
        var lista = ""
        for (index, persona) in ordenadas.enumerated() {
            lista += "\(index + 1). \(persona.key): \(persona.value) cm\n"
        }

        return """
        ═══════════════════════════════════════════
        DICCIONARIO DE PERSONAS Y ALTURAS
        ═══════════════════════════════════════════

        Ordenado por altura (menor a mayor):
        \(lista)
        ───────────────────────────────────────────
        Más baja: \(masBaja.key) (\(masBaja.value) cm)
        Más alta: \(masAlta.key) (\(masAlta.value) cm)
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 7: Clasificar Mes por Estación
// Define enum de meses y usa switch para clasificar inicio/medio/final de estación

struct Repaso_Exercise07: ExecutableExercise {
    let exerciseId = 7

    @MainActor
    func execute(input: String) async throws -> String {
        enum Mes: String {
            case enero
            case febrero
            case marzo
            case abril
            case mayo
            case junio
            case julio
            case agosto
            case septiembre
            case octubre
            case noviembre
            case diciembre
        }

        enum Estacion: String {
            case primavera = "Primavera"
            case verano = "Verano"
            case otono = "Otoño"
            case invierno = "Invierno"
        }

        enum Posicion: String {
            case inicio = "Inicio"
            case medio = "Medio"
            case final = "Final"
        }

        let mesStr = input.trimmingCharacters(in: .whitespaces).lowercased()

        guard let mes = Mes(rawValue: mesStr) else {
            throw ExerciseError.invalidInput("Mes no válido. Ejemplo: marzo")
        }

        let (estacion, posicion): (Estacion, Posicion) = switch mes {
        case .marzo:      (.primavera, .inicio)
        case .abril:      (.primavera, .medio)
        case .mayo:       (.primavera, .final)
        case .junio:      (.verano, .inicio)
        case .julio:      (.verano, .medio)
        case .agosto:     (.verano, .final)
        case .septiembre: (.otono, .inicio)
        case .octubre:    (.otono, .medio)
        case .noviembre:  (.otono, .final)
        case .diciembre:  (.invierno, .inicio)
        case .enero:      (.invierno, .medio)
        case .febrero:    (.invierno, .final)
        }

        return "\(mesStr.capitalized) está en el \(posicion.rawValue.lowercased()) de \(estacion.rawValue)"
    }
}

// MARK: - Ejercicio 8: Descripción Vehículo
// Crea clase Vehiculo con marca, modelo, año. Instancia 5 objetos.
// Clase expuesta para reutilización en ejercicios 14, 18 y 33

struct Repaso_Exercise08: ExecutableExercise {
    let exerciseId = 8

    // Enum ColorITV basado en el sistema real español
    // 2025, 2028, 2031... = Verde
    // 2026, 2029, 2032... = Amarillo
    // 2027, 2030, 2033... = Rojo
    enum ColorITV: String {
        case verde = "Verde"
        case amarillo = "Amarillo"
        case rojo = "Rojo"
    }

    // Struct para configuración detallada (ejercicio 33)
    // Guarda los valores ya calculados
    struct ConfiguracionDetallada {
        let proximaITV: Int
        let colorEtiqueta: ColorITV
    }

    @MainActor
    final class Vehiculo {
        let marca: String
        let modelo: String
        var año: Int  // var para ejercicio 18 (actualizarAño)

        // 5 instancias reutilizables en ejercicios 14, 18 y 33
        static let vehiculos = [
            Vehiculo(marca: "Tesla", modelo: "Model S Plaid", año: 2024),
            Vehiculo(marca: "Tesla", modelo: "Model 3 Performance", año: 2024),
            Vehiculo(marca: "Tesla", modelo: "Model X Plaid", año: 2023),
            Vehiculo(marca: "Tesla", modelo: "Model Y Long Range", año: 2024),
            Vehiculo(marca: "Tesla", modelo: "Cybertruck", año: 2024)
        ]

        // Computed: calcula años desde matriculación
        var antiguedad: Int {
            Calendar.current.component(.year, from: Date()) - año
        }

        // Computed: calcula próxima ITV según antigüedad
        var proximaITV: Int {
            let añoActual = Calendar.current.component(.year, from: Date())
            let primeraITV = año + 4

            // Si aún no toca la primera ITV
            if añoActual < primeraITV {
                return primeraITV
            }

            // Calcular próxima ITV desde el patrón
            var proxima = primeraITV
            while proxima <= añoActual {
                if proxima - año < 10 {
                    proxima += 2  // Cada 2 años hasta los 10
                } else {
                    proxima += 1  // Cada año después de los 10
                }
            }

            return proxima
        }

        // Computed: color según año de vencimiento
        var colorEtiqueta: ColorITV {
            switch (proximaITV - 2025) % 3 {
            case 0: .verde
            case 1: .amarillo
            default: .rojo
            }
        }

        // Lazy: se crea solo al primer acceso, captura valores calculados
        lazy var configuracionDetallada = ConfiguracionDetallada(
            proximaITV: proximaITV,
            colorEtiqueta: colorEtiqueta
        )

        init(marca: String, modelo: String, año: Int) {
            self.marca = marca
            self.modelo = modelo
            self.año = año
        }

        func descripcion() -> String {
            "\(marca) \(modelo) (\(año))"
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Usamos los vehículos definidos en la clase
        let vehiculos = Vehiculo.vehiculos

        var lista = ""
        for (index, vehiculo) in vehiculos.enumerated() {
            lista += "\(index + 1). \(vehiculo.descripcion())\n"
        }

        return """
        ═══════════════════════════════════════════
        CLASE VEHICULO - 5 INSTANCIAS
        ═══════════════════════════════════════════

        \(lista)
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 9: Área y Circunferencia Círculo
// Define struct Circulo con propiedades calculadas. Instancia varios y encuentra mayor/menor área.
// Struct expuesto para reutilización en ejercicio 19

struct Repaso_Exercise09: ExecutableExercise {
    let exerciseId = 9

    // Struct con propiedad almacenada y propiedades calculadas
    struct Circulo {
        let radio: Double

        var area: Double {
            Double.pi * radio * radio
        }

        var circunferencia: Double {
            2 * Double.pi * radio
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Instanciar 5 círculos con radios aleatorios
        let circulos = [
            Circulo(radio: Double.random(in: 1...10)),
            Circulo(radio: Double.random(in: 1...10)),
            Circulo(radio: Double.random(in: 1...10)),
            Circulo(radio: Double.random(in: 1...10)),
            Circulo(radio: Double.random(in: 1...10))
        ]

        // Ordenar por área
        let ordenados = circulos.sorted { $0.area < $1.area }

        guard let menor = ordenados.first,
              let mayor = ordenados.last else {
            return "No hay círculos"
        }

        // Formatear lista
        var lista = ""
        for (index, circulo) in ordenados.enumerated() {
            lista += "\(index + 1). Radio: \(circulo.radio.formatted(.number.precision(.fractionLength(2)))) → "
            lista += "Área: \(circulo.area.formatted(.number.precision(.fractionLength(2)))), "
            lista += "Circunf: \(circulo.circunferencia.formatted(.number.precision(.fractionLength(2))))\n"
        }

        return """
        ═══════════════════════════════════════════
        STRUCT CIRCULO - PROPIEDADES CALCULADAS
        ═══════════════════════════════════════════

        struct Circulo {
            let radio: Double
            var area: Double { π × radio² }
            var circunferencia: Double { 2 × π × radio }
        }

        ───────────────────────────────────────────
        5 CÍRCULOS (ordenados por área):
        \(lista)
        ───────────────────────────────────────────
        Menor área: Radio \(menor.radio.formatted(.number.precision(.fractionLength(2)))) → \(menor.area.formatted(.number.precision(.fractionLength(2))))
        Mayor área: Radio \(mayor.radio.formatted(.number.precision(.fractionLength(2)))) → \(mayor.area.formatted(.number.precision(.fractionLength(2))))
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 10: Información Película
// Clase Pelicula con 3 métodos: descripcion, mismoDirector, mismaDecada

struct Repaso_Exercise10: ExecutableExercise {
    let exerciseId = 10

    class Pelicula {
        let titulo: String
        let director: String
        let estreno: Int

        init(titulo: String, director: String, estreno: Int) {
            self.titulo = titulo
            self.director = director
            self.estreno = estreno
        }

        func descripcion() -> String {
            "\(titulo) (\(estreno)) - Dirigida por \(director)"
        }

        func mismoDirector(que otra: Pelicula) -> Bool {
            director.compare(otra.director, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
        }

        func mismaDecada(que otra: Pelicula) -> Bool {
            (estreno / 10) == (otra.estreno / 10)
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let añoActual = Calendar.current.component(.year, from: Date())

        // Parsear dos películas separadas por |
        let peliculas = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard peliculas.count == 2 else {
            throw ExerciseError.invalidInput("Formato: título1,director1,año1 | título2,director2,año2")
        }

        func parsePelicula(_ str: String) -> Pelicula? {
            let parts = str.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 3,
                  let año = Int(parts[2]),
                  año >= 1895 && año <= añoActual else { return nil }
            return Pelicula(titulo: parts[0], director: parts[1], estreno: año)
        }

        guard let p1 = parsePelicula(peliculas[0]),
              let p2 = parsePelicula(peliculas[1]) else {
            throw ExerciseError.invalidInput("Formato incorrecto o año inválido (1895-\(añoActual))")
        }

        return """
        ═══════════════════════════════════════════
        CLASE PELICULA - 3 MÉTODOS
        ═══════════════════════════════════════════

        final class Pelicula {
            let titulo, director: String
            let estreno: Int

            func descripcion() -> String
            func mismoDirector(que: Pelicula) -> Bool
            func mismaDecada(que: Pelicula) -> Bool
        }

        ───────────────────────────────────────────
        Película 1: \(p1.descripcion())
        Película 2: \(p2.descripcion())

        ───────────────────────────────────────────
        COMPARACIONES:
        Mismo director: \(p1.mismoDirector(que: p2) ? "Sí" : "No")
        Misma década: \(p1.mismaDecada(que: p2) ? "Sí" : "No")
        ═══════════════════════════════════════════
        """
    }
}
