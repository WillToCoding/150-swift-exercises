//
//  RepasoIntermediateExercises.swift
//  Ejercicios-iOS
//
//  Repaso - Ejercicios 11-20
//  Nivel: Intermedio
//

import Foundation

// MARK: - Ejercicio 11: Subclases de Película
// PeliculaDigital (URL) y PeliculaEnDVD (duración) heredan de Repaso_Exercise10.Pelicula

struct Repaso_Exercise11: ExecutableExercise {
    let exerciseId = 11

    final class PeliculaDigital: Repaso_Exercise10.Pelicula {
        let urlTransmision: String

        init(titulo: String, director: String, estreno: Int, url: String) {
            self.urlTransmision = url
            super.init(titulo: titulo, director: director, estreno: estreno)
        }

        override func descripcion() -> String {
            "\(super.descripcion()) | \(urlTransmision)"
        }
    }

    final class PeliculaEnDVD: Repaso_Exercise10.Pelicula {
        let duracionDisco: Int

        init(titulo: String, director: String, estreno: Int, duracion: Int) {
            self.duracionDisco = duracion
            super.init(titulo: titulo, director: director, estreno: estreno)
        }

        override func descripcion() -> String {
            "\(super.descripcion()) | \(duracionDisco) min"
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let digitales = [
            PeliculaDigital(titulo: "Star Wars: Episodio IV - Una Nueva Esperanza", director: "George Lucas", estreno: 1977, url: "https://www.disneyplus.com/es-es/play/9a280e53-fcc0-4e17-a02c-b1f40913eb0b"),
            PeliculaDigital(titulo: "Star Wars: Episodio V - El Imperio Contraataca", director: "Irvin Kershner", estreno: 1980, url: "https://www.disneyplus.com/es-es/play/0f5c5223-f4f6-46ef-ba8a-69cb0e17d8d3"),
            PeliculaDigital(titulo: "Star Wars: Episodio VI - El Retorno del Jedi", director: "Richard Marquand", estreno: 1983, url: "https://www.disneyplus.com/es-es/play/4b6e7cda-daa5-4f2d-9b61-35bbe562c69c")
        ]

        let dvds = [
            PeliculaEnDVD(titulo: "Star Wars: Episodio I - La Amenaza Fantasma", director: "George Lucas", estreno: 1999, duracion: 136),
            PeliculaEnDVD(titulo: "Star Wars: Episodio II - El Ataque de los Clones", director: "George Lucas", estreno: 2002, duracion: 142),
            PeliculaEnDVD(titulo: "Star Wars: Episodio III - La Venganza de los Sith", director: "George Lucas", estreno: 2005, duracion: 140)
        ]

        var resultado = "PELÍCULAS DIGITALES (Streaming):\n"
        for (i, p) in digitales.enumerated() {
            resultado += "\(i + 1). \(p.descripcion())\n"
        }

        resultado += "\nPELÍCULAS EN DVD:\n"
        for (i, p) in dvds.enumerated() {
            resultado += "\(i + 1). \(p.descripcion())\n"
        }

        return resultado
    }
}

// MARK: - Ejercicio 12: Desplazar Vector
// Struct Vector con propiedades x, y y método desplazar

struct Repaso_Exercise12: ExecutableExercise {
    let exerciseId = 12

    struct Vector {
        var x: Double
        var y: Double

        mutating func desplazar(deltaX: Double, deltaY: Double) {
            x += deltaX
            y += deltaY
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidInput("Formato: x,y | deltaX,deltaY")
        }

        let v = parts[0].split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        let d = parts[1].split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

        guard v.count == 2 && d.count == 2 else {
            throw ExerciseError.invalidInput("Cada vector debe tener 2 componentes")
        }

        // Validar rango -100 a 100
        let rango = -100.0...100.0
        guard rango.contains(v[0]) && rango.contains(v[1]) &&
              rango.contains(d[0]) && rango.contains(d[1]) else {
            throw ExerciseError.invalidInput("Valores deben estar entre -100 y 100")
        }

        var vector = Vector(x: v[0], y: v[1])
        let original = "(\(Int(vector.x)), \(Int(vector.y)))"

        vector.desplazar(deltaX: d[0], deltaY: d[1])

        return """
        Vector original: \(original)
        Delta: (\(Int(d[0])), \(Int(d[1])))
        Vector desplazado: (\(Int(vector.x)), \(Int(vector.y)))
        """
    }
}

// MARK: - Ejercicio 13: Carrito de Compras
// Clase CarritoDeCompras con métodos añadir y eliminar

struct Repaso_Exercise13: ExecutableExercise {
    let exerciseId = 13

    struct Item {
        let nombre: String
        let precioUnitario: Double
        var cantidad: Int
    }

    final class CarritoDeCompras {
        var items: [Item] = []
        var total: Double = 0

        func añadir(item: String, precio: Double) {
            if let index = items.firstIndex(where: { $0.nombre == item }) {
                guard items[index].cantidad < 10 else { return }
                items[index].cantidad += 1
            } else {
                items.append(Item(nombre: item, precioUnitario: precio, cantidad: 1))
            }
            total += precio
        }

        func eliminar(item: String) {
            if let index = items.firstIndex(where: { $0.nombre == item }) {
                total -= items[index].precioUnitario
                if items[index].cantidad > 1 {
                    items[index].cantidad -= 1
                } else {
                    items.remove(at: index)
                }
            }
        }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let partes = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        let carrito = CarritoDeCompras()

        for parte in partes {
            let datos = parte.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }
            guard datos.count == 2,
                  let precio = Double(datos[1]),
                  precio > 0 else {
                throw ExerciseError.invalidInput("Formato: item1:precio1 (precio > 0)")
            }
            guard carrito.items.count < 20 || carrito.items.contains(where: { $0.nombre == datos[0] }) else {
                throw ExerciseError.invalidInput("Máximo 20 items diferentes")
            }
            carrito.añadir(item: datos[0], precio: precio)
        }

        let formato = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
        let lista = carrito.items.map {
            let subtotal = $0.precioUnitario * Double($0.cantidad)
            return "- \($0.nombre) x\($0.cantidad): \(subtotal.formatted(formato))€"
        }.joined(separator: "\n")

        return """
        CARRITO DE COMPRAS
        ───────────────────────────
        \(lista)
        ───────────────────────────
        TOTAL: \(carrito.total.formatted(formato))€
        """
    }
}

// MARK: - Ejercicio 14: Arrancar Vehículo
// Añade método arrancar() a la clase Vehiculo del ejercicio 8

extension Repaso_Exercise08.Vehiculo {
    func arrancar() -> String {
        "El \(marca) \(modelo) ha iniciado su marcha"
    }
}

struct Repaso_Exercise14: ExecutableExercise {
    let exerciseId = 14

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

        return """
        Vehículo seleccionado: \(vehiculo.descripcion())

        \(vehiculo.arrancar())
        """
    }
}

// MARK: - Ejercicio 15: Reproducir Película
// Añade método reproducir a Pelicula que recibe un Usuario

struct Repaso_Exercise15: ExecutableExercise {
    let exerciseId = 15

    struct Usuario {
        let nombre: String
        let edad: Int
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let añoActual = Calendar.current.component(.year, from: Date())

        // Parsear: título,director,año | nombre,edad
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidInput("Formato: título,director,año | nombre,edad")
        }

        // Parsear película
        let movieParts = parts[0].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard movieParts.count == 3,
              let año = Int(movieParts[2]),
              año >= 1895 && año <= añoActual else {
            throw ExerciseError.invalidInput("Formato película: título,director,año (1895-\(añoActual))")
        }

        // Parsear usuario
        let userParts = parts[1].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        guard userParts.count == 2,
              let edad = Int(userParts[1]),
              edad >= 1 && edad <= 120 else {
            throw ExerciseError.invalidInput("Formato usuario: nombre,edad (1-120)")
        }

        let pelicula = Repaso_Exercise10.Pelicula(
            titulo: movieParts[0],
            director: movieParts[1],
            estreno: año
        )
        let usuario = Usuario(nombre: userParts[0], edad: edad)

        return pelicula.reproducir(para: usuario)
    }
}

// Extension para añadir método reproducir a Pelicula
extension Repaso_Exercise10.Pelicula {
    func reproducir(para usuario: Repaso_Exercise15.Usuario) -> String {
        "El usuario \(usuario.nombre) (\(usuario.edad) años) está reproduciendo '\(descripcion())'"
    }
}

// MARK: - Ejercicio 16: Magnitud y Distancia Vectores
// Extiende Repaso_Exercise12.Vector con magnitud y distancia

extension Repaso_Exercise12.Vector {
    func magnitud() -> Double {
        sqrt(x * x + y * y)
    }

    func distancia(a otro: Repaso_Exercise12.Vector) -> Double {
        sqrt(pow(otro.x - x, 2) + pow(otro.y - y, 2))
    }
}

struct Repaso_Exercise16: ExecutableExercise {
    let exerciseId = 16

    @MainActor
    func execute(input: String) async throws -> String {
        let parts = input.split(separator: "|").map { $0.trimmingCharacters(in: .whitespaces) }
        guard parts.count == 2 else {
            throw ExerciseError.invalidInput("Formato: x1,y1 | x2,y2")
        }

        let v1 = parts[0].split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }
        let v2 = parts[1].split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

        guard v1.count == 2 && v2.count == 2 else {
            throw ExerciseError.invalidInput("Cada vector debe tener 2 componentes")
        }

        let rango = -100.0...100.0
        guard rango.contains(v1[0]) && rango.contains(v1[1]) &&
              rango.contains(v2[0]) && rango.contains(v2[1]) else {
            throw ExerciseError.invalidInput("Valores deben estar entre -100 y 100")
        }

        let vector1 = Repaso_Exercise12.Vector(x: v1[0], y: v1[1])
        let vector2 = Repaso_Exercise12.Vector(x: v2[0], y: v2[1])

        let formato = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))

        return """
        Vector 1: (\(Int(vector1.x)), \(Int(vector1.y))) → Magnitud: \(vector1.magnitud().formatted(formato))
        Vector 2: (\(Int(vector2.x)), \(Int(vector2.y))) → Magnitud: \(vector2.magnitud().formatted(formato))
        Distancia entre vectores: \(vector1.distancia(a: vector2).formatted(formato))
        """
    }
}

// MARK: - Ejercicio 17: Resumen Carrito
// Extension de CarritoDeCompras con mostrarResumen

extension Repaso_Exercise13.CarritoDeCompras {
    func mostrarResumen() -> String {
        let formato = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
        let lista = items.map {
            let subtotal = $0.precioUnitario * Double($0.cantidad)
            return "- \($0.nombre) x\($0.cantidad): \(subtotal.formatted(formato))€"
        }.joined(separator: "\n")

        return """
        ───────────────────────────
        \(lista)
        ───────────────────────────
        TOTAL: \(total.formatted(formato))€
        """
    }
}

struct Repaso_Exercise17: ExecutableExercise {
    let exerciseId = 17

    @MainActor
    func execute(input: String) async throws -> String {
        let partes = input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }

        guard partes.count >= 2 else {
            throw ExerciseError.invalidInput("Mínimo 2 items")
        }

        let carrito = Repaso_Exercise13.CarritoDeCompras()
        var nombresEnPosicionesPares: [String] = []

        for (index, parte) in partes.enumerated() {
            let datos = parte.split(separator: ":").map { $0.trimmingCharacters(in: .whitespaces) }

            guard datos.count == 2,
                  let precio = Double(datos[1]),
                  precio > 0 else {
                throw ExerciseError.invalidInput("Formato: item1:precio1 (precio > 0)")
            }

            guard carrito.items.count < 20 || carrito.items.contains(where: { $0.nombre == datos[0] }) else {
                throw ExerciseError.invalidInput("Máximo 20 items diferentes")
            }

            carrito.añadir(item: datos[0], precio: precio)

            // Posiciones pares contando desde 1: 2º, 4º, 6º... (index 1, 3, 5...)
            if (index + 1) % 2 == 0 {
                nombresEnPosicionesPares.append(datos[0])
            }
        }

        let paso1 = carrito.mostrarResumen()

        for nombre in nombresEnPosicionesPares {
            carrito.eliminar(item: nombre)
        }

        let paso2 = carrito.mostrarResumen()
        let eliminados = nombresEnPosicionesPares.joined(separator: ", ")

        return """
        PASO 1: Carrito completo
        \(paso1)

        PASO 2: Eliminadas posiciones pares (\(eliminados))
        \(paso2)
        """
    }
}

// MARK: - Ejercicio 18: Actualizar Año Vehículo
// Añade método actualizarAño() a la clase Vehiculo del ejercicio 8

extension Repaso_Exercise08.Vehiculo {
    func actualizarAño() {
        año += 1
    }
}

struct Repaso_Exercise18: ExecutableExercise {
    let exerciseId = 18

    @MainActor
    func execute(input: String) async throws -> String {
        let vehiculos = Repaso_Exercise08.Vehiculo.vehiculos

        guard let seleccion = Int(input.trimmingCharacters(in: .whitespaces)) else {
            throw ExerciseError.invalidInput("Ingresa un número del 1 al 5")
        }

        guard seleccion >= 1 && seleccion <= 5 else {
            throw ExerciseError.outOfRange("El número debe estar entre 1 y 5")
        }

        let vehiculoOriginal = vehiculos[seleccion - 1]

        // Crear copia para la demostración (no modifica el original)
        let vehiculo = Repaso_Exercise08.Vehiculo(
            marca: vehiculoOriginal.marca,
            modelo: vehiculoOriginal.modelo,
            año: vehiculoOriginal.año
        )

        let añoAnterior = vehiculo.año
        vehiculo.actualizarAño()

        return """
        Vehículo: \(vehiculo.marca) \(vehiculo.modelo)

        Año anterior: \(añoAnterior)
        Año actualizado: \(vehiculo.año)
        """
    }
}

// MARK: - Ejercicio 19: Suma Total Áreas Círculos
// Usa el struct Circulo del ejercicio 9 y crea función para sumar áreas

struct Repaso_Exercise19: ExecutableExercise {
    let exerciseId = 19

    @MainActor
    func execute(input: String) async throws -> String {
        // Función que recibe array de círculos y devuelve suma de áreas
        func sumaAreas(_ circulos: [Repaso_Exercise09.Circulo]) -> Double {
            circulos.reduce(0) { $0 + $1.area }
        }

        // Parsear radios
        let radios = input.split(separator: ",").compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

        // Validar cantidad
        guard radios.count >= 2 && radios.count <= 10 else {
            throw ExerciseError.invalidInput("Entre 2 y 10 radios")
        }

        // Validar rango
        let rango = 1.0...100.0
        guard radios.allSatisfy({ rango.contains($0) }) else {
            throw ExerciseError.outOfRange("Radio debe estar entre 1 y 100")
        }

        // Crear círculos usando el struct del ejercicio 9
        let circulos = radios.map { Repaso_Exercise09.Circulo(radio: $0) }

        // Calcular suma de áreas
        let total = sumaAreas(circulos)

        // Formatear detalles mostrando circunferencia y área
        let formato = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(2))
        var detalles = ""
        for (i, circulo) in circulos.enumerated() {
            detalles += "\(i + 1). Radio: \(circulo.radio.formatted(formato)) → Circunf: \(circulo.circunferencia.formatted(formato)) → Área: \(circulo.area.formatted(formato))\n"
        }

        return """
        ═══════════════════════════════════════════
        SUMA TOTAL DE ÁREAS
        ═══════════════════════════════════════════

        \(detalles)
        ───────────────────────────────────────────
        Área total: \(total.formatted(formato))
        ═══════════════════════════════════════════
        """
    }
}

// MARK: - Ejercicio 20: Sistema de Recomendación de Películas
// Subclase PeliculaConGenero que hereda de Repaso_Exercise10.Pelicula
// Clase Usuario (nombre, edad, generos, directores)
// recomendarPelicula y recomendarPeliculas

struct Repaso_Exercise20: ExecutableExercise {
    let exerciseId = 20

    // Subclase que añade género a Pelicula del ejercicio 10
    final class PeliculaConGenero: Repaso_Exercise10.Pelicula {
        let genero: String

        init(titulo: String, director: String, estreno: Int, genero: String) {
            self.genero = genero
            super.init(titulo: titulo, director: director, estreno: estreno)
        }

        override func descripcion() -> String {
            "\(titulo) (\(estreno)) - \(genero) - Dir: \(director)"
        }
    }

    // Clase Usuario con preferencias
    final class Usuario {
        let nombre: String
        let edad: Int
        let generos: [String]
        let directores: [String]

        init(nombre: String, edad: Int, generos: [String], directores: [String]) {
            self.nombre = nombre
            self.edad = edad
            self.generos = generos.map {
                $0.lowercased().folding(options: .diacriticInsensitive, locale: .current)
            }
            self.directores = directores.map {
                $0.lowercased().folding(options: .diacriticInsensitive, locale: .current)
            }
        }
    }

    // Verifica si una película le gustaría al usuario
    func recomendarPelicula(_ pelicula: PeliculaConGenero, para usuario: Usuario) -> Bool {
        let generoNormalizado = pelicula.genero
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)
        let directorNormalizado = pelicula.director
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)

        let generoCoincide = usuario.generos.contains { generoNormalizado.contains($0) }
        let directorCoincide = usuario.directores.contains { directorNormalizado.contains($0) }
        return generoCoincide || directorCoincide
    }

    // Devuelve películas recomendadas según preferencias del usuario
    func recomendarPeliculas(_ peliculas: [PeliculaConGenero], para usuario: Usuario) -> [PeliculaConGenero] {
        peliculas.filter { recomendarPelicula($0, para: usuario) }
    }

    @MainActor
    func execute(input: String) async throws -> String {
        let nombreUsuario = input.trimmingCharacters(in: .whitespaces)
        guard !nombreUsuario.isEmpty else {
            throw ExerciseError.emptyInput
        }

        let catalogo = PeliculaConGenero.sampleCatalog
        let usuarios = Usuario.sampleUsers

        let inputNormalizado = nombreUsuario
            .lowercased()
            .folding(options: .diacriticInsensitive, locale: .current)

        guard let usuario = usuarios.first(where: {
            let nombreNormalizado = $0.nombre
                .lowercased()
                .folding(options: .diacriticInsensitive, locale: .current)
            return nombreNormalizado == inputNormalizado ||
                   nombreNormalizado.contains(inputNormalizado)
        }) else {
            let disponibles = usuarios.map { $0.nombre }.joined(separator: ", ")
            throw ExerciseError.invalidInput("Usuario no encontrado. Disponibles: \(disponibles)")
        }

        let recomendadas = recomendarPeliculas(catalogo, para: usuario)

        let generosStr = usuario.generos.isEmpty ? "ninguno" : usuario.generos.joined(separator: ", ")
        let directoresStr = usuario.directores.isEmpty ? "ninguno" : usuario.directores.joined(separator: ", ")

        let peliculasStr = recomendadas.isEmpty
            ? "  No hay películas que coincidan con tus preferencias"
            : recomendadas.enumerated().map { "  \($0 + 1). \($1.descripcion())" }.joined(separator: "\n")

        return """
        SISTEMA DE RECOMENDACIÓN DE PELÍCULAS
        ═══════════════════════════════════════════

        USUARIO: \(usuario.nombre) (\(usuario.edad) años)
        ─────────────────────────────────────────
        Géneros favoritos: \(generosStr)
        Directores favoritos: \(directoresStr)

        PELÍCULAS RECOMENDADAS (\(recomendadas.count)/\(catalogo.count)):
        ─────────────────────────────────────────
        \(peliculasStr)
        """
    }
}

// MARK: - Extension PeliculaConGenero (Catálogo)
extension Repaso_Exercise20.PeliculaConGenero {
    @MainActor static let inception = Repaso_Exercise20.PeliculaConGenero(titulo: "Inception", director: "Christopher Nolan", estreno: 2010, genero: "Ciencia Ficción")
    @MainActor static let darkKnight = Repaso_Exercise20.PeliculaConGenero(titulo: "The Dark Knight", director: "Christopher Nolan", estreno: 2008, genero: "Acción")
    @MainActor static let pulpFiction = Repaso_Exercise20.PeliculaConGenero(titulo: "Pulp Fiction", director: "Quentin Tarantino", estreno: 1994, genero: "Drama")
    @MainActor static let killBill = Repaso_Exercise20.PeliculaConGenero(titulo: "Kill Bill", director: "Quentin Tarantino", estreno: 2003, genero: "Acción")
    @MainActor static let godfather = Repaso_Exercise20.PeliculaConGenero(titulo: "The Godfather", director: "Francis Ford Coppola", estreno: 1972, genero: "Drama")
    @MainActor static let interstellar = Repaso_Exercise20.PeliculaConGenero(titulo: "Interstellar", director: "Christopher Nolan", estreno: 2014, genero: "Ciencia Ficción")
    @MainActor static let forrestGump = Repaso_Exercise20.PeliculaConGenero(titulo: "Forrest Gump", director: "Robert Zemeckis", estreno: 1994, genero: "Drama")
    @MainActor static let matrix = Repaso_Exercise20.PeliculaConGenero(titulo: "The Matrix", director: "Wachowski", estreno: 1999, genero: "Ciencia Ficción")
    @MainActor static let gladiator = Repaso_Exercise20.PeliculaConGenero(titulo: "Gladiator", director: "Ridley Scott", estreno: 2000, genero: "Acción")
    @MainActor static let bladeRunner = Repaso_Exercise20.PeliculaConGenero(titulo: "Blade Runner", director: "Ridley Scott", estreno: 1982, genero: "Ciencia Ficción")

    @MainActor static let sampleCatalog: [Repaso_Exercise20.PeliculaConGenero] = [
        inception, darkKnight, pulpFiction, killBill, godfather,
        interstellar, forrestGump, matrix, gladiator, bladeRunner
    ]
}

// MARK: - Extension Usuario (Usuarios de prueba)
extension Repaso_Exercise20.Usuario {
    @MainActor static let ana = Repaso_Exercise20.Usuario(nombre: "Ana", edad: 28, generos: ["ciencia ficción", "acción"], directores: ["nolan"])
    @MainActor static let carlos = Repaso_Exercise20.Usuario(nombre: "Carlos", edad: 35, generos: ["drama"], directores: ["tarantino", "coppola"])
    @MainActor static let maria = Repaso_Exercise20.Usuario(nombre: "María", edad: 22, generos: ["acción"], directores: ["scott"])
    @MainActor static let pedro = Repaso_Exercise20.Usuario(nombre: "Pedro", edad: 45, generos: ["drama", "ciencia ficción"], directores: [])

    @MainActor static let sampleUsers: [Repaso_Exercise20.Usuario] = [ana, carlos, maria, pedro]
}
