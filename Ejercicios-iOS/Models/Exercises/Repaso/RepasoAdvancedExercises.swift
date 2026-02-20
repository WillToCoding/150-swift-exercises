//
//  RepasoAdvancedExercises.swift
//  Ejercicios-iOS
//
//  Repaso - Ejercicios 21-35
//  Nivel: Intermedio-Avanzado
//

import Foundation

// MARK: - Ejercicio 21: Filtrar Vectores por Magnitud
// Usa Repaso_Exercise12.Vector y la extension magnitud() del ejercicio 16

struct Repaso_Exercise21: ExecutableExercise {
    let exerciseId = 21

    /// Función que pide el enunciado: filtra vectores cuya magnitud sea ≤ límite
    /// Usa el struct Vector del ejercicio 12 y el método magnitud() del ejercicio 16
    func filtrarVectores(_ vectores: [Repaso_Exercise12.Vector], limite: Double) -> [Repaso_Exercise12.Vector] {
        vectores.filter { $0.magnitud() <= limite }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Parsear: x1,y1;x2,y2;x3,y3 | límite
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: x1,y1;x2,y2;... | límite")
        }

        // Parsear límite
        guard let limite = Double(parts[1]) else {
            throw ExerciseError.invalidInput("El límite debe ser un número válido")
        }

        guard limite >= 0 && limite <= 150 else {
            throw ExerciseError.outOfRange("El límite debe estar entre 0 y 150")
        }

        // Parsear vectores (separados por ;)
        let vectoresStr = parts[0].split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }

        guard vectoresStr.count >= 2 && vectoresStr.count <= 20 else {
            throw ExerciseError.invalidInput("Entre 2 y 20 vectores")
        }

        var vectores: [Repaso_Exercise12.Vector] = []
        let rango = -100.0...100.0

        for vStr in vectoresStr {
            let coords = vStr.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
            guard coords.count == 2 else {
                throw ExerciseError.invalidInput("Cada vector debe tener 2 componentes (x,y)")
            }
            guard rango.contains(coords[0]) && rango.contains(coords[1]) else {
                throw ExerciseError.outOfRange("Coordenadas deben estar entre -100 y 100")
            }
            vectores.append(Repaso_Exercise12.Vector(x: coords[0], y: coords[1]))
        }

        // Llamar a la función que pide el enunciado
        let filtrados = filtrarVectores(vectores, limite: limite)

        // Formatear salida
        let formato = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))

        let todosStr = vectores.map { v in
            let mag = v.magnitud()
            let cumple = mag <= limite ? "✓" : "✗"
            return "(\(Int(v.x)), \(Int(v.y))) → magnitud: \(mag.formatted(formato)) \(cumple)"
        }.joined(separator: "\n")

        let filtradosStr = filtrados.isEmpty
            ? "Ninguno"
            : filtrados.map { "(\(Int($0.x)), \(Int($0.y)))" }.joined(separator: ", ")

        return """
        FILTRAR VECTORES POR MAGNITUD
        ═══════════════════════════════════════
        Límite: \(limite.formatted(formato))

        Vectores:
        \(todosStr)

        ───────────────────────────────────────
        Filtrados (magnitud ≤ \(limite.formatted(formato))): \(filtradosStr)
        Total: \(filtrados.count) de \(vectores.count)
        """
    }
}

// MARK: - Ejercicio 22: Aplicar Descuento Carrito

// 1. Extension en CarritoDeCompras
// Reutilizamos la clase del ejercicio 13
extension Repaso_Exercise13.CarritoDeCompras {
    // Calcula el descuento sobre el total y lo resta
    func aplicarDescuento(porcentaje: Double) {
        let descuento = total * porcentaje / 100
        total -= descuento
    }
}

struct Repaso_Exercise22: ExecutableExercise {
    let exerciseId = 22

    @MainActor
    func execute(input: String) async throws -> String {
        // 2. Input: Manzanas:2.50, Leche:1.20, Pan:0.80 | 10, 20
        // Items antes del "|", descuentos después
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidInput("Formato: item1:precio1, item2:precio2 | descuento1, descuento2")
        }

        // 3. Validar items: mínimo 2, máximo 20, precio > 0
        let itemsStr = parts[0].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard itemsStr.count >= 2 else {
            throw ExerciseError.invalidInput("Mínimo 2 items")
        }

        let carrito = Repaso_Exercise13.CarritoDeCompras()

        for itemStr in itemsStr {
            let datos = itemStr.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard datos.count == 2,
                  let precio = Double(datos[1]),
                  precio > 0 else {
                throw ExerciseError.invalidInput("Formato: nombre:precio (precio > 0)")
            }
            guard carrito.items.count < 20 || carrito.items.contains(where: { $0.nombre == datos[0] }) else {
                throw ExerciseError.invalidInput("Máximo 20 items diferentes")
            }
            carrito.añadir(item: datos[0], precio: precio)
        }

        // 4. Validar descuentos: mínimo 2, máximo 4, cada uno entre 1% y 50%
        let descuentosStr = parts[1].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let descuentos = descuentosStr.compactMap { Double($0) }
        guard descuentos.count >= 2 && descuentos.count <= 4 else {
            throw ExerciseError.invalidInput("Entre 2 y 4 descuentos")
        }
        guard descuentos.allSatisfy({ $0 >= 1 && $0 <= 50 }) else {
            throw ExerciseError.invalidInput("Cada descuento entre 1% y 50%")
        }

        // 5. Mostrar carrito original
        let formato = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
        var resultado = "CARRITO DE COMPRAS\n"
        resultado += carrito.mostrarResumen()

        // 6. Aplicar descuentos sucesivos
        resultado += "\n\nDESCUENTOS SUCESIVOS:"
        for (i, porcentaje) in descuentos.enumerated() {
            let totalAntes = carrito.total
            carrito.aplicarDescuento(porcentaje: porcentaje)
            resultado += "\n\(i + 1). -\(Int(porcentaje))%: \(totalAntes.formatted(formato))€ → \(carrito.total.formatted(formato))€"
        }

        // 7. Mostrar total final
        resultado += "\n\nTOTAL FINAL: \(carrito.total.formatted(formato))€"

        return resultado
    }
}

// MARK: - Ejercicio 23: Frecuencia de Palabras
// Reutiliza Exercise19 de Algoritmia

struct Repaso_Exercise23: ExecutableExercise {
    let exerciseId = 23

    @MainActor
    func execute(input: String) async throws -> String {
        try await Exercise19().execute(input: input)
    }
}

// MARK: - Ejercicio 24: Fábrica de Café con Clases
// Clase Cafetera que prepara tazas con cafeína aleatoria
// Tipos: expreso, americano, capuchino
// Ocasionalmente incluye muestra de nuevo sabor

struct Repaso_Exercise24: ExecutableExercise {
    let exerciseId = 24

    // Enumeración para tipos de café
    enum TipoCafe: String, CaseIterable {
        case expreso, americano, capuchino

        var rangoСafeina: ClosedRange<Int> {
            switch self {
            case .expreso:   return 60...80
            case .americano: return 80...120
            case .capuchino: return 40...60
            }
        }

        var nombre: String { rawValue.capitalized }
    }

    // Clase Taza de café
    final class TazaCafe {
        let tipo: TipoCafe
        let cafeina: Int
        let saborMuestra: String?

        init(tipo: TipoCafe, cafeina: Int, saborMuestra: String? = nil) {
            self.tipo = tipo
            self.cafeina = cafeina
            self.saborMuestra = saborMuestra
        }

        func descripcion() -> String {
            var desc = "\(tipo.nombre) - \(cafeina) mg cafeína"
            if let sabor = saborMuestra {
                desc += " + muestra de \(sabor)"
            }
            return desc
        }
    }

    // Clase principal: Cafetera
    final class Cafetera {
        let nombre: String
        private let saboresDisponibles = ["vainilla", "caramelo", "avellana", "canela", "chocolate"]
        private(set) var tazasPreparadas: [TazaCafe] = []

        init(nombre: String) {
            self.nombre = nombre
        }

        func prepararCafe(tipo: TipoCafe) -> TazaCafe {
            // Cafeína aleatoria según el tipo
            let cafeina = Int.random(in: tipo.rangoСafeina)

            // 30% de probabilidad de incluir muestra de nuevo sabor
            let incluyeMuestra = Int.random(in: 1...10) <= 3
            let sabor = incluyeMuestra ? saboresDisponibles.randomElement() : nil

            let taza = TazaCafe(tipo: tipo, cafeina: cafeina, saborMuestra: sabor)
            tazasPreparadas.append(taza)
            return taza
        }

        func prepararConSimulacion(tipo: TipoCafe, numero: Int) -> (taza: TazaCafe, mensaje: String) {
            let taza = prepararCafe(tipo: tipo)
            let mensaje = "Preparando \(tipo.nombre)...\n  \(numero). \(taza.descripcion())"
            return (taza, mensaje)
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let params = input.trimmingCharacters(in: .whitespaces).lowercased()
        guard !params.isEmpty else {
            throw ExerciseError.emptyInput
        }

        // Formato: tipo,cantidad;tipo,cantidad;...
        let pedidos = params.split(separator: ";").map { $0.trimmingCharacters(in: .whitespaces) }
        let cafetera = Cafetera(nombre: "Cafetera WillToCoding")
        var tazas: [TazaCafe] = []
        var tiposUsados: Set<TipoCafe> = []
        var simulacion = ""
        var contador = 1

        for pedido in pedidos {
            let parts = pedido.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            guard parts.count == 2 else {
                throw ExerciseError.invalidInput("Formato: tipo,cantidad;tipo,cantidad")
            }

            guard let tipo = TipoCafe(rawValue: parts[0]) else {
                let tipos = TipoCafe.allCases.map { $0.rawValue }.joined(separator: ", ")
                throw ExerciseError.invalidInput("Tipos válidos: \(tipos)")
            }

            guard !tiposUsados.contains(tipo) else {
                throw ExerciseError.invalidInput("Tipo '\(tipo.nombre)' ya pedido")
            }
            tiposUsados.insert(tipo)

            guard let cantidad = Int(parts[1]), cantidad >= 1 else {
                throw ExerciseError.invalidInput("Cantidad debe ser un número >= 1")
            }

            guard tazas.count + cantidad <= 10 else {
                throw ExerciseError.outOfRange("Máximo 10 tazas en total")
            }

            for _ in 1...cantidad {
                let (taza, mensaje) = cafetera.prepararConSimulacion(tipo: tipo, numero: contador)
                tazas.append(taza)
                simulacion += mensaje + "\n"
                contador += 1
            }
        }

        let conMuestra = tazas.filter { $0.saborMuestra != nil }.count
        let cafeinaTotal = tazas.reduce(0) { $0 + $1.cafeina }
        let cafeinaPromedio = tazas.isEmpty ? 0 : cafeinaTotal / tazas.count

        return """
        FÁBRICA DE CAFÉ - \(cafetera.nombre)
        ═══════════════════════════════════════════

        SIMULACIÓN:
        ─────────────────────────────────────────
        \(simulacion)
        RESUMEN:
        ─────────────────────────────────────────
        Total: \(tazas.count) | Con muestra: \(conMuestra) | Cafeína: \(cafeinaTotal) mg (media: \(cafeinaPromedio) mg)
        """
    }
}

// MARK: - Ejercicio 25: Sistema Hospital (Structs)

struct Repaso_Exercise25: ExecutableExercise {
    let exerciseId = 25

    // MARK: - Protocolos

    /// Personal del hospital (nombre)
    protocol Personal {
        var nombre: String { get }
    }

    /// Personal con especialidad médica
    protocol Especialista {
        var especialidad: String { get }
    }

    // MARK: - Structs según enunciado

    /// Doctor (nombre, especialidad)
    struct Doctor: Personal, Especialista {
        let nombre: String
        let especialidad: String
    }

    /// Enfermero (nombre, turno)
    struct Enfermero: Personal {
        let nombre: String
        let turno: String
    }

    /// Paciente (nombre, edad, diagnóstico)
    struct Paciente {
        let nombre: String
        let edad: Int
        let diagnostico: String
    }

    /// Sala (número, lista de pacientes)
    struct Sala {
        let numero: Int
        var pacientes: [Paciente]
    }

    /// Hospital (varias salas)
    struct Hospital {
        let nombre: String
        var salas: [Sala]
    }

    // MARK: - Funciones del enunciado

    /// Listado de doctores por especialidad
    func doctoresPorEspecialidad(_ doctores: [Doctor], _ especialidad: String) -> [Doctor] {
        let espNormalizada = especialidad.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        return doctores.filter {
            $0.especialidad.lowercased().folding(options: .diacriticInsensitive, locale: .current)
                .contains(espNormalizada)
        }
    }

    /// Contar pacientes críticos
    func contarPacientesCriticos(_ hospital: Hospital) -> Int {
        hospital.salas.flatMap { $0.pacientes }.filter { esCritico($0) }.count
    }

    /// Detecta si un paciente es crítico por su diagnóstico
    func esCritico(_ paciente: Paciente) -> Bool {
        let palabras = ["infarto", "severa", "agudo", "politraumatismo"]
        let diag = paciente.diagnostico.lowercased()
        return palabras.contains { diag.contains($0) }
    }

    // MARK: - Execute

    @MainActor
    func execute(input: String) async throws -> String {
        let hospital = Hospital.sample
        let doctores = Doctor.plantillaMedica
        let enfermeros = Enfermero.equipoEnfermeria

        // Doctores agrupados por especialidad (usa función del enunciado)
        let especialidades = Set(doctores.map { $0.especialidad }).sorted()
        let doctoresStr = especialidades.map { esp in
            let lista = doctoresPorEspecialidad(doctores, esp)
            let nombres = lista.map { "  - \($0.nombre)" }.joined(separator: "\n")
            return "\(esp):\n\(nombres)"
        }.joined(separator: "\n\n")

        // Enfermeros
        let enfermerosStr = enfermeros.map { "  - \($0.nombre) (turno \($0.turno))" }.joined(separator: "\n")

        // Salas con pacientes
        let salasStr = hospital.salas.map { sala in
            let pacientesStr = sala.pacientes.map { p in
                let marca = esCritico(p) ? " [CRÍTICO]" : ""
                return "  - \(p.nombre), \(p.edad) años - \(p.diagnostico)\(marca)"
            }.joined(separator: "\n")
            return "Sala \(sala.numero):\n\(pacientesStr)"
        }.joined(separator: "\n\n")

        // Estadísticas (usa función del enunciado)
        let totalPacientes = hospital.salas.flatMap { $0.pacientes }.count
        let pacientesCriticos = contarPacientesCriticos(hospital)

        return """
        ═══════════════════════════════════════════════════════
        \(hospital.nombre.uppercased())
        ═══════════════════════════════════════════════════════

        DOCTORES POR ESPECIALIDAD
        ───────────────────────────────────────────────────────
        \(doctoresStr)

        ───────────────────────────────────────────────────────
        ENFERMEROS
        ───────────────────────────────────────────────────────
        \(enfermerosStr)

        ───────────────────────────────────────────────────────
        SALAS Y PACIENTES
        ───────────────────────────────────────────────────────
        \(salasStr)

        ───────────────────────────────────────────────────────
        ESTADISTICAS
        ───────────────────────────────────────────────────────
        Total pacientes: \(totalPacientes)
        Pacientes críticos: \(pacientesCriticos)
        ═══════════════════════════════════════════════════════
        """
    }
}

// MARK: - Extension Doctor (Datos de prueba)
extension Repaso_Exercise25.Doctor {
    @MainActor static let drGomez = Repaso_Exercise25.Doctor(nombre: "Dr. Alberto Gómez", especialidad: "Cardiología")
    @MainActor static let draVazquez = Repaso_Exercise25.Doctor(nombre: "Dra. Elena Vázquez", especialidad: "Cardiología")
    @MainActor static let draPueyo = Repaso_Exercise25.Doctor(nombre: "Dra. Marina Pueyo", especialidad: "Pediatría")
    @MainActor static let drSerrano = Repaso_Exercise25.Doctor(nombre: "Dr. Hugo Serrano", especialidad: "Pediatría")
    @MainActor static let drLorca = Repaso_Exercise25.Doctor(nombre: "Dr. Julián Lorca", especialidad: "Traumatología")
    @MainActor static let draMendez = Repaso_Exercise25.Doctor(nombre: "Dra. Sara Méndez", especialidad: "Traumatología")

    @MainActor static let plantillaMedica: [Repaso_Exercise25.Doctor] = [
        drGomez, draVazquez, draPueyo, drSerrano, drLorca, draMendez
    ]
}

// MARK: - Extension Enfermero (Datos de prueba)
extension Repaso_Exercise25.Enfermero {
    @MainActor static let martaR = Repaso_Exercise25.Enfermero(nombre: "Marta Rodríguez", turno: "noche")
    @MainActor static let javierL = Repaso_Exercise25.Enfermero(nombre: "Javier López", turno: "mañana")
    @MainActor static let soniaG = Repaso_Exercise25.Enfermero(nombre: "Sonia García", turno: "tarde")

    @MainActor static let equipoEnfermeria: [Repaso_Exercise25.Enfermero] = [martaR, javierL, soniaG]
}

// MARK: - Extension Paciente (Datos de prueba)
extension Repaso_Exercise25.Paciente {
    @MainActor static let ricardoTena = Repaso_Exercise25.Paciente(nombre: "Ricardo Tena", edad: 68, diagnostico: "Infarto agudo de miocardio")
    @MainActor static let luciaVillares = Repaso_Exercise25.Paciente(nombre: "Lucía Villares", edad: 4, diagnostico: "Insuficiencia respiratoria severa")
    @MainActor static let marcosSoler = Repaso_Exercise25.Paciente(nombre: "Marcos Soler", edad: 29, diagnostico: "Politraumatismo craneoencefálico")
    @MainActor static let beatrizCano = Repaso_Exercise25.Paciente(nombre: "Beatriz Cano", edad: 72, diagnostico: "Post-operatorio bypass")
    @MainActor static let ikerCasado = Repaso_Exercise25.Paciente(nombre: "Iker Casado", edad: 12, diagnostico: "Recuperación apendicectomía")
    @MainActor static let elenaPozo = Repaso_Exercise25.Paciente(nombre: "Elena Pozo", edad: 45, diagnostico: "Fractura de fémur")
}

// MARK: - Extension Sala (Datos de prueba)
extension Repaso_Exercise25.Sala {
    @MainActor static let sala101 = Repaso_Exercise25.Sala(
        numero: 101,
        pacientes: [.ricardoTena, .beatrizCano]
    )
    @MainActor static let sala204 = Repaso_Exercise25.Sala(
        numero: 204,
        pacientes: [.luciaVillares, .ikerCasado]
    )
    @MainActor static let sala305 = Repaso_Exercise25.Sala(
        numero: 305,
        pacientes: [.marcosSoler, .elenaPozo]
    )
}

// MARK: - Extension Hospital (Datos de prueba)
extension Repaso_Exercise25.Hospital {
    @MainActor static let sample = Repaso_Exercise25.Hospital(
        nombre: "Hospital Mariano Barbacid",
        salas: [.sala101, .sala204, .sala305]
    )
}

// MARK: - Ejercicio 26: Juego de Personajes
// Clase Personaje (nombre, salud) con métodos morir() y saludar()
// Subclases: Arquero (disparar), Guerrero (defender), Hechicero (curar)
// Enumeración Accion con valores asociados para definir tipos de acción

struct Repaso_Exercise26: ExecutableExercise {
    let exerciseId = 26

    // MARK: - Enumeración Accion (con valores asociados)
    enum Accion {
        case ataque(daño: Int, critico: Bool)
        case defensa(bloqueado: Int)
        case curacion(cantidad: Int)
    }

    // MARK: - Clase base Personaje
    class Personaje {
        let nombre: String
        let saludMaxima: Int
        var salud: Int

        init(nombre: String, salud: Int) {
            self.nombre = nombre
            self.saludMaxima = salud
            self.salud = salud
        }

        // Tipo de personaje
        var tipo: String { "Personaje" }

        // Método saludar (enunciado)
        func saludar() -> String {
            "Hola, soy \(nombre) y tengo \(salud) de salud."
        }

        // Método morir (enunciado)
        func morir() -> String {
            "\(nombre) ha caido en batalla..."
        }

        // Ataque base
        func atacar() -> (daño: Int, critico: Bool, mensaje: String) {
            let daño = Int.random(in: 10...20)
            return (daño, false, "\(nombre) ataca -> \(daño) de daño")
        }

        // Recibir daño (puede ser overrideado)
        func recibirDaño(_ cantidad: Int) -> (recibido: Int, bloqueado: Int, mensaje: String?) {
            salud = max(0, salud - cantidad)
            return (cantidad, 0, nil)
        }
    }

    // MARK: - Arquero (habilidad: disparar con crítico)
    final class Arquero: Personaje {
        let precision: Int  // % probabilidad de crítico

        init(nombre: String, salud: Int, precision: Int) {
            self.precision = precision
            super.init(nombre: nombre, salud: salud)
        }

        override var tipo: String { "Arquero" }

        /// Habilidad específica del Arquero (enunciado) - devuelve Accion
        func disparar() -> Accion {
            let daño = Int.random(in: 15...25)
            let critico = Int.random(in: 1...100) <= precision
            return .ataque(daño: critico ? daño * 2 : daño, critico: critico)
        }

        /// Override que usa la habilidad disparar()
        override func atacar() -> (daño: Int, critico: Bool, mensaje: String) {
            if case .ataque(let daño, let critico) = disparar() {
                let mensaje = critico
                    ? "\(nombre) dispara ¡CRÍTICO! -> \(daño) de daño"
                    : "\(nombre) dispara -> \(daño) de daño"
                return (daño, critico, mensaje)
            }
            return (0, false, "")
        }
    }

    // MARK: - Guerrero (capacidad: defender)
    final class Guerrero: Personaje {
        let defensa: Int

        init(nombre: String, salud: Int, defensa: Int) {
            self.defensa = defensa
            super.init(nombre: nombre, salud: salud)
        }

        override var tipo: String { "Guerrero" }

        // Método defender (enunciado) - devuelve Accion
        func defender() -> Accion {
            let bloqueado = Int.random(in: defensa/2...defensa)
            return .defensa(bloqueado: bloqueado)
        }

        override func atacar() -> (daño: Int, critico: Bool, mensaje: String) {
            let daño = Int.random(in: 18...28)
            return (daño, false, "\(nombre) ataca con espada -> \(daño) de daño")
        }

        override func recibirDaño(_ cantidad: Int) -> (recibido: Int, bloqueado: Int, mensaje: String?) {
            if case .defensa(let bloqueado) = defender() {
                let dañoReal = max(0, cantidad - bloqueado)
                salud = max(0, salud - dañoReal)
                let mensaje = "\(nombre) bloquea \(bloqueado) de daño"
                return (dañoReal, bloqueado, mensaje)
            }
            return (cantidad, 0, nil)
        }
    }

    // MARK: - Hechicero (habilidad: curar)
    final class Hechicero: Personaje {
        let poderCuracion: Int

        init(nombre: String, salud: Int, poderCuracion: Int) {
            self.poderCuracion = poderCuracion
            super.init(nombre: nombre, salud: salud)
        }

        override var tipo: String { "Hechicero" }

        // Método curar (enunciado) - devuelve Accion
        func curar() -> Accion {
            let curacion = Int.random(in: poderCuracion/2...poderCuracion)
            return .curacion(cantidad: curacion)
        }

        override func atacar() -> (daño: Int, critico: Bool, mensaje: String) {
            let daño = Int.random(in: 12...22)
            return (daño, false, "\(nombre) lanza hechizo -> \(daño) de daño")
        }

        override func recibirDaño(_ cantidad: Int) -> (recibido: Int, bloqueado: Int, mensaje: String?) {
            let saludAntes = salud
            salud = max(0, salud - cantidad)

            // Se cura después de recibir daño (si sigue vivo)
            if salud > 0, case .curacion(let curacion) = curar() {
                let saludAntesDeCurar = salud
                salud = min(saludMaxima, salud + curacion)
                let curado = salud - saludAntesDeCurar
                if curado > 0 {
                    // Devuelve daño NETO (daño - curación) para que el cálculo de saludAntes funcione
                    let dañoNeto = saludAntes - salud
                    return (dañoNeto, 0, "\(nombre) se cura -> +\(curado) de salud (Salud: \(saludAntesDeCurar) -> \(salud))")
                }
            }
            return (cantidad, 0, nil)
        }
    }

    // MARK: - Ejecución
    @MainActor
    func execute(input: String) async throws -> String {
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces).lowercased() }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: tipo1 | tipo2 (arquero, guerrero, hechicero)")
        }

        func crearPersonaje(_ tipo: String, sufijo: String = "") -> Personaje? {
            switch tipo {
            case "arquero": return Arquero.sampleArcher(sufijo: sufijo)
            case "guerrero": return Guerrero.sampleWarrior(sufijo: sufijo)
            case "hechicero": return Hechicero.sampleSorcerer(sufijo: sufijo)
            default: return nil
            }
        }

        let mismoTipo = parts[0] == parts[1]
        guard let p1 = crearPersonaje(parts[0], sufijo: mismoTipo ? " I" : ""),
              let p2 = crearPersonaje(parts[1], sufijo: mismoTipo ? " II" : "") else {
            throw ExerciseError.invalidInput("Tipos válidos: arquero, guerrero, hechicero")
        }

        var log: [String] = []
        var criticosP1 = 0
        var criticosP2 = 0


        log.append("───────────────────────────────────────────────────")
        log.append("COMBATE")
        // Saludos (enunciado)
        log.append(p1.saludar())
        log.append(p2.saludar())
        log.append("───────────────────────────────────────────────────")

        var turno = 0
        let maxTurnos = 20

        // Función auxiliar: atacante ataca a defensor
        // Devuelve (criticos, muerto) para actualizar contadores
        func procesarAtaque(atacante: Personaje, defensor: Personaje) -> (critico: Bool, muerto: Bool) {
            let ataque = atacante.atacar()
            log.append("  \(ataque.mensaje)")

            let defensa = defensor.recibirDaño(ataque.daño)
            if let mensaje = defensa.mensaje {
                log.append("  \(mensaje)")
            }

            // recibido = daño neto (funciona para Base, Guerrero y Hechicero)
            let saludAntes = defensor.salud + defensa.recibido
            log.append("     \(defensor.nombre) recibe \(defensa.recibido) -> Salud: \(saludAntes) -> \(defensor.salud)")

            if defensor.salud == 0 {
                log.append("  \(defensor.morir())")
                return (ataque.critico, true)
            }
            return (ataque.critico, false)
        }

        while p1.salud > 0 && p2.salud > 0 && turno < maxTurnos {
            turno += 1
            log.append("")
            log.append("Turno \(turno):")

            // P1 ataca a P2
            let resultado1 = procesarAtaque(atacante: p1, defensor: p2)
            if resultado1.critico { criticosP1 += 1 }
            if resultado1.muerto { break }

            // P2 ataca a P1
            let resultado2 = procesarAtaque(atacante: p2, defensor: p1)
            if resultado2.critico { criticosP2 += 1 }
            log.append("")
            if resultado2.muerto { break }
        }

        // Resultado
        log.append("")
        log.append("───────────────────────────────────────────────────")
        log.append("RESULTADO")
        log.append("───────────────────────────────────────────────────")

        if turno >= maxTurnos && p1.salud > 0 && p2.salud > 0 {
            // Límite de turnos alcanzado
            log.append("Límite de turnos alcanzado (\(maxTurnos))")
            if p1.salud == p2.salud {
                log.append("Empate: ambos con \(p1.salud) de salud")
            } else {
                let (ganador, perdedor) = p1.salud > p2.salud ? (p1, p2) : (p2, p1)
                log.append("Ganador por salud: \(ganador.nombre) (\(ganador.salud) vs \(perdedor.salud))")
            }
        } else {
            // Alguien murió
            let (ganador, perdedor) = p1.salud > 0 ? (p1, p2) : (p2, p1)
            log.append("Ganador: \(ganador.nombre) (Salud: \(ganador.salud))")
            log.append("Perdedor: \(perdedor.nombre) (Salud: 0)")
        }

        var stats = "Turnos: \(turno)"
        if criticosP1 > 0 { stats += " | Críticos \(p1.nombre): \(criticosP1)" }
        if criticosP2 > 0 { stats += " | Críticos \(p2.nombre): \(criticosP2)" }
        log.append(stats)

        return log.joined(separator: "\n")
    }
}

// MARK: - Extension Arquero (Datos de prueba)
extension Repaso_Exercise26.Arquero {
    static func sampleArcher(sufijo: String = "") -> Repaso_Exercise26.Arquero {
        Repaso_Exercise26.Arquero(nombre: "Arquero" + sufijo, salud: 85, precision: 50)
    }
}

// MARK: - Extension Guerrero (Datos de prueba)
extension Repaso_Exercise26.Guerrero {
    static func sampleWarrior(sufijo: String = "") -> Repaso_Exercise26.Guerrero {
        Repaso_Exercise26.Guerrero(nombre: "Guerrero" + sufijo, salud: 100, defensa: 8)
    }
}

// MARK: - Extension Hechicero (Datos de prueba)
extension Repaso_Exercise26.Hechicero {
    static func sampleSorcerer(sufijo: String = "") -> Repaso_Exercise26.Hechicero {
        Repaso_Exercise26.Hechicero(nombre: "Hechicero" + sufijo, salud: 90, poderCuracion: 18)
    }
}

// MARK: - Ejercicio 27: Índices de Palabras

struct Repaso_Exercise27: ExecutableExercise {
    let exerciseId = 27

    func indicesPalabras(_ frase: String) -> [String: [Int]] {
        let palabras = frase.lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }

        var indices: [String: [Int]] = [:]
        for (index, palabra) in palabras.enumerated() {
            indices[palabra, default: []].append(index)
        }

        return indices
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let indices = indicesPalabras(trimmed)
        let totalPalabras = indices.values.reduce(0) { $0 + $1.count }

        guard totalPalabras >= 2 else {
            throw ExerciseError.invalidInput("Ingresa una frase (minimo 2 palabras)")
        }

        guard totalPalabras <= 50 else {
            throw ExerciseError.outOfRange("Maximo 50 palabras")
        }

        let result = indices
            .sorted { $0.value.first ?? 0 < $1.value.first ?? 0 }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: "\n")

        return """
        INDICES DE PALABRAS
        ───────────────────
        \(result)
        """
    }
}

// MARK: - Ejercicio 28: Número a Romano

struct Repaso_Exercise28: ExecutableExercise {
    let exerciseId = 28

    /// Convierte un entero (1-3999) a número romano
    func convertirARomano(_ numero: Int) -> String {
        // Tabla ordenada de mayor a menor, incluye casos de sustracción (CM, CD, XC, XL, IX, IV)
        let valores = [
            (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
            (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
            (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")
        ]

        var resultado = ""
        var n = numero

        for (valor, simbolo) in valores {
            while n >= valor {
                resultado += simbolo
                n -= valor
            }
        }

        return resultado
    }

    @MainActor
    func execute(input: String) async throws -> String {
        guard let numero = Int(input.trimmingCharacters(in: .whitespaces)),
              numero >= 1, numero <= 3999 else {
            throw ExerciseError.invalidInput("Ingresa un número entre 1 y 3999")
        }

        let romano = convertirARomano(numero)

        return """
        CONVERSIÓN A ROMANO
        ───────────────────
        Número: \(numero)
        Romano: \(romano)
        """
    }
}

// MARK: - Ejercicio 29: Lectura de Archivo (Simulado)
// Demuestra manejo de errores con:
// 1. Enumeración conformando a LocalizedError
// 2. Typed throws: throws(FileError)
// 3. do-try-catch con catches específicos por caso

struct Repaso_Exercise29: ExecutableExercise {
    let exerciseId = 29
    
    // MARK: - Struct para archivo simulado
    struct ArchivoSimulado {
        let nombre: String
        let contenido: String
    }

    // MARK: - Enum de errores (LocalizedError)
    // LocalizedError provee mensajes localizados que describen el error
    enum FileError: LocalizedError {
        case archivoODirectorioNoEncontrado(String)
        case archivoBinario(String)
        case permisoDenegado(String)
        case esDirectorio(String)

        // Propiedad requerida por LocalizedError
        var errorDescription: String? {
            switch self {
            case .archivoODirectorioNoEncontrado(let nombre):
                "El archivo o directorio '\(nombre)' no existe"
            case .archivoBinario(let nombre):
                "El archivo '\(nombre)' es binario, no se puede leer como texto"
            case .permisoDenegado(let nombre):
                "Permiso denegado para leer '\(nombre)'"
            case .esDirectorio(let nombre):
                "'\(nombre)' es un directorio, no un archivo"
            }
        }
    }

    // MARK: - Función con Typed Throws (como pide el enunciado)
    // throws(FileError) limita los errores que puede lanzar esta función
    // Beneficio: el compilador sabe exactamente qué tipo de error esperar
    @MainActor
    func leerArchivo(_ nombre: String) throws(FileError) -> String {
        guard !ArchivoSimulado.directorios.contains(nombre) else {
            throw .esDirectorio(nombre)
        }

        guard !ArchivoSimulado.archivosProtegidos.contains(nombre) else {
            throw .permisoDenegado(nombre)
        }

        guard !ArchivoSimulado.archivosBinarios.contains(nombre) else {
            throw .archivoBinario(nombre)
        }

        guard let archivo = ArchivoSimulado.sistemaArchivos[nombre] else {
            throw .archivoODirectorioNoEncontrado(nombre)
        }

        return archivo.contenido
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let filename = input.trimmingCharacters(in: .whitespaces).lowercased()

        guard !filename.isEmpty else {
            throw ExerciseError.emptyInput
        }

        do {
            let contenido = try leerArchivo(filename)
            return """
            LECTURA DE '\(filename)'
            ════════════════════════════════════════

            \(contenido)
            """
        } catch {
            return """
            ERROR EN '\(filename)'
            ════════════════════════════════════════

            \(error.localizedDescription)
            """
        }
    }
}

// MARK: - Extension ArchivoSimulado (Datos de prueba)
extension Repaso_Exercise29.ArchivoSimulado {
    // Directorios de ejemplo
    @MainActor static let directorios: Set<String> = [
        "/users", "/applications", "desktop/"
    ]

    // Archivos protegidos (permiso denegado)
    @MainActor static let archivosProtegidos: Set<String> = [
        "/private/etc/sudoers"
    ]

    // Archivos binarios de ejemplo
    @MainActor static let archivosBinarios: Set<String> = [
        "foto.jpeg", "imagen.png"
    ]

    // Archivos de texto válidos
    @MainActor static let holaMundo = Repaso_Exercise29.ArchivoSimulado(
        nombre: "holamundo.swift",
        contenido: "import Foundation\n\nprint(\"¡Hola Mundo!\")"
    )

    @MainActor static let datosJson = Repaso_Exercise29.ArchivoSimulado(
        nombre: "datos.json",
        contenido: "{\n  \"usuarios\": 150,\n  \"activos\": 89\n}"
    )

    @MainActor static let readme = Repaso_Exercise29.ArchivoSimulado(
        nombre: "readme.md",
        contenido: "# Proyecto\n\nBienvenido al proyecto de ejercicios."
    )

    @MainActor static let vacio = Repaso_Exercise29.ArchivoSimulado(
        nombre: "vacio.txt",
        contenido: ""
    )

    // Sistema de archivos simulado
    @MainActor static let sistemaArchivos: [String: Repaso_Exercise29.ArchivoSimulado] = [
        holaMundo.nombre: holaMundo,
        datosJson.nombre: datosJson,
        readme.nombre: readme,
        vacio.nombre: vacio
    ]
}

// MARK: - Ejercicio 30: Closures como Parámetros
// Función que recibe array + closure condición. Muestra 4 formas de pasar closures.

struct Repaso_Exercise30: ExecutableExercise {
    let exerciseId = 30

    /// Función que filtra números según una condición (closure)
    func filtrar(numeros: [Int], condicion: (Int) -> Bool) -> [Int] {
        numeros.filter { condicion($0) }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let numeros = input.split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        guard numeros.count >= 2 else {
            throw ExerciseError.invalidInput("Ingresa al menos 2 números separados por coma")
        }
        guard numeros.count <= 20 else {
            throw ExerciseError.outOfRange("Máximo 20 números")
        }

        // 1. Closure declarado antes
        let esPar = { (n: Int) -> Bool in
            n % 2 == 0
        }
        let pares = filtrar(numeros: numeros, condicion: esPar)

        // 2. Closure inline
        let impares = filtrar(numeros: numeros, condicion: { (n: Int) -> Bool in
            n % 2 != 0
        })

        // 3. Trailing closure (media dinámica)
        let media = Double(numeros.reduce(0, +)) / Double(numeros.count)
        let mayoresQueLaMedia = filtrar(numeros: numeros) { (n: Int) -> Bool in
            Double(n) > media
        }

        // 4. Trailing closure shorthand
        let multiplosDe3 = filtrar(numeros: numeros) { $0 % 3 == 0 }

        // Formato para Double
        let formatoMedia = media.formatted(.number.precision(.fractionLength(2)))

        // Helper para mostrar arrays ordenados
        func mostrar(_ arr: [Int]) -> String {
            arr.sorted().map { String($0) }.joined(separator: ", ")
        }

        return """
        ═══════════════════════════════════════════════════════
        CLOSURES COMO PARÁMETROS
        ═══════════════════════════════════════════════════════

        Input:    [\(numeros.map { String($0) }.joined(separator: ", "))]
        Ordenado: [\(mostrar(numeros))]

        Función:
        func filtrar(numeros: [Int], condicion: (Int) -> Bool) -> [Int]

        ───────────────────────────────────────────────────────
        4 FORMAS DE PASAR UN CLOSURE:
        ───────────────────────────────────────────────────────

        1. Closure declarado antes:
           let esPar = { (n: Int) -> Bool in n % 2 == 0 }
           filtrar(numeros: numeros, condicion: esPar)
           → Pares: [\(mostrar(pares))]

        2. Closure inline:
           filtrar(numeros: numeros, condicion: { (n: Int) -> Bool in
               n % 2 != 0
           })
           → Impares: [\(mostrar(impares))]

        3. Trailing closure (completo):
           let media = Double(numeros.reduce(0, +)) / Double(numeros.count)
           filtrar(numeros: numeros) { (n: Int) -> Bool in
               Double(n) > media
           }
           → Media: \(formatoMedia) → Mayores: [\(mostrar(mayoresQueLaMedia))]

        4. Trailing closure (shorthand):
           filtrar(numeros: numeros) { $0 % 3 == 0 }
           → Múltiplos de 3: [\(mostrar(multiplosDe3))]

        ═══════════════════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 31: Intercambiar Valores (inout)
// Define una función intercambiar que reciba dos variables (inout) y las intercambie.
// Versión para Int y otra para String.

struct Repaso_Exercise31: ExecutableExercise {
    let exerciseId = 31

    // Versión para Int
    func intercambiar(_ a: inout Int, _ b: inout Int) {
        let temp = a
        a = b
        b = temp
    }

    // Versión para String
    func intercambiar(_ a: inout String, _ b: inout String) {
        let temp = a
        a = b
        b = temp
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // Formato: valor1,valor2|tipo (int o string)
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidFormat("Formato: valor1,valor2|tipo (int o string)")
        }

        let valores = parts[0].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard valores.count == 2 else {
            throw ExerciseError.invalidInput("Ingresa exactamente dos valores separados por coma")
        }

        let tipo = parts[1].lowercased()

        switch tipo {
        case "int":
            guard var a = Int(valores[0]), var b = Int(valores[1]) else {
                throw ExerciseError.invalidInput("Los valores deben ser enteros")
            }
            let antesA = a
            let antesB = b
            intercambiar(&a, &b)

            return """
            INTERCAMBIO DE ENTEROS (inout)
            ──────────────────────────────
            Antes:   a = \(antesA), b = \(antesB)
            Después: a = \(a), b = \(b)

            Función usada:
            func intercambiar(_ a: inout Int, _ b: inout Int)
            """

        case "string":
            var a = valores[0]
            var b = valores[1]
            let antesA = a
            let antesB = b
            intercambiar(&a, &b)

            return """
            INTERCAMBIO DE STRINGS (inout)
            ──────────────────────────────
            Antes:   a = "\(antesA)", b = "\(antesB)"
            Después: a = "\(a)", b = "\(b)"

            Función usada:
            func intercambiar(_ a: inout String, _ b: inout String)
            """

        default:
            throw ExerciseError.invalidInput("Tipo válido: int o string")
        }
    }
}

// MARK: - Ejercicio 32: Contador con Closure
// Una función que devuelve un closure que captura y mantiene un contador interno

struct Repaso_Exercise32: ExecutableExercise {
    let exerciseId = 32

    /// Función que devuelve un closure.
    /// El closure captura la variable `contador` y la mantiene en memoria
    /// incrementándola cada vez que se invoca.
    func crearContador() -> () -> Int {
        var contador = 0
        return { contador += 1; return contador }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        // 1. Validar entrada
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard let n = Int(trimmed) else {
            throw ExerciseError.invalidInput("Ingresa un número válido")
        }

        // 2. Validar rango (1-10 invocaciones)
        guard n >= 1 && n <= 10 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 10")
        }

        // 3. Crear 2 closures usando nuestra función
        let miContador = crearContador()
        let otroContador = crearContador()  // Cada uno tiene su propio contador

        // 4. Llamar al primer closure N veces
        var log: [String] = []
        log.append("Dos closures creados: miContador y otroContador")
        log.append("Ambos empiezan con contador = 0")
        log.append("")

        var valores: [Int] = []
        for _ in 1...n {
            let valor = miContador()  // Solo incrementa el contador de miContador
            valores.append(valor)
            log.append("miContador() → \(valor)")
        }

        // 5. Llamar al segundo closure (demuestra independencia)
        let valorOtro = otroContador()  // Su contador sigue en 0, retorna 1

        return """
        ═══════════════════════════════════════════
        CLOSURE QUE CAPTURA UN CONTADOR
        ═══════════════════════════════════════════

        Función que devuelve el closure:
        ───────────────────────────────────────────
        func crearContador() -> () -> Int {
            var contador = 0
            return { contador += 1; return contador }
        }
        ───────────────────────────────────────────

        \(log.joined(separator: "\n"))

        ───────────────────────────────────────────
        Evolución del contador: \(valores.map(String.init).joined(separator: " → "))

        ───────────────────────────────────────────
        DEMOSTRACIÓN DE CAPTURA INDEPENDIENTE
        ───────────────────────────────────────────
        Cada closure tiene su propia copia del contador:
        • miContador (después de \(n) llamadas): \(valores.last ?? 0)
        • otroContador (primera llamada): \(valorOtro)

        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 33: Configuración Lazy
// Añade propiedad lazy configuracionDetallada a la clase Vehiculo del ejercicio 8

struct Repaso_Exercise33: ExecutableExercise {
    let exerciseId = 33

    @MainActor
    func execute(input: String) async throws -> String {
        let vehiculos = Repaso_Exercise08.Vehiculo.vehiculos

        guard let seleccion = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número del 1 al 5")
        }

        guard seleccion >= 1 && seleccion <= 5 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 5")
        }

        let vehiculo = vehiculos[seleccion - 1]

        // Accedemos al lazy por primera vez (se crea aquí)
        let config = vehiculo.configuracionDetallada

        return """
        ═══════════════════════════════════════════
        CONFIGURACIÓN DETALLADA (lazy)
        ═══════════════════════════════════════════

        La propiedad se inicializa solo al primer
        acceso, no cuando se crea el vehículo.

        ───────────────────────────────────────────
        VEHÍCULO
        ───────────────────────────────────────────
        Marca: \(vehiculo.marca)
        Modelo: \(vehiculo.modelo)
        Año matriculación: \(vehiculo.año)
        Antigüedad: \(vehiculo.antiguedad) años

        ───────────────────────────────────────────
        ITV (valores capturados en lazy)
        ───────────────────────────────────────────
        Próxima ITV: \(config.proximaITV)
        Color etiqueta: \(config.colorEtiqueta.rawValue)
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 34: Resultado Éxito o Error
// Enum Resultado con valores asociados: exito(String) y error(Error)

struct Repaso_Exercise34: ExecutableExercise {
    let exerciseId = 34

    // 1. Enum con valores asociados (según enunciado)
    enum Resultado<String,Error>{
        case exito(String)
        case error(Error)
    }

    // 2. Enum de errores para validación de contraseña
    enum PasswordError: LocalizedError {
        case vacia
        case muyCorta(Int)
        case sinMayuscula
        case sinMinuscula
        case sinNumero
        case sinCaracterEspecial

        var errorDescription: String? {
            switch self {
            case .vacia:
                "La contraseña está vacía"
            case .muyCorta(let minimo):
                "Mínimo \(minimo) caracteres"
            case .sinMayuscula:
                "Debe contener al menos una mayúscula (A-Z)"
            case .sinMinuscula:
                "Debe contener al menos una minúscula (a-z)"
            case .sinNumero:
                "Debe contener al menos un número (0-9)"
            case .sinCaracterEspecial:
                "Debe contener al menos un carácter especial (no letra, no número, no espacio)"
            }
        }
    }

    // 3. Función que valida una contraseña
    func validarPassword(_ password: String) -> Result<String,PasswordError> {
        guard !password.isEmpty else {
            return .failure(PasswordError.vacia)
        }

        guard password.count >= 8 else {
            return .failure(PasswordError.muyCorta(8))
        }

        guard password.contains(where: { $0.isUppercase }) else {
            return .failure(PasswordError.sinMayuscula)
        }

        guard password.contains(where: { $0.isLowercase }) else {
            return .failure(PasswordError.sinMinuscula)
        }

        guard password.contains(where: { $0.isNumber }) else {
            return .failure(PasswordError.sinNumero)
        }

        // Carácter especial = no es letra, no es número, no es espacio
        guard password.contains(where: { !$0.isLetter && !$0.isNumber && !$0.isWhitespace }) else {
            return .failure(PasswordError.sinCaracterEspecial)
        }

        let mayusculas = password.filter { $0.isUppercase }.count
        let minusculas = password.filter { $0.isLowercase }.count
        let digitos = password.filter { $0.isNumber }.count
        let especiales = password.filter { !$0.isLetter && !$0.isNumber && !$0.isWhitespace }.count

        return .success("Contraseña fuerte: \(password.count) caracteres (\(mayusculas) mayúscula, \(minusculas) minúsculas, \(digitos) dígito, \(especiales) especial)")
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let password = input.trimmingCharacters(in: .whitespaces)

        let resultado = validarPassword(password)

        switch resultado {
        case .success(let mensaje):
            return """
            VALIDACION DE PASSWORD
            ───────────────────────────────────────────
            Entrada: "\(password)"

            REQUISITOS:
            [OK] No está vacía
            [OK] Mínimo 8 caracteres
            [OK] Al menos una mayúscula (A-Z)
            [OK] Al menos una minúscula (a-z)
            [OK] Al menos un número (0-9)
            [OK] Al menos un carácter especial

            RESULTADO: EXITO
            \(mensaje)
            """

        case .failure(let error):
            return """
            VALIDACION DE PASSWORD
            ───────────────────────────────────────────
            Entrada: "\(password)"

            RESULTADO: ERROR
            Tipo: PasswordError
            Descripción: \(error.localizedDescription)

            ───────────────────────────────────────────
            EJEMPLOS:
            "abc"        -> muyCorta(8)
            "abcdefgh"   -> sinMayuscula
            "ABCDEFGH"   -> sinMinuscula
            "Abcdefgh"   -> sinNumero
            "Abcdefg1"   -> sinCaracterEspecial
            "Abcdef1!"   -> EXITO
            """
        }
    }
}

// MARK: - Ejercicio 35: Clase Contador con willSet/didSet
// Demuestra observadores de propiedades con un juego de "llegar a la meta"

struct Repaso_Exercise35: ExecutableExercise {
    let exerciseId = 35

    /// Clase Contador con observadores willSet y didSet
    /// - willSet: se ejecuta ANTES de que el valor cambie (acceso a newValue)
    /// - didSet: se ejecuta DESPUÉS de que el valor cambie (acceso a oldValue)
    class Contador {
        let meta = 10
        var reinicios = 0
        var pasos = 0
        var log: [String] = []
        var metaAlcanzada = false
        private var necesitaReinicio = false
        private var reiniciando = false

        var valor: Int = 0 {
            willSet {
                if !reiniciando {
                    log.append("willSet: \(valor) → \(newValue)")
                }
            }
            didSet {
                if reiniciando {
                    reiniciando = false
                    log.append("       → Reiniciado a 0")
                    return
                }

                if valor >= meta {
                    log.append("didSet: ¡META ALCANZADA!")
                    metaAlcanzada = true
                    return
                }

                // Solo hay peligro de reinicio cuando valor está en 3, 4 o 5
                if (3...5).contains(valor) {
                    let random = Int.random(in: 1...10)
                    if (3...5).contains(random) {
                        log.append("didSet: valor=\(valor) random=\(random) ¡REINICIO!")
                        reinicios += 1
                        necesitaReinicio = true
                    } else {
                        log.append("didSet: valor=\(valor) random=\(random) ¡Salvado!")
                    }
                } else {
                    log.append("didSet: valor=\(valor) (zona segura)")
                }
            }
        }

        func incrementar() {
            pasos += 1
            if necesitaReinicio {
                necesitaReinicio = false
                reiniciando = true
                valor = 0
            } else {
                valor += 1
            }
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let trimmed = input.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            throw ExerciseError.emptyInput
        }

        guard let maxPasos = Int(trimmed), maxPasos >= 10 && maxPasos <= 100 else {
            throw ExerciseError.invalidInput("Ingresa un número entre 10 y 100")
        }

        let contador = Contador()

        // Simular hasta alcanzar la meta o agotar pasos
        while !contador.metaAlcanzada && contador.pasos < maxPasos {
            contador.incrementar()
        }

        let resultado = contador.metaAlcanzada
            ? "¡META ALCANZADA en \(contador.pasos) pasos con \(contador.reinicios) reinicios!"
            : "No se alcanzó la meta en \(maxPasos) pasos (\(contador.reinicios) reinicios)"

        return """
        CONTADOR CON OBSERVADORES (willSet/didSet)
        ════════════════════════════════════════════════
        Meta: 10 | Máx pasos: \(maxPasos)
        ────────────────────────────────────────────────

        \(contador.log.joined(separator: "\n"))

        ────────────────────────────────────────────────
        \(resultado)
        ════════════════════════════════════════════════
        """
    }
}


