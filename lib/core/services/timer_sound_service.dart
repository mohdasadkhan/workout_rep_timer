import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Plays countdown beeps and phase-complete sounds during a workout session.
///
/// Safety guarantees:
/// - Every audio/haptic call is wrapped in try/catch.
/// - Errors are logged but NEVER rethrown — a sound failure must never
///   reach [TimerBloc] or crash the app.
/// - [AudioPool] is used for the countdown beep because it pre-loads the
///   audio buffer, giving sub-50ms latency with no GC pressure on each tick.
/// - A separate [AudioPlayer] handles the phase-complete sound (one-shot,
///   plays rarely so pool overhead isn't worth it).
/// - [dispose] is safe to call multiple times (guarded by [_disposed]).
class TimerSoundService {
  // These are runtime preferences, updated via [updateSettings].
  bool _soundEnabled;
  bool _hapticEnabled;

  // AudioPool for the short countdown beep (3, 2, 1).
  // Pre-loaded once at init, reused on every tick.
  AudioPool? _beepPool;

  // One-shot player for the phase-complete chime.
  AudioPlayer? _completePlayer;

  bool _disposed = false;
  bool _initialized = false;

  TimerSoundService({
    bool soundEnabled = true,
    bool hapticEnabled = true,
  })  : _soundEnabled = soundEnabled,
        _hapticEnabled = hapticEnabled;

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once after construction. Safe to call again — will no-op if already
  /// initialized. Failures are swallowed so a missing asset never crashes.
  Future<void> init() async {
    if (_initialized || _disposed) return;
    try {
      _beepPool = await AudioPool.createFromAsset(
        path: 'sounds/beep_countdown.wav',
        maxPlayers: 2, // allow slight overlap if ticks come fast
      );
      _completePlayer = AudioPlayer();
      // Set release mode once — we don't loop sounds.
      await _completePlayer?.setReleaseMode(ReleaseMode.stop);
      _initialized = true;
      debugPrint('🔊 TimerSoundService initialized');
    } catch (e) {
      // Asset missing or audioplayers init failed — degrade gracefully.
      debugPrint('⚠️ TimerSoundService init failed (sounds disabled): $e');
      _initialized = false;
    }
  }

  /// Update runtime preferences without reinitializing audio resources.
  /// Called by [TimerBloc] when [SoundSettingsChanged] event is received.
  void updateSettings({required bool soundEnabled, required bool hapticEnabled}) {
    _soundEnabled = soundEnabled;
    _hapticEnabled = hapticEnabled;
  }

  /// Play the short countdown beep. Call when [remainingSeconds] is 3, 2, or 1.
  Future<void> playCountdownBeep() async {
    if (_disposed) return;
    await Future.wait([
      _playBeep(),
      _triggerHaptic(HapticFeedbackType.medium),
    ]);
  }

  /// Play the phase-complete chime. Call when a phase ends (remainingSeconds → 0).
  Future<void> playPhaseComplete() async {
    if (_disposed) return;
    await Future.wait([
      _playComplete(),
      _triggerHaptic(HapticFeedbackType.heavy),
    ]);
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    try {
      await _completePlayer?.dispose();
      await _beepPool?.dispose();
    } catch (e) {
      debugPrint('⚠️ TimerSoundService dispose error (safe to ignore): $e');
    }
    _completePlayer = null;
    _beepPool = null;
    debugPrint('🔇 TimerSoundService disposed');
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  Future<void> _playBeep() async {
    if (!_soundEnabled || !_initialized || _beepPool == null) return;
    try {
      await _beepPool!.start(volume: 1.0);
    } catch (e) {
      debugPrint('⚠️ Beep play error (ignored): $e');
    }
  }

  Future<void> _playComplete() async {
    if (!_soundEnabled || !_initialized || _completePlayer == null) return;
    try {
      await _completePlayer!.play(
        AssetSource('sounds/beep_complete.wav'),
        volume: 1.0,
      );
    } catch (e) {
      debugPrint('⚠️ Complete sound play error (ignored): $e');
    }
  }

  Future<void> _triggerHaptic(HapticFeedbackType type) async {
    if (!_hapticEnabled) return;
    try {
      switch (type) {
        case HapticFeedbackType.medium:
          await HapticFeedback.mediumImpact();
          break;
        case HapticFeedbackType.heavy:
          await HapticFeedback.heavyImpact();
          break;
      }
    } catch (e) {
      debugPrint('⚠️ Haptic error (ignored): $e');
    }
  }
}

enum HapticFeedbackType { medium, heavy }