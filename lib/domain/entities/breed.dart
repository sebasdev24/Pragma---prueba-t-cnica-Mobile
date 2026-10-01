import 'package:equatable/equatable.dart';

/// Una raza como la usa la app. Lo que la API a veces no manda es nullable,
/// y es la vista la que decide cómo mostrar que falta.
class Breed extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> temperament;
  final String? origin;
  final String? countryCode;

  /// En años y tal como lo manda la API, por ejemplo `"14 - 17"`.
  final String? lifeSpan;

  /// En kilos, por ejemplo `"3 - 5"`.
  final String? weightKg;

  /// En libras, por ejemplo `"8 - 12"`.
  final String? weightLb;

  /// En centímetros, por ejemplo `"25-30"`.
  final String? heightCm;

  /// En pulgadas, por ejemplo `"10-12"`.
  final String? heightIn;
  final String? breedGroup;
  final String? history;
  final String? imageUrl;

  const Breed({
    required this.id,
    required this.name,
    required this.description,
    this.temperament = const [],
    this.origin,
    this.countryCode,
    this.lifeSpan,
    this.weightKg,
    this.weightLb,
    this.heightCm,
    this.heightIn,
    this.breedGroup,
    this.history,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    temperament,
    origin,
    countryCode,
    lifeSpan,
    weightKg,
    weightLb,
    heightCm,
    heightIn,
    breedGroup,
    history,
    imageUrl,
  ];
}
