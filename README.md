# NEXUS — Calculadora Científica

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.10%2B-02569B?logo=flutter&logoColor=white"/>
  <img src="https://img.shields.io/badge/Dart-3.0%2B-0175C2?logo=dart&logoColor=white"/>
  <img src="https://img.shields.io/badge/Plataforma-Android%20%7C%20iOS-green"/>
  <img src="https://img.shields.io/badge/Licen%C3%A7a-MIT-brightgreen"/>
</p>

> Uma calculadora científica mobile-first desenvolvida em Flutter para Android e iOS, com funções científicas, histórico persistente, registradores de memória e uma interface refinada para toque.

---

## ✨ Funcionalidades

| Categoria | Detalhes |
|---|---|
| **Aritmética** | `+` `−` `×` `÷` com precedência correta de operadores |
| **Científica** | `sin` `cos` `tan` e inversas, `log` `ln` `exp` |
| **Raízes e potências** | `√` `∛` `xʸ` `x²` |
| **Constantes** | `π` e `e` |
| **Memória** | registradores `MS` `MR` `M+` `MC` |
| **Histórico** | painel mobile arrastável com toque para reutilizar cálculos, persistido entre sessões |
| **Modos angulares** | alternância entre **DEG** e **RAD** a qualquer momento |
| **Modo 2nd** | tecla de alternância para inversas trigonométricas, `n!` e mais |
| **Resultado ao vivo** | o resultado é atualizado enquanto você digita, antes de pressionar `=` |
| **UX para toque** | botões grandes, feedback tátil e espaçamento mais denso para telas menores |
| **UX de erro** | tratamento mais seguro para trigonometria/constantes e estado claro para expressões inválidas |

---

## 📱 Foco de plataforma

Este repositório é intencionalmente otimizado para **Android** e **iOS**. O projeto Flutter ainda contém as pastas de plataforma geradas por padrão, mas o alvo oficial de execução desta aplicação é exclusivamente mobile.

Objetivos de UX mobile nesta versão:

- experiência pensada primeiro para celulares em retrato
- áreas de toque confortáveis e espaçamento compacto em telas menores
- histórico em bottom sheet para uso com uma mão
- comportamento estável para trigonometria e constantes em sessões prolongadas

---

## 📐 Arquitetura

O app usa um fluxo simples com **Provider + ChangeNotifier**:

```text
Toque em um botão
   ↓
CalcButton / ButtonGrid
   ↓
CalculatorModel
   ├─ atualiza expressão, resultado, memória e histórico
   └─ notifica os listeners
   ↓
DisplayPanel / HistoryPanel / ButtonGrid são reconstruídos
```

Estrutura do projeto:

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

Os detalhes da arquitetura estão em [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## 🚀 Como começar

### Pré-requisitos

| Ferramenta | Versão mínima |
|---|---|
| Flutter SDK | `3.10.0` |
| Dart SDK | `3.0.0` |
| Android Studio | versão estável mais recente |
| Xcode | versão estável mais recente no macOS para builds iOS |

### Instalação

```bash
# 1. Clone o repositório
git clone https://github.com/YOUR_USERNAME/nexus_calc.git
cd nexus_calc

# 2. Instale as dependências
flutter pub get

# 3. Rode no Android
flutter run -d android

# 4. Rode no iOS (somente macOS + Xcode)
flutter run -d ios
```

### Builds de release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🧪 Testes

```bash
flutter analyze
flutter test
```

A suíte atual cobre:

- lógica do modelo da calculadora
- transições do modo angular
- fluxos de histórico e memória
- smoke test da interface mobile

---

## Validação

Em um ambiente local normal, o fluxo recomendado de validação é:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

O repositório também possui GitHub Actions para validar análise estática e testes automaticamente. O workflow principal está em `.github/workflows/flutter-ci.yml` e deve ser tratado como a principal fonte de validação remota quando este ambiente local estiver instável.

Para um resumo operacional dessa estratégia, veja também [docs/VALIDATION.md](docs/VALIDATION.md).

---

## 🎨 Sistema de design

Todos os tokens visuais ficam em `lib/utils/app_theme.dart`.

### Paleta de cores

| Token | Hex | Papel |
|---|---|---|
| `bg0` | `#070B0F` | Fundo mais profundo |
| `bg1` | `#0D1117` | Superfície principal |
| `bg3` | `#1C2530` | Fundo dos botões |
| `cyan` | `#00E5FF` | Destaque principal / resultado |
| `amber` | `#FFAB00` | Destaque secundário / modo 2nd |
| `violet` | `#7C4DFF` | Botões de operadores |
| `green` | `#00E676` | Botão de igual / resultado recém-confirmado |
| `red` | `#FF1744` | Estado de erro |

### Tipografia

- tipografia configurada com `TextStyle` nativo do Flutter
- pesos, contraste e espaçamento ajustados para leitura confortável em mobile

---

## 📦 Principais dependências

```yaml
math_expressions: ^2.4.0      # Parsing e avaliação de expressões
shared_preferences: ^2.2.2    # Persistência do histórico
provider: ^6.1.1              # Gerenciamento de estado
flutter_animate: ^4.5.0       # Pequenas animações da UI
vibration: ^1.8.4             # Feedback tátil no mobile
gap: ^3.0.1                   # Helpers de espaçamento
```

---

## 🗺 Roadmap

- [ ] Layout dedicado para celulares grandes e tablets
- [ ] Conversor de unidades (m → ft, kg → lb, °C → °F)
- [ ] Modo de gráficos
- [ ] Temas adicionais
- [ ] Localização (`pt-BR`, `en`, `es`)

---

## 🤝 Contribuição

Pull requests são bem-vindos. Veja [CONTRIBUTING.md](CONTRIBUTING.md) para o fluxo de setup, critérios de qualidade e orientações de contribuição.

---

## 📄 Licença

Distribuído sob a licença **MIT**. Veja [`LICENSE`](LICENSE) para mais detalhes.
