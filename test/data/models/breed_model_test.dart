import 'package:catbreeds/data/models/breed/breed_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/breed_fixtures.dart';

void main() {
  group('BreedModel', () {
    test('mapea una respuesta completa a la entidad', () {
      final breed = BreedModel.fromJson(abyssinianJson).toEntity();

      expect(breed.id, 'abys');
      expect(breed.name, 'Abyssinian');
      expect(breed.origin, 'Egypt');
      expect(breed.countryCode, 'EG');
      expect(breed.lifeSpan, '14-17');
      expect(breed.weightKg, '3.6-5.4');
      expect(breed.heightCm, '25-30');
      expect(breed.breedGroup, 'Short-haired');
      expect(breed.temperament, hasLength(7));
      expect(breed.temperament.first, 'Active');
      expect(breed.imageUrl, 'https://cdn2.thecatapi.com/images/KWdLHmOqc.jpg');
    });

    test('la API actual no trae intelligence/adaptability: quedan en null', () {
      final breed = BreedModel.fromJson(abyssinianJson).toEntity();

      expect(breed.intelligence, isNull);
      expect(breed.adaptability, isNull);
    });

    test('respeta las escalas cuando la API sí las manda', () {
      final breed = BreedModel.fromJson(legacyScoresJson).toEntity();

      expect(breed.intelligence, 5);
      expect(breed.adaptability, 4);
    });

    test('descarta escalas fuera de 1–5', () {
      final json = {...legacyScoresJson, 'intelligence': 0, 'adaptability': 9};
      final breed = BreedModel.fromJson(json).toEntity();

      expect(breed.intelligence, isNull);
      expect(breed.adaptability, isNull);
    });

    test('sin objeto image usa el CDN con reference_image_id', () {
      final breed = BreedModel.fromJson(legacyScoresJson).toEntity();

      expect(breed.imageUrl, 'https://cdn2.thecatapi.com/images/dN6eoeLjY.jpg');
    });

    test('raza sin foto ni origen no rompe el parseo', () {
      final breed = BreedModel.fromJson(noImageJson).toEntity();

      expect(breed.hasImage, isFalse);
      expect(breed.origin, isNull);
      expect(breed.countryCode, isNull);
      expect(breed.history, isNull);
    });

    test('strings vacíos o de otro tipo cuentan como ausentes', () {
      final json = {
        ...abyssinianJson,
        'origin': '   ',
        'country_code': 42,
        'temperament': 'Calm, , Playful ,',
      };
      final breed = BreedModel.fromJson(json).toEntity();

      expect(breed.origin, isNull);
      expect(breed.countryCode, isNull);
      expect(breed.temperament, ['Calm', 'Playful']);
    });
  });
}
