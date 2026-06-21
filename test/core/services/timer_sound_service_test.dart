import 'package:flutter_test/flutter_test.dart';
import 'package:fitflow/core/services/timer_sound_service.dart';
import 'package:flutter/foundation.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Suppress noisy debugPrint from TimerSoundService in tests
  setUpAll(() {
    debugPrint = (String? message, {int? wrapWidth}) {};
  });
  late TimerSoundService sut;

  setUp(() {
    sut = TimerSoundService(soundEnabled: true, hapticEnabled: true);
  });

  tearDown(() async {
    await sut.dispose();
  });

  // ── init ────────────────────────────────────────────────────────────────

  test(
    'init() completes without throwing even if assets are missing',
    () async {
      await expectLater(sut.init(), completes);
    },
  );

  test('init() is idempotent — second call is a no-op', () async {
    await sut.init();
    await expectLater(sut.init(), completes);
  });

  // ── pre-init safety ─────────────────────────────────────────────────────

  test('playCountdownBeep() before init() does not throw', () async {
    await expectLater(sut.playCountdownBeep(), completes);
  });

  test('playPhaseComplete() before init() does not throw', () async {
    await expectLater(sut.playPhaseComplete(), completes);
  });

  // ── post-dispose safety ─────────────────────────────────────────────────

  test('playCountdownBeep() after dispose() does not throw', () async {
    await sut.init();
    await sut.dispose();
    await expectLater(sut.playCountdownBeep(), completes);
  });

  test('playPhaseComplete() after dispose() does not throw', () async {
    await sut.init();
    await sut.dispose();
    await expectLater(sut.playPhaseComplete(), completes);
  });

  test('dispose() is idempotent — safe to call twice', () async {
    await sut.init();
    await sut.dispose();
    await expectLater(sut.dispose(), completes);
  });

  test('dispose() without init() does not throw', () async {
    await expectLater(sut.dispose(), completes);
  });

  // ── updateSettings ───────────────────────────────────────────────────────

  test('updateSettings() does not throw for any bool combination', () {
    expect(
      () => sut.updateSettings(soundEnabled: false, hapticEnabled: false),
      returnsNormally,
    );
    expect(
      () => sut.updateSettings(soundEnabled: true, hapticEnabled: false),
      returnsNormally,
    );
    expect(
      () => sut.updateSettings(soundEnabled: false, hapticEnabled: true),
      returnsNormally,
    );
    expect(
      () => sut.updateSettings(soundEnabled: true, hapticEnabled: true),
      returnsNormally,
    );
  });

  test('playCountdownBeep() with sound disabled completes', () async {
    sut.updateSettings(soundEnabled: false, hapticEnabled: false);
    await expectLater(sut.playCountdownBeep(), completes);
  });

  test('playPhaseComplete() with sound disabled completes', () async {
    sut.updateSettings(soundEnabled: false, hapticEnabled: false);
    await expectLater(sut.playPhaseComplete(), completes);
  });

  test('updateSettings() after dispose() does not throw', () async {
    await sut.dispose();
    expect(
      () => sut.updateSettings(soundEnabled: false, hapticEnabled: false),
      returnsNormally,
    );
  });
}
