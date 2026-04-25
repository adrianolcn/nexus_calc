# NEXUS Calculator — Architecture Deep Dive

This document explains how the mobile-first Flutter app is organized, how state flows through the UI, and where to extend behaviour safely.

---

## System overview

The project is intentionally simple:

```text
main.dart
  ↓
NexusApp
  ↓
ChangeNotifierProvider<CalculatorModel>
  ↓
CalculatorScreen
  ├─ DisplayPanel
  ├─ ButtonGrid
  └─ HistoryPanel
```

`CalculatorModel` is the single source of truth for the calculator state. Widgets never mutate the data directly. They forward user actions to the model and rebuild when notified.

---

## Runtime flow

```text
User taps a button
   ↓
CalcButton calls a model method
   ↓
CalculatorModel updates expression/result/history
   ↓
notifyListeners()
   ↓
Provider rebuilds the affected widgets
```

This keeps the app easy to reason about and easy to test.

---

## File responsibilities

### `lib/main.dart`

- boots Flutter
- configures Android/iOS system chrome
- locks the app to portrait for a phone-first experience
- injects `CalculatorModel` with `ChangeNotifierProvider`

### `lib/models/calculator_model.dart`

This is the app brain. It owns:

- current expression
- current result
- error state
- degree/radian mode
- memory register
- persisted history
- second-function mode

Important responsibilities inside the model:

- sanitize display tokens such as `×`, `÷`, `π`, `%`, and `e`
- convert trig input/output correctly when the app is in degree mode
- perform live evaluation while the user types
- persist the latest history entries with `SharedPreferences`

### `lib/screens/calculator_screen.dart`

This is the mobile shell:

- gradient background and ambient effects
- app header
- calculator card container
- display area sizing
- history bottom sheet presentation

The layout adapts for small phones and larger mobile screens without leaving the mobile-first design direction.

### `lib/widgets/button_grid.dart`

Defines the keypad and button ordering. The grid reads the current calculator state to:

- switch between primary and second functions
- show the current angle mode
- reflect whether memory is stored
- keep button sizing proportional to the available mobile height

### `lib/widgets/calc_button.dart`

Encapsulates one pressable key:

- visual style by semantic type
- press animation
- haptic feedback
- semantics label for accessibility
- adaptive content scaling for smaller devices

### `lib/widgets/display_panel.dart`

Renders:

- status badges
- current expression
- animated result

The expression scrolls horizontally and the result scales down instead of overflowing.

### `lib/widgets/history_panel.dart`

Implements the draggable mobile history sheet:

- saved calculation count
- recall on tap
- clear history action
- empty state for first use

---

## Expression pipeline

Before evaluating, the model converts UI-friendly tokens into parser-friendly tokens.

Example:

```text
Input:  sin(30)+25%
Step 1: replace symbols → sin(30)+25/100
Step 2: apply DEG mode → sin(pi/180*30)+25/100
Step 3: auto-close open parentheses if needed
Step 4: parse with math_expressions
```

This pipeline is why the UI can stay pleasant while the math parser stays strict.

---

## Mobile UX decisions

The current version makes a few explicit mobile tradeoffs:

- portrait lock to keep the keypad comfortable on phones
- larger tap targets and denser spacing on compact screens
- history presented as a bottom sheet instead of a side panel
- edge-to-edge system UI styling for Android and iOS
- focused scope on Android and iOS only

---

## Testing strategy

There are two layers of automated coverage:

- `test/calculator_model_test.dart`
  Covers math logic, angle mode, memory, history, sanitization edge cases, and state transitions.
- `test/widget_test.dart`
  Covers basic rendering and a happy-path tap flow in the mobile UI.

The tests initialize mock `SharedPreferences`, which keeps the suite deterministic and independent of device storage.

---

## Extending the app

### Add a new scientific function

1. Add the key to `lib/widgets/button_grid.dart`
2. If the parser needs token cleanup, extend `_sanitise()` in `lib/models/calculator_model.dart`
3. Add tests in `test/calculator_model_test.dart`
4. Document the feature in `README.md`

### Change the visual language

- update colors and typography in `lib/utils/app_theme.dart`
- adjust shell layout in `lib/screens/calculator_screen.dart`
- adjust key visuals in `lib/widgets/calc_button.dart`

---

## Dependency rationale

| Package | Why |
|---|---|
| `math_expressions` | Expression parsing and evaluation |
| `provider` | Lightweight app-wide state propagation |
| `shared_preferences` | Persistent local history storage |
| `google_fonts` | Technical typography for the calculator UI |
| `flutter_animate` | Small, readable motion effects |
| `vibration` | Native haptic feedback on mobile |

---

## Suggested future work

- dedicated large-phone and tablet keypad layout
- internationalization
- more calculator modes
- widget and integration tests for longer touch flows
