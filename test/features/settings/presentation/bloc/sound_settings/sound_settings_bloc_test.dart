import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:fitflow/features/settings/domain/usecases/get_sound_settings.dart';
import 'package:fitflow/features/settings/domain/usecases/save_sound_settings.dart';
import 'package:fitflow/features/settings/presentation/bloc/sound_settings/sound_settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sound_settings_bloc_test.mocks.dart';

@GenerateMocks([GetSoundSettings, SaveSoundSettings])
void main() {
  late MockGetSoundSettings mockGet;
  late MockSaveSoundSettings mockSave;

  const defaultSettings = SoundSettings(
    soundEnabled: true,
    hapticEnabled: true,
  );
  const soundOffSettings = SoundSettings(
    soundEnabled: false,
    hapticEnabled: true,
  );
  const hapticOffSettings = SoundSettings(
    soundEnabled: true,
    hapticEnabled: false,
  );

  setUp(() {
    mockGet = MockGetSoundSettings();
    mockSave = MockSaveSoundSettings();
  });

  SoundSettingsBloc buildBloc() =>
      SoundSettingsBloc(getSettings: mockGet, saveSettings: mockSave);

  group('LoadSoundSettings', () {
    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'emits [SoundSettingsLoaded] with settings from repository on success',
      build: buildBloc,
      setUp: () {
        when(mockGet()).thenAnswer((_) async => const Right(defaultSettings));
      },
      act: (bloc) => bloc.add(LoadSoundSettings()),
      expect: () => [const SoundSettingsLoaded(defaultSettings)],
      verify: (_) {
        verify(mockGet()).called(1);
        verifyNoMoreInteractions(mockGet);
      },
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'emits [SoundSettingsError] when repository fails',
      build: buildBloc,
      setUp: () {
        when(mockGet()).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'read error')),
        );
      },
      act: (bloc) => bloc.add(LoadSoundSettings()),
      expect: () => [isA<SoundSettingsError>()],
    );

    // FIXED: Removed the message check since SoundSettingsError doesn't have a message field
    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'handles error with empty message gracefully',
      build: buildBloc,
      setUp: () {
        when(
          mockGet(),
        ).thenAnswer((_) async => const Left(CacheFailure(message: '')));
      },
      act: (bloc) => bloc.add(LoadSoundSettings()),
      expect: () => [isA<SoundSettingsError>()],
    );
  });

  group('ToggleSoundEnabled', () {
    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'emits optimistic state immediately, then stays on success',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        when(
          mockSave(soundOffSettings),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (bloc) => bloc.add(ToggleSoundEnabled(false)),
      expect: () => [const SoundSettingsLoaded(soundOffSettings)],
      verify: (_) {
        verify(mockSave(soundOffSettings)).called(1);
        verifyNoMoreInteractions(mockSave);
      },
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'reverts to previous state and emits error when save fails',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        when(mockSave(soundOffSettings)).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'write error')),
        );
      },
      act: (bloc) => bloc.add(ToggleSoundEnabled(false)),
      expect: () => [
        // 1. Optimistic flip
        const SoundSettingsLoaded(soundOffSettings),
        // 2. Revert to original
        const SoundSettingsLoaded(defaultSettings),
        // 3. Error surfaced for snackbar
        isA<SoundSettingsError>(),
      ],
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'does nothing when state is not SoundSettingsLoaded',
      build: buildBloc,
      act: (bloc) => bloc.add(ToggleSoundEnabled(false)),
      expect: () => [],
      verify: (_) => verifyNever(mockSave(any)),
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'handles rapid toggles correctly when save is slow',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        // Simulate slow save operation
        when(mockSave(any)).thenAnswer(
          (_) async => await Future.delayed(
            const Duration(milliseconds: 100),
            () => const Right(unit),
          ),
        );
      },
      act: (bloc) {
        bloc.add(ToggleSoundEnabled(false));
        // Toggle again before first operation completes
        Future.delayed(const Duration(milliseconds: 10), () {
          bloc.add(ToggleSoundEnabled(true));
        });
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        // First optimistic flip
        const SoundSettingsLoaded(soundOffSettings),
        // Second optimistic flip (reverts to original)
        const SoundSettingsLoaded(defaultSettings),
      ],
      verify: (_) {
        // Both toggles should be saved
        verify(mockSave(soundOffSettings)).called(1);
        verify(mockSave(defaultSettings)).called(1);
      },
    );
  });

  group('ToggleHapticEnabled', () {
    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'emits optimistic state immediately, then stays on success',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        when(
          mockSave(hapticOffSettings),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (bloc) => bloc.add(ToggleHapticEnabled(false)),
      expect: () => [const SoundSettingsLoaded(hapticOffSettings)],
      verify: (_) {
        verify(mockSave(hapticOffSettings)).called(1);
        verifyNoMoreInteractions(mockSave);
      },
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'reverts to previous state and emits error when save fails',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        when(mockSave(hapticOffSettings)).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'write error')),
        );
      },
      act: (bloc) => bloc.add(ToggleHapticEnabled(false)),
      expect: () => [
        const SoundSettingsLoaded(hapticOffSettings),
        const SoundSettingsLoaded(defaultSettings),
        isA<SoundSettingsError>(),
      ],
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'does nothing when state is not SoundSettingsLoaded',
      build: buildBloc,
      act: (bloc) => bloc.add(ToggleHapticEnabled(false)),
      expect: () => [],
      verify: (_) => verifyNever(mockSave(any)),
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'handles rapid toggles correctly when save is slow',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        when(mockSave(any)).thenAnswer(
          (_) async => await Future.delayed(
            const Duration(milliseconds: 100),
            () => const Right(unit),
          ),
        );
      },
      act: (bloc) {
        bloc.add(ToggleHapticEnabled(false));
        Future.delayed(const Duration(milliseconds: 10), () {
          bloc.add(ToggleHapticEnabled(true));
        });
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        const SoundSettingsLoaded(hapticOffSettings),
        const SoundSettingsLoaded(defaultSettings),
      ],
    );
  });

  group('State Recovery Tests', () {
    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'recovers successfully after an error state',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        // First save fails
        when(mockSave(soundOffSettings)).thenAnswer(
          (_) async => const Left(CacheFailure(message: 'temporary error')),
        );
      },
      act: (bloc) {
        // Trigger error
        bloc.add(ToggleSoundEnabled(false));
        // Then try again - now it succeeds
        when(
          mockSave(soundOffSettings),
        ).thenAnswer((_) async => const Right(unit));
        bloc.add(ToggleSoundEnabled(false));
      },
      expect: () => [
        // First toggle - optimistic
        const SoundSettingsLoaded(soundOffSettings),
        // Revert to original due to error
        const SoundSettingsLoaded(defaultSettings),
        // Error emitted
        isA<SoundSettingsError>(),
        // Second toggle - optimistic
        const SoundSettingsLoaded(soundOffSettings),
      ],
    );

    blocTest<SoundSettingsBloc, SoundSettingsState>(
      'maintains settings through multiple error recovery attempts',
      build: buildBloc,
      seed: () => const SoundSettingsLoaded(defaultSettings),
      setUp: () {
        int attemptCount = 0;
        when(mockSave(any)).thenAnswer((_) async {
          attemptCount++;
          if (attemptCount <= 2) {
            return Left(CacheFailure(message: 'error $attemptCount'));
          }
          return const Right(unit);
        });
      },
      act: (bloc) {
        bloc.add(ToggleSoundEnabled(false));
        bloc.add(ToggleSoundEnabled(false));
        bloc.add(ToggleSoundEnabled(false));
      },
      wait: const Duration(milliseconds: 50),
      expect: () => [
        const SoundSettingsLoaded(soundOffSettings),
        // Error 1
        const SoundSettingsLoaded(defaultSettings),
        isA<SoundSettingsError>(),
        // Error 2
        const SoundSettingsLoaded(soundOffSettings),
        const SoundSettingsLoaded(defaultSettings),
        isA<SoundSettingsError>(),
        // Success
        const SoundSettingsLoaded(soundOffSettings),
      ],
    );

    group('Concurrent Operations', () {
      blocTest<SoundSettingsBloc, SoundSettingsState>(
        'handles simultaneous sound and haptic toggles',
        build: buildBloc,
        seed: () => const SoundSettingsLoaded(defaultSettings),
        setUp: () {
          when(mockSave(any)).thenAnswer((_) async {
            await Future.delayed(const Duration(milliseconds: 50));
            return const Right(unit);
          });
        },
        act: (bloc) {
          bloc.add(ToggleSoundEnabled(false));
          bloc.add(ToggleHapticEnabled(false));
        },
        wait: const Duration(milliseconds: 100),
        expect: () => [
          const SoundSettingsLoaded(soundOffSettings),
          const SoundSettingsLoaded(
            SoundSettings(soundEnabled: false, hapticEnabled: false),
          ),
        ],
        verify: (_) {
          verify(mockSave(any)).called(2);
        },
      );
    });

    group('SoundSettings Entity Tests', () {
      test('copyWith preserves unchanged fields', () {
        const original = SoundSettings(soundEnabled: true, hapticEnabled: true);
        final result = original.copyWith(soundEnabled: false);

        expect(result.soundEnabled, false);
        expect(result.hapticEnabled, true); // unchanged
      });

      test('copyWith can change both fields', () {
        const original = SoundSettings(soundEnabled: true, hapticEnabled: true);
        final result = original.copyWith(
          soundEnabled: false,
          hapticEnabled: false,
        );

        expect(result.soundEnabled, false);
        expect(result.hapticEnabled, false);
      });

      test('equality works correctly', () {
        const a = SoundSettings(soundEnabled: true, hapticEnabled: false);
        const b = SoundSettings(soundEnabled: true, hapticEnabled: false);
        const c = SoundSettings(soundEnabled: false, hapticEnabled: false);

        expect(a, equals(b));
        expect(a, isNot(equals(c)));
      });

      test('hashCode is consistent with equality', () {
        const a = SoundSettings(soundEnabled: true, hapticEnabled: false);
        const b = SoundSettings(soundEnabled: true, hapticEnabled: false);

        expect(a.hashCode, equals(b.hashCode));
      });

      test('toString includes all fields', () {
        const settings = SoundSettings(
          soundEnabled: true,
          hapticEnabled: false,
        );

        final str = settings.toString();
        expect(str, contains('soundEnabled: true'));
        expect(str, contains('hapticEnabled: false'));
      });
    });
  });
}
