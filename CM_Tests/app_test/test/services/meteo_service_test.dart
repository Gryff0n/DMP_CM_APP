import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_test/services/meteo_service.dart';

class MockMeteoApi extends Mock implements MeteoApi {} //(1)

void main() {
  late MockMeteoApi api;
  late MeteoService service;

  setUp(() {
    api = MockMeteoApi();
    service = MeteoService(api); //(2)
  });

  group('MeteoService.conseil', () {
    test('conseille un manteau quand il fait moins de 10 °C', () async {
      // Arrange : on programme la réponse du mock
      when(() => api.temperature('Orléans')).thenAnswer((_) async => 4.0); //(3)

      // Act
      final resultat = await service.conseil('Orléans'); //(4)

      // Assert
      expect(resultat, 'Prenez un manteau');
      verify(() => api.temperature('Orléans')).called(1); //(5)
    });

    test('propose un pull entre 10 et 20 °C', () async {
      when(() => api.temperature(any())) //(6)
          .thenAnswer((_) async => 15.0);

      expect(await service.conseil('Lyon'), 'Un pull suffira');
    });

    test(
      'propose une tenue légère à partir de 20 °C (limite incluse)',
      () async {
        when(() => api.temperature(any())).thenAnswer((_) async => 20.0);

        expect(await service.conseil('Nice'), 'Tenue légère');
      },
    );

    test('lève MeteoException si l\'API échoue', () async {
      when(() => api.temperature(any())).thenThrow(Exception('timeout')); //(7)

      await expectLater(
        //(8)
        service.conseil('Paris'),
        throwsA(isA<MeteoException>()),
      );
    });

    test('n\'appelle pas l\'API si la ville est vide', () async {
      await expectLater(service.conseil('   '), throwsA(isA<MeteoException>()));
      verifyNever(() => api.temperature(any())); //(9)
    });
  });

  group('MeteoService.moyenne', () {
    test(
      'calcule la moyenne avec une température différente par ville',
      () async {
        // Arrange : une réponse distincte par ville
        when(() => api.temperature('Paris')).thenAnswer((_) async => 10.0);
        when(() => api.temperature('Lyon')).thenAnswer((_) async => 20.0);
        when(() => api.temperature('Nice')).thenAnswer((_) async => 30.0);

        // Act
        final resultat = await service.moyenne(['Paris', 'Lyon', 'Nice']);

        // Assert
        expect(resultat, 20.0); // (10 + 20 + 30) / 3
        verify(() => api.temperature('Paris')).called(1);
        verify(() => api.temperature('Lyon')).called(1);
        verify(() => api.temperature('Nice')).called(1);
        verifyNoMoreInteractions(api); // aucun autre appel
      },
    );

    test('lève MeteoException si la liste est vide', () async {
      await expectLater(service.moyenne([]), throwsA(isA<MeteoException>()));
      verifyNever(() => api.temperature(any()));
    });

    test('lève MeteoException si l\'API échoue pour une ville', () async {
      when(() => api.temperature('Paris')).thenAnswer((_) async => 10.0);
      when(() => api.temperature('Lyon')).thenThrow(Exception('timeout'));

      await expectLater(
        service.moyenne(['Paris', 'Lyon']),
        throwsA(isA<MeteoException>()),
      );
    });
  });
}
