// lib/utils/app_theme.dart
//
// NEXUS Calculator – Design System
// ────────────────────────────────────────────────────────────────────
// Think of this file as the "DNA" of the visual identity.  Every color,
// spacing value, and text style originates here.  Changing a single
// color constant cascades consistently through the entire UI.
// ────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Colour Palette
// ══════════════════════════════════════════════════════════════════════════════

/// The single source of truth for all colours.
abstract class NexusColors {
  // Background layers — like tectonic plates stacked on top of each other
  static const bg0 = Color(0xFF070B0F); // deepest abyss
  static const bg1 = Color(0xFF0D1117); // main surface
  static const bg2 = Color(0xFF151C25); // elevated card
  static const bg3 = Color(0xFF1C2530); // button face

  // Primary accent — electric cyan (the "spark")
  static const cyan = Color(0xFF00E5FF);
  static const cyanDim = Color(0xFF0097A7);
  static const cyanGlow = Color(0x3300E5FF);

  // Secondary accent — vivid amber (the "heat")
  static const amber = Color(0xFFFFAB00);
  static const amberDim = Color(0xFFFF6F00);
  static const amberGlow = Color(0x33FFAB00);

  // Operator buttons — warm violet
  static const violet = Color(0xFF7C4DFF);
  static const violetDim = Color(0xFF512DA8);
  static const violetGlow = Color(0x337C4DFF);

  // Equals button — the climax colour
  static const green = Color(0xFF00E676);
  static const greenDim = Color(0xFF00796B);
  static const greenGlow = Color(0x4400E676);

  // Error state
  static const red = Color(0xFFFF1744);
  static const redGlow = Color(0x33FF1744);

  // Text hierarchy
  static const textPrimary = Color(0xFFE8F4F8);
  static const textSecondary = Color(0xFF7EABB8);
  static const textMuted = Color(0xFF3D5A66);

  // Divider / border
  static const border = Color(0xFF1E3040);
  static const borderBright = Color(0xFF2E4A60);
}

// ══════════════════════════════════════════════════════════════════════════════
// Typography
// ══════════════════════════════════════════════════════════════════════════════

abstract class NexusTextStyles {
  // Expression display — needs a monospaced feel for number alignment
  static TextStyle display(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 36,
        fontWeight: FontWeight.w300,
        color: NexusColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle result(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 52,
        fontWeight: FontWeight.w200,
        color: NexusColors.cyan,
        letterSpacing: -1.5,
      );

  static TextStyle resultError(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 40,
        fontWeight: FontWeight.w200,
        color: NexusColors.red,
      );

  // Button labels
  static TextStyle btnDigit(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: NexusColors.textPrimary,
      );

  static TextStyle btnOperator(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: NexusColors.violet,
      );

  static TextStyle btnFunction(BuildContext context) =>
      GoogleFonts.spaceMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: NexusColors.cyan,
        letterSpacing: 0.5,
      );

  static TextStyle btnEquals(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: NexusColors.bg0,
      );

  static TextStyle historyExpression(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: NexusColors.textSecondary,
      );

  static TextStyle historyResult(BuildContext context) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: NexusColors.textPrimary,
      );

  static TextStyle badge(BuildContext context) =>
      GoogleFonts.spaceMono(
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );

  static TextStyle chip(BuildContext context) =>
      GoogleFonts.spaceMono(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: NexusColors.textSecondary,
        letterSpacing: 1.5,
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// ThemeData factory
// ══════════════════════════════════════════════════════════════════════════════

abstract class NexusTheme {
  static ThemeData build() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NexusColors.bg0,
      colorScheme: const ColorScheme.dark(
        primary: NexusColors.cyan,
        secondary: NexusColors.amber,
        surface: NexusColors.bg1,
        error: NexusColors.red,
      ),
      dividerColor: NexusColors.border,
      splashColor: NexusColors.cyanGlow,
      highlightColor: Colors.transparent,
    );
  }
}
