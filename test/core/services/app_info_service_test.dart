// test/core/services/app_info_service_test.dart
import 'package:fitflow/core/services/app_info_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppInfoService extends Mock implements AppInfoService {}

void main() {
  late MockAppInfoService mockService;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockService = MockAppInfoService();
  });

  test('mock returns expected values', () {
    when(() => mockService.version).thenReturn('2.3.1');
    when(() => mockService.buildNumber).thenReturn('67');
    when(() => mockService.settingsDisplay).thenReturn('Version 2.3.1');
    when(() => mockService.fullVersion).thenReturn('2.3.1+67');

    expect(mockService.version, '2.3.1');
    expect(mockService.settingsDisplay, 'Version 2.3.1');
  });
}
