import 'package:flutter/material.dart';

// ─── Key principle ─────────────────────────────────────────────────────────────
// TextStyles here define SHAPE only (size, weight, spacing).
// Colors are intentionally OMITTED so the theme's colorScheme.onSurface
// (or onBackground) flows through automatically — works for both light & dark.
//
// Exceptions: styles that ALWAYS use the accent color (e.g. phaseBadge) keep
// their explicit color. Everything else: let the theme decide.
// ───────────────────────────────────────────────────────────────────────────────

class AppTextStyles {
  // Headings
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 34,

    fontWeight: FontWeight.w900,
    letterSpacing: -0.5,
    // no color → inherits colorScheme.onSurface from theme
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    // no color
  );

  // Titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    // no color
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    // no color
  );

  // Body — slightly muted, but still theme-aware
  // We use `inherit: true` (default) and set no color here; callers that need
  // the "secondary" muted look should do: style.copyWith(color: colorScheme.onSurface.withOpacity(0.6))
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    // no color
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    // no color
  );

  // Labels & Small
  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    // no color
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.5,
    // no color — callers apply colorScheme.onSurface.withOpacity(0.45) for muted look
  );

  // Timer Specific
  static const TextStyle timerDisplay = TextStyle(
    fontSize: 72,
    fontWeight: FontWeight.w900,
    letterSpacing: -2,
    // no color
  );

  static const TextStyle phaseBadge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    letterSpacing: 2.5,
    // no color — caller sets it based on phase
  );

  static const TextStyle sequenceItem = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    // no color
  );
}
