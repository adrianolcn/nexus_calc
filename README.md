# NEXUS — Scientific Calculator

<p align="center">
  <img src="docs/preview.png" alt="NEXUS Calculator Preview" width="300"/>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green"/>
  <img src="https://img.shields.io/badge/License-MIT-brightgreen"/>
</p>

> A mobile-first scientific calculator built with Flutter for Android and iOS, with scientific functions, persistent history, memory registers, and a refined touch-first interface.

---

## ✨ Features

| Category | Details |
|---|---|
| **Arithmetic** | `+` `−` `×` `÷` with correct operator precedence |
| **Scientific** | `sin` `cos` `tan` and inverses, `log` `ln` `exp` |
| **Roots & Powers** | `√` `∛` `xʸ` `x²` |
| **Constants** | `π` and `e` |
| **Memory** | `MS` `MR` `M+` `MC` registers |
| **History** | Draggable mobile history sheet with tap-to-recall, persisted across sessions |
| **Angle Modes** | Switch between **DEG** and **RAD** at any time |
| **2nd Mode** | Shift key unlocks inverse trig, `n!`, and more |
| **Live Result** | Result updates as you type before pressing `=` |
| **Touch UX** | Large thumb-friendly buttons, haptics, and denser spacing for smaller phones |
| **Error UX** | Safer trig/constant parsing and clear invalid-expression state |

---

## 📱 Platform focus

This repository is intentionally optimized for **Android** and **iOS**. The Flutter project still contains the usual generated platform folders, but the supported runtime target for this app is mobile only.

Mobile UX goals in this version:

- portrait-first experience for phones
- comfortable tap targets and compact spacing on small screens
- smooth bottom-sheet history for one-handed use
- stable behaviour for trig functions and constants during long sessions

---

## 📐 Architecture

The app uses a clean **Provider + ChangeNotifier** flow:

```text
Tap on a button
   ↓
CalcButton / ButtonGrid
   ↓
CalculatorModel
   ├─ updates expression, result, memory, history
   └─ notifies listeners
   ↓
DisplayPanel / HistoryPanel / ButtonGrid rebuild
```

Project structure:

```text
lib/
├── main.dart
├── models/
│   └── calculator_model.dart
├── screens/
│   └── calculator_screen.dart
├── utils/
│   └── app_theme.dart
└── widgets/
    ├── button_grid.dart
    ├── calc_button.dart
    ├── display_panel.dart
    └── history_panel.dart
```

Detailed architecture notes live in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## 🚀 Getting started

### Prerequisites

| Tool | Minimum version |
|---|---|
| Flutter SDK | `3.10.0` |
| Dart SDK | `3.0.0` |
| Android Studio | latest stable |
| Xcode | latest stable on macOS for iOS builds |

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/nexus_calc.git
cd nexus_calc

# 2. Install dependencies
flutter pub get

# 3. Run on Android
flutter run -d android

# 4. Run on iOS (macOS + Xcode only)
flutter run -d ios
```

### Build releases

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🧪 Testing

```bash
flutter analyze
flutter test
```

The current suite covers:

- calculator model logic
- angle mode transitions
- history and memory flows
- widget smoke coverage for the mobile UI

---

## Validação

Em um ambiente local normal, o fluxo recomendado de validação é:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

O repositório também possui GitHub Actions para validar análise estática e testes automaticamente. O workflow principal está em `.github/workflows/flutter-ci.yml` e deve ser tratado como a fonte principal de validação remota quando este ambiente local estiver instável.

Para um resumo operacional dessa estratégia, veja também [docs/VALIDATION.md](docs/VALIDATION.md).

---

## 🎨 Design system

All design tokens live in `lib/utils/app_theme.dart`.

### Colour palette

| Token | Hex | Role |
|---|---|---|
| `bg0` | `#070B0F` | Deepest background |
| `bg1` | `#0D1117` | Main surface |
| `bg3` | `#1C2530` | Button face |
| `cyan` | `#00E5FF` | Primary accent / result |
| `amber` | `#FFAB00` | Secondary accent / 2nd mode |
| `violet` | `#7C4DFF` | Operator buttons |
| `green` | `#00E676` | Equals / fresh result |
| `red` | `#FF1744` | Error state |

### Typography

- **JetBrains Mono** for expression display and results
- **Space Mono** for chips, labels, and technical UI accents

---

## 📦 Main dependencies

```yaml
math_expressions: ^2.4.0      # Expression parsing & evaluation
shared_preferences: ^2.2.2    # History persistence
provider: ^6.1.1              # State management
google_fonts: ^6.1.0          # Typography
flutter_animate: ^4.5.0       # Small UI motion
vibration: ^1.8.4             # Haptic feedback on mobile
gap: ^3.0.1                   # Spacing helpers
```

---

## 🗺 Roadmap

- [ ] Dedicated large-phone and tablet layout
- [ ] Unit converter (m → ft, kg → lb, °C → °F)
- [ ] Graphing mode
- [ ] Additional themes
- [ ] Localization (`pt-BR`, `en`, `es`)

---

## 🤝 Contributing

Pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the setup flow, quality gates, and contribution guidelines.

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.
