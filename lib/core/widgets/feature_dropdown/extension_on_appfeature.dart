import 'package:flutter/material.dart';

enum AppFeature { tabataTimer, repTracker }

extension AppFeatureExtension on AppFeature {
  String get label => switch (this) {
    AppFeature.tabataTimer => 'Tabata Timer',
    AppFeature.repTracker  => 'Rep Tracker',
  };

  IconData get icon => switch (this) {
    AppFeature.tabataTimer => Icons.timer_outlined,
    AppFeature.repTracker  => Icons.fitness_center_outlined,
  };

  String get route => switch (this) {
    AppFeature.tabataTimer => '/tabata',
    AppFeature.repTracker  => '/rep-tracker',
  };
}