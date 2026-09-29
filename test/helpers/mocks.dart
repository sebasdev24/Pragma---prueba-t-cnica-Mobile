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
  int? intelligence,
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
    weightKg: '3-5',
    breedGroup: 'Short-haired',
    intelligence: intelligence,
  );
}
