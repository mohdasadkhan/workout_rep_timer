import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';

class AppIconService {
  static const _lightAlias = 'MainActivityLight';
  static const _darkAlias = 'MainActivityDark';

  static Future<void> applyIcon({required bool isDark}) async {
    if (!Platform.isAndroid) return;

    try {
      final supported = await FlutterDynamicIconPlus.supportsAlternateIcons;
      // This will tell us if MIUI is blocking it
      debugPrint('AppIconService: supportsAlternateIcons = $supported');

      if (!supported) {
        debugPrint('AppIconService: device does not support alternate icons');
        return;
      }

      final targetAlias = isDark ? _darkAlias : _lightAlias;
      debugPrint('AppIconService: switching to → $targetAlias');

      await FlutterDynamicIconPlus.setAlternateIconName(iconName: targetAlias);
      debugPrint('AppIconService: icon changed successfully ✅');
    } catch (e) {
      debugPrint('AppIconService: FAILED → $e');
    }
  }
}