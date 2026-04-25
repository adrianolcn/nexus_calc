# Validation Guide

This project is currently validated by documentation review, GitHub Actions, and normal local development environments outside this Codex session.

## Current status

Validation inside this environment was blocked by repeated toolchain hangs when invoking Flutter/Dart commands. Because of that, local validation was intentionally not continued here.

## Official validation path

The primary validation source for this repository is GitHub Actions.

The workflow at `.github/workflows/flutter-ci.yml` is responsible for:

- installing dependencies
- running static analysis
- running automated tests

If the workflow fails, use the real log from GitHub Actions as the source of truth for the next fix.

## Recommended local validation flow

In a normal developer environment, run:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

## Supported scope

The project is a Flutter mobile application focused on:

- Android
- iOS

Web and desktop platforms are not part of the official scope at this time.

## How to handle future failures

- If local validation fails, compare it with the GitHub Actions log.
- If CI fails, fix the issue based on the actual workflow output.
- Treat GitHub Actions as the main reference for static analysis and automated tests in the current project state.
