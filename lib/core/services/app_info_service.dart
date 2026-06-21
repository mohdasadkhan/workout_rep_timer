import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppInfoService {
  /// Lazy init - call this once, but it won't block startup
  Future<void> init();

  /// Get the version string (loads lazily if not initialized)
  String get version;

  String get buildNumber;
  String get fullVersion;
  String get settingsDisplay;
  String get formattedVersion;

  /// Check if the info has been loaded
  bool get isLoaded;
}

class AppInfoServiceImpl implements AppInfoService {
  PackageInfo? _packageInfo;
  bool _isLoading = false;
  bool _isLoaded = false;

  @override
  Future<void> init() async {
    // If already loaded or currently loading, skip
    if (_isLoaded || _isLoading) return;

    _isLoading = true;
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      _isLoaded = true;
      debugPrint('📱 AppInfo loaded: ${_packageInfo!.version}+${_packageInfo!.buildNumber}');
    } catch (e) {
      debugPrint('⚠️ Failed to load package info: $e');
      // Use fallback values
      _packageInfo = null;
      _isLoaded = true; // Mark as loaded even on failure
    } finally {
      _isLoading = false;
    }
  }

  @override
  String get version {
    // If not loaded, trigger lazy load in background
    if (!_isLoaded && !_isLoading) {
      _loadInBackground();
    }
    return _packageInfo?.version ?? '1.0.0';
  }

  @override
  String get buildNumber {
    if (!_isLoaded && !_isLoading) {
      _loadInBackground();
    }
    return _packageInfo?.buildNumber ?? '0';
  }

  @override
  String get fullVersion => '$version+$buildNumber';

  @override
  String get settingsDisplay => 'Version $version';

  @override
  String get formattedVersion => 'v$version (build $buildNumber)';

  @override
  bool get isLoaded => _isLoaded;

  /// Background load without awaiting
  void _loadInBackground() {
    unawaited(init());
  }
}
