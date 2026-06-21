import 'package:dartz/dartz.dart';
import 'package:fitflow/core/failure/failure.dart';
import 'package:fitflow/features/settings/data/datasources/sound_local_datasource.dart';
import 'package:fitflow/features/settings/data/repositories/sound_repository_impl.dart';
import 'package:fitflow/features/settings/domain/entities/sound_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sound_repository_test.mocks.dart';

@GenerateMocks([SoundLocalDatasource])
void main() {
  late MockSoundLocalDatasource mockDatasource;
  late SoundRepositoryImpl sut;

  const defaultSettings = SoundSettings(
    soundEnabled: true,
    hapticEnabled: false,
  );

  setUp(() {
    mockDatasource = MockSoundLocalDatasource();
    sut = SoundRepositoryImpl(datasource: mockDatasource);
  });

  group('SoundRepositoryImpl - getSoundSettings', () {
    test('returns Right(settings) when datasource succeeds', () async {
      // Arrange
      when(mockDatasource.getSoundSettings())
          .thenAnswer((_) async => defaultSettings);

      // Act
      final result = await sut.getSoundSettings();

      // Assert
      expect(result, const Right(defaultSettings));
      verify(mockDatasource.getSoundSettings()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('returns Left(CacheFailure) when datasource throws generic exception', () async {
      // Arrange
      when(mockDatasource.getSoundSettings())
          .thenThrow(Exception('disk read failed'));

      // Act
      final result = await sut.getSoundSettings();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('disk read failed'));
        },
        (_) => fail('expected Left'),
      );
    });

    test('returns Left(CacheFailure) when datasource throws specific exception', () async {
      // Arrange
      when(mockDatasource.getSoundSettings())
          .thenThrow(FormatException('Invalid data format'));

      // Act
      final result = await sut.getSoundSettings();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Invalid data format'));
        },
        (_) => fail('expected Left'),
      );
    });

    // FIXED: Remove null test since the method doesn't return nullable type
    // Instead, test with a different error scenario
    test('returns Left(CacheFailure) when datasource throws StateError', () async {
      // Arrange
      when(mockDatasource.getSoundSettings())
          .thenThrow(StateError('Invalid state'));

      // Act
      final result = await sut.getSoundSettings();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Invalid state'));
        },
        (_) => fail('expected Left'),
      );
    });

    test('handles concurrent get calls correctly', () async {
      // Arrange
      when(mockDatasource.getSoundSettings())
          .thenAnswer((_) async {
            await Future.delayed(Duration(milliseconds: 50));
            return defaultSettings;
          });

      // Act
      final results = await Future.wait([
        sut.getSoundSettings(),
        sut.getSoundSettings(),
        sut.getSoundSettings(),
      ]);

      // Assert
      expect(results.length, 3);
      for (final result in results) {
        expect(result, const Right(defaultSettings));
      }
      verify(mockDatasource.getSoundSettings()).called(3);
    });
  });

  group('SoundRepositoryImpl - saveSoundSettings', () {
    test('returns Right(unit) when datasource succeeds', () async {
      // Arrange
      when(mockDatasource.saveSoundSettings(defaultSettings))
          .thenAnswer((_) async => Future.value());

      // Act
      final result = await sut.saveSoundSettings(defaultSettings);

      // Assert
      expect(result, const Right(unit));
      verify(mockDatasource.saveSoundSettings(defaultSettings)).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('returns Left(CacheFailure) when datasource throws generic exception', () async {
      // Arrange
      when(mockDatasource.saveSoundSettings(defaultSettings))
          .thenThrow(Exception('disk write failed'));

      // Act
      final result = await sut.saveSoundSettings(defaultSettings);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('disk write failed'));
        },
        (_) => fail('expected Left'),
      );
    });

    test('returns Left(CacheFailure) when datasource throws specific exception', () async {
      // Arrange
      when(mockDatasource.saveSoundSettings(defaultSettings))
          .thenThrow(StateError('Invalid state'));

      // Act
      final result = await sut.saveSoundSettings(defaultSettings);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Invalid state'));
        },
        (_) => fail('expected Left'),
      );
    });

    test('handles concurrent save operations correctly', () async {
      // Arrange
      when(mockDatasource.saveSoundSettings(any))
          .thenAnswer((_) async {
            await Future.delayed(Duration(milliseconds: 50));
            return Future.value();
          });

      const settings1 = SoundSettings(soundEnabled: true, hapticEnabled: true);
      const settings2 = SoundSettings(soundEnabled: false, hapticEnabled: true);

      // Act
      final results = await Future.wait([
        sut.saveSoundSettings(settings1),
        sut.saveSoundSettings(settings2),
      ]);

      // Assert
      expect(results.length, 2);
      for (final result in results) {
        expect(result, const Right(unit));
      }
      verify(mockDatasource.saveSoundSettings(settings1)).called(1);
      verify(mockDatasource.saveSoundSettings(settings2)).called(1);
    });

    test('handles save failure after previous success', () async {
      // Arrange
      when(mockDatasource.saveSoundSettings(defaultSettings))
          .thenAnswer((_) async => Future.value());
      
      const newSettings = SoundSettings(soundEnabled: false, hapticEnabled: false);
      when(mockDatasource.saveSoundSettings(newSettings))
          .thenThrow(Exception('Database full'));

      // Act - First save succeeds
      final firstResult = await sut.saveSoundSettings(defaultSettings);
      expect(firstResult, const Right(unit));

      // Act - Second save fails
      final secondResult = await sut.saveSoundSettings(newSettings);

      // Assert
      expect(secondResult.isLeft(), true);
      secondResult.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('Database full'));
        },
        (_) => fail('expected Left'),
      );
    });
  });

  group('SoundRepositoryImpl - Error Message Verification', () {
    test('preserves original error message in failure', () async {
      // Arrange
      const errorMessage = 'Custom error: Unable to access storage';
      when(mockDatasource.getSoundSettings())
          .thenThrow(StateError(errorMessage));

      // Act
      final result = await sut.getSoundSettings();

      // Assert
      result.fold(
        (failure) => expect(failure.message, contains(errorMessage)),
        (_) => fail('expected Left'),
      );
    });

    test('handles error with no message gracefully', () async {
      // Arrange
      when(mockDatasource.getSoundSettings())
          .thenThrow(Exception()); // Exception with no message

      // Act
      final result = await sut.getSoundSettings();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, isNotNull);
        },
        (_) => fail('expected Left'),
      );
    });
  });
}