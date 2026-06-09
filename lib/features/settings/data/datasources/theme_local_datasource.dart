import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/pref_keys.dart';
import '../../domain/entities/app_theme_mode.dart';

abstract class ThemeLocalDatasource {
  Future<AppThemeMode> getThemeMode();
  Future<void> saveThemeMode(AppThemeMode mode);
}

class ThemeLocalDatasourceImpl implements ThemeLocalDatasource {
  final SharedPreferences sharedPreferences;

  const ThemeLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<AppThemeMode> getThemeMode() async {
    final modeStr = sharedPreferences.getString(PrefKeys.themeMode) ?? 'system';
    return AppThemeMode.values.byName(modeStr);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode mode) async {
    await sharedPreferences.setString(PrefKeys.themeMode, mode.name);
  }
}
