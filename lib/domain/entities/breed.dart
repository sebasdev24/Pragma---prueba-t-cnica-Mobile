import 'package:equatable/equatable.dart';

/// Raza de gato tal como la usa la app. Todo lo que la API puede omitir es
/// nullable: la UI decide cómo mostrar el "sin dato", no el parser.
class Breed extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> temperament;
  final String? origin;
  final String? countryCode;

  /// Rango en años tal cual lo da la API, p. ej. `"14 - 17"`.
  final String? lifeSpan;

  /// Rango en kg, p. ej. `"3 - 5"`.
  final String? weightKg;

  /// Rango en cm, p. ej. `"25-30"`.
  final String? heightCm;
  final String? breedGroup;
  final String? history;

  /// Escala 1–5. Hoy `/v1/breeds` no los devuelve (el enunciado sí los
  /// pide), así que la UI muestra "Sin dato" cuando vienen en `null`.
  final int? intelligence;
  final int? adaptability;
  final String? imageUrl;
  final String? wikipediaUrl;

  const Breed({
    required this.id,
    required this.name,
    required this.description,
    this.temperament = const [],
    this.origin,
    this.countryCode,
    this.lifeSpan,
    this.weightKg,
    this.heightCm,
    this.breedGroup,
    this.history,
    this.intelligence,
    this.adaptability,
    this.imageUrl,
    this.wikipediaUrl,
  });

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

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
    heightCm,
    breedGroup,
    history,
    intelligence,
    adaptability,
    imageUrl,
    wikipediaUrl,
  ];
}
