import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class AppInfoService {
  Future<void> init();
  String get version;
  String get buildNumber;
  String get fullVersion; // "1.2.3+45"
  String get settingsDisplay; // "Version 1.2.3"
  String get formattedVersion; // "v1.2.3 (build 45)"
}

class AppInfoServiceImpl implements AppInfoService {
  PackageInfo? _packageInfo;

  @override
  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      debugPrint(
        '📱 AppInfo loaded: ${_packageInfo!.version}+${_packageInfo!.buildNumber}',
      );
    } catch (e) {
      debugPrint('⚠️ Failed to load package info: $e');
      // Fallbacks will be used automatically
    }
  }

  @override
  String get version => _packageInfo?.version ?? '1.0.0';

  @override
  String get buildNumber => _packageInfo?.buildNumber ?? '0';

  @override
  String get fullVersion => '$version+$buildNumber';

  @override
  String get settingsDisplay => 'Version $version';

  @override
  String get formattedVersion => 'v$version (build $buildNumber)';
}
