import 'package:flutter/material.dart';

enum AppFeature { coach, tabataTimer, repTracker }

extension AppFeatureExtension on AppFeature {
  String get label => switch (this) {
    AppFeature.coach => 'AI Coach',
    AppFeature.tabataTimer => 'Workout Timer',
    AppFeature.repTracker => 'Rep Tracker',
  };

  IconData get icon => switch (this) {
    AppFeature.coach => Icons.auto_awesome,
    AppFeature.tabataTimer => Icons.timer_outlined,
    AppFeature.repTracker => Icons.fitness_center_outlined,
  };

  String get route => switch (this) {
    AppFeature.coach => '/coach',
    AppFeature.tabataTimer => '/tabata',
    AppFeature.repTracker => '/rep-tracker',
  };
}
