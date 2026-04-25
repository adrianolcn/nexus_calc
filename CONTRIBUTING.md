# Contributing to NEXUS Calculator

Thanks for contributing. This project is maintained as a mobile-first Flutter app for Android and iOS.

## Development setup

```bash
git clone https://github.com/YOUR_USERNAME/nexus_calc.git
cd nexus_calc
flutter pub get
flutter run -d android
```

For iOS development, use `flutter run -d ios` on macOS with Xcode installed.

## Quality gates

Before opening a pull request, run:

```bash
flutter analyze
flutter test
```

## Code style

- Follow the Dart style guide
- Keep state changes centralized in `CalculatorModel`
- Preserve the mobile-first interaction model
- Add tests when changing calculator behaviour

## Commit conventions

Use Conventional Commits when possible:

```text
feat: add a new scientific function
fix: correct degree mode sanitization
docs: update mobile setup instructions
test: cover history recall flow
```

## Reporting bugs

Open a GitHub issue with:

- device and OS version
- Flutter version (`flutter --version`)
- steps to reproduce
- expected vs actual behaviour
- screenshot or screen recording when relevant
