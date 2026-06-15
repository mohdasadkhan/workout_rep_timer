import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color phaseWork;
  final Color phaseRest;
  final Color phaseRestBetweenSets;
  final Color phasePrepare;
  final Color phaseCoolDown;
  final Color cardBorder;
  final Color chipBackground;
  final Color chipText;

  const AppColorsExtension({
    required this.phaseWork,
    required this.phaseRest,
    required this.phaseRestBetweenSets,
    required this.phasePrepare,
    required this.phaseCoolDown,
    required this.cardBorder,
    required this.chipBackground,
    required this.chipText,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? phaseWork,
    Color? phaseRest,
    Color? phaseRestBetweenSets,
    Color? phasePrepare,
    Color? phaseCoolDown,
    Color? cardBorder,
    Color? chipBackground,
    Color? chipText,
  }) {
    return AppColorsExtension(
      phaseWork: phaseWork ?? this.phaseWork,
      phaseRest: phaseRest ?? this.phaseRest,
      phaseRestBetweenSets: phaseRestBetweenSets ?? this.phaseRestBetweenSets,
      phasePrepare: phasePrepare ?? this.phasePrepare,
      phaseCoolDown: phaseCoolDown ?? this.phaseCoolDown,
      cardBorder: cardBorder ?? this.cardBorder,
      chipBackground: chipBackground ?? this.chipBackground,
      chipText: chipText ?? this.chipText,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) return this;
    return AppColorsExtension(
      phaseWork: Color.lerp(phaseWork, other.phaseWork, t)!,
      phaseRest: Color.lerp(phaseRest, other.phaseRest, t)!,
      phaseRestBetweenSets: Color.lerp(
        phaseRestBetweenSets,
        other.phaseRestBetweenSets,
        t,
      )!,
      phasePrepare: Color.lerp(phasePrepare, other.phasePrepare, t)!,
      phaseCoolDown: Color.lerp(phaseCoolDown, other.phaseCoolDown, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      chipBackground: Color.lerp(chipBackground, other.chipBackground, t)!,
      chipText: Color.lerp(chipText, other.chipText, t)!,
    );
  }
}
