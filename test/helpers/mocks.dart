import 'package:catbreeds/core/network/dio_client.dart';
import 'package:catbreeds/data/datasources/breed/breed_remote_datasource.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/repositories/breed_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockDioClient extends Mock implements DioClient {}

class MockBreedRemoteDataSource extends Mock implements BreedRemoteDataSource {}

class MockBreedRepository extends Mock implements BreedRepository {}

Breed fakeBreed(
  String id, {
  String? name,
  String? weightKg = '3 - 5',
  String? origin = 'Egypt',
  String? countryCode = 'EG',
}) {
  return Breed(
    id: id,
    name: name ?? 'Breed $id',
    description: 'Description of $id',
    temperament: const ['Calm', 'Playful'],
    origin: origin,
    countryCode: countryCode,
    lifeSpan: '12-15',
    weightKg: weightKg,
    weightLb: '7 - 11',
    heightCm: '25 - 30',
    heightIn: '10 - 12',
    breedGroup: 'Short-haired',
  );
}
