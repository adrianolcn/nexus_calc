# Changelog

All notable changes to NEXUS Calculator will be documented in this file.

## [Unreleased]

### Changed
- Refined the interface for a mobile-first Android and iOS experience
- Improved button sizing and spacing for compact phone screens
- Updated README and architecture docs for GitHub publication

### Fixed
- Corrected DEG and RAD switching in the keypad and live result flow
- Fixed sanitization around the `e` constant and `exp(...)`
- Added safer handling for percentage input and sign toggling
- Replaced the default Flutter counter widget test with app-specific coverage

## [1.0.0] - 2024-01-01

### Added
- Full scientific calculator with 30+ functions
- Dark cyberpunk aesthetic with neon glow effects
- Live expression evaluation
- Calculation history with persistence via SharedPreferences
- Memory registers (MS, MR, M+, MC)
- Degree / Radian angle mode toggle
- 2nd function mode (inverse trig, n!, xʸ)
- Smart parenthesis button
- Haptic feedback on button press
- Animated result transitions
- Dot-grid background texture
- Unit tests
- Architecture documentation
