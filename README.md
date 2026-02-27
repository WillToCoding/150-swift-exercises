# Ejercicios

<p align="center">
  <img src="Ejercicios-iOS/ExercisesApp.icon/Assets/ExercisesBird.png" width="120" alt="Exercises App Icon">
</p>

<h3 align="center">150+ Swift algorithm exercises for all Apple platforms</h3>

<p align="center">
  <img src="https://img.shields.io/badge/Swift-6.0-F05138?style=for-the-badge&logo=swift&logoColor=white" alt="Swift">
  <img src="https://img.shields.io/badge/Platforms-3-007AFF?style=for-the-badge&logo=apple&logoColor=white" alt="Platforms">
  <img src="https://img.shields.io/badge/Exercises-150+-9B59B6?style=for-the-badge" alt="Exercises">
  <img src="https://img.shields.io/badge/License-MIT-2ECC71?style=for-the-badge" alt="License">
</p>

<p align="center">
  <b>Swift Developer Program 2025 — Apple Coding Academy</b><br>
  <i>From basics to advanced algorithms with visual diagrams</i>
</p>

---

<img src="https://img.shields.io/badge/FEATURES-2ECC71?style=for-the-badge" alt="Features">

| | Feature | Description |
|:--:|---------|-------------|
| 📚 | **150+ Exercises** | Comprehensive algorithm collection |
| 📱 | **Multi-platform** | iPhone, iPad, Mac native apps |
| 📊 | **Flow Diagrams** | Visual algorithm representation |
| 🧩 | **Code Blocks** | Structured pseudocode view |
| ▶️ | **Live Execution** | Run and test solutions in-app |
| 🔍 | **Filtering** | Search by category and difficulty |

---

<img src="https://img.shields.io/badge/📱_iPhone-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iPhone">

<p align="center">
  <img src="snapshots/iOS/Ejercicios.png" width="200" alt="iPhone Exercises">
  &nbsp;&nbsp;&nbsp;
  <img src="snapshots/iOS/Bloques.png" width="200" alt="iPhone Code Blocks">
</p>

- Compact exercise list with categories
- Code blocks with syntax highlighting
- Adaptive layout for all iPhone sizes

---

<img src="https://img.shields.io/badge/📱_iPad-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iPad">

<p align="center">
  <img src="snapshots/iPad/DiagramaDeFlujo.png" width="320" alt="iPad Flow Diagram">
  &nbsp;&nbsp;&nbsp;
  <img src="snapshots/iPad/Ejecutar.png" width="320" alt="iPad Execute">
</p>

- Split view navigation
- Full-size flow diagrams
- Side-by-side code and execution

---

<img src="https://img.shields.io/badge/🖥️_Mac-000000?style=for-the-badge&logo=macos&logoColor=white" alt="Mac">

<p align="center">
  <img src="snapshots/macOS/Filter.png" width="320" alt="Mac Filter">
  &nbsp;&nbsp;&nbsp;
  <img src="snapshots/macOS/Pseudocódigo.png" width="320" alt="Mac Pseudocode">
</p>

<p align="center">
  <img src="snapshots/macOS/DiagramaDeFlujo.png" width="400" alt="Mac Flow Diagram">
</p>

- 3-column NavigationSplitView
- Advanced filtering by category
- Keyboard shortcuts: `⌘F` search, `⌘R` run

---

<img src="https://img.shields.io/badge/EXERCISE_CATEGORIES-9B59B6?style=for-the-badge" alt="Categories">

| Category | Count | Topics |
|:--------:|:-----:|--------|
| **Básicos** | 30+ | Variables, tipos, operadores |
| **Condicionales** | 25+ | if, switch, guard |
| **Bucles** | 30+ | for, while, repeat |
| **Arrays** | 25+ | Colecciones, map, filter, reduce |
| **Funciones** | 20+ | Parámetros, closures, recursión |
| **Algoritmia** | 20+ | Ordenación, búsqueda, optimización |

---

<img src="https://img.shields.io/badge/VISUALIZATION_MODES-E67E22?style=for-the-badge" alt="Modes">

### Flow Diagrams

```
┌─────────────┐
│   START     │
└──────┬──────┘
       ▼
┌─────────────┐
│  Input N    │
└──────┬──────┘
       ▼
   ┌───────┐
  ╱ N > 0? ╲───No──▶ "Invalid"
  ╲        ╱
   └───┬───┘
      Yes
       ▼
┌─────────────┐
│ Calculate   │
└──────┬──────┘
       ▼
┌─────────────┐
│   Output    │
└──────┬──────┘
       ▼
┌─────────────┐
│    END      │
└─────────────┘
```

### Pseudocode Blocks

```
ALGORITHM CalculateFactorial
    INPUT: n (integer)
    OUTPUT: result (integer)

    IF n < 0 THEN
        RETURN error
    END IF

    result ← 1
    FOR i ← 1 TO n DO
        result ← result × i
    END FOR

    RETURN result
END ALGORITHM
```

---

<img src="https://img.shields.io/badge/TECH_STACK-E74C3C?style=for-the-badge" alt="Tech Stack">

| Category | Technologies |
|:--------:|-------------|
| **Language** | Swift 6 |
| **UI** | SwiftUI |
| **Architecture** | MVVM + Clean Architecture |
| **Concurrency** | async/await, @MainActor |
| **Observation** | @Observable (iOS 17+) |
| **Data** | Codable JSON |

---

<img src="https://img.shields.io/badge/REQUIREMENTS-7F8C8D?style=for-the-badge" alt="Requirements">

| Platform | Version |
|:--------:|:-------:|
| iOS | 17.0+ |
| iPadOS | 17.0+ |
| macOS | 14.0+ |
| Xcode | 16+ |

---

<img src="https://img.shields.io/badge/INSTALLATION-2ECC71?style=for-the-badge" alt="Installation">

```bash
git clone https://github.com/WillToCoding/Ejercicios.git
cd Ejercicios/Ejercicios-iOS
open Ejercicios-iOS.xcodeproj
```

Select your target platform and run with `⌘R`.

---

<img src="https://img.shields.io/badge/PROJECT_STRUCTURE-95A5A6?style=for-the-badge" alt="Structure">

```
Ejercicios/
├── 📱 Ejercicios-iOS/
│   ├── Views/
│   │   ├── ExerciseListView.swift
│   │   ├── FlowDiagramView.swift
│   │   ├── PseudocodeView.swift
│   │   └── ExecutionView.swift
│   ├── ViewModels/
│   │   └── ExerciseViewModel.swift
│   ├── Models/
│   │   └── Exercise.swift
│   └── Resources/
│       └── exercises.json
├── 🖼️ snapshots/
│   ├── iOS/
│   ├── iPad/
│   └── macOS/
└── 📄 README.md
```

---

<img src="https://img.shields.io/badge/RELATED_PROJECTS-F1C40F?style=for-the-badge" alt="Related">

| Project | Description |
|:-------:|-------------|
| [**EjerciciosUIs**](https://github.com/WillToCoding/EjerciciosUIs) | 5 SwiftUI interface exercises |
| [**MisMangas**](https://github.com/WillToCoding/MisMangas) | Multi-platform manga collection manager |
| [**NetworkAPI**](https://github.com/WillToCoding/NetworkAPI) | Async/await networking layer |

---

<p align="center">
  <b>MIT License</b> · Made with ❤️ by <b>Juan Carlos</b>
</p>

<p align="center">
  <i>Swift Developer Program 2025 — Apple Coding Academy</i>
</p>
