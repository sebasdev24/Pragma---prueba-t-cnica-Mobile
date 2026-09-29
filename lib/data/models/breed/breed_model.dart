import 'package:catbreeds/domain/entities/breed.dart';

/// DTO de `/v1/breeds`. Parsea a la defensiva: The Cat API cambia de forma
/// sin versionar (hoy ya no manda `intelligence` ni `adaptability`), así
/// que un campo ausente o con otro tipo nunca debe tumbar la lista.
class BreedModel {
  final String id;
  final String name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? countryCode;
  final String? lifeSpan;
  final String? weightMetric;
  final String? heightMetric;
  final String? breedGroup;
  final String? history;
  final int? intelligence;
  final int? adaptability;
  final String? imageUrl;
  final String? referenceImageId;
  final String? wikipediaUrl;

  const BreedModel({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.countryCode,
    this.lifeSpan,
    this.weightMetric,
    this.heightMetric,
    this.breedGroup,
    this.history,
    this.intelligence,
    this.adaptability,
    this.imageUrl,
    this.referenceImageId,
    this.wikipediaUrl,
  });

  /// CDN de imágenes de The Cat API. Se usa cuando la respuesta trae
  /// `reference_image_id` pero no el objeto `image` (p. ej. `/breeds/{id}`).
  static const _imageCdn = 'https://cdn2.thecatapi.com/images';

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    final image = json['image'];
    return BreedModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: _string(json['description']),
      temperament: _string(json['temperament']),
      origin: _string(json['origin']),
      countryCode: _string(json['country_code']),
      lifeSpan: _string(json['life_span']),
      weightMetric: _metric(json['weight']),
      heightMetric: _metric(json['height']),
      breedGroup: _string(json['breed_group']),
      history: _string(json['history']),
      intelligence: _score(json['intelligence']),
      adaptability: _score(json['adaptability']),
      imageUrl: image is Map ? _string(image['url']) : null,
      referenceImageId: _string(json['reference_image_id']),
      wikipediaUrl: _string(json['wikipedia_url']),
    );
  }

  Breed toEntity() {
    final resolvedImage =
        imageUrl ??
        (referenceImageId == null ? null : '$_imageCdn/$referenceImageId.jpg');

    return Breed(
      id: id,
      name: name.trim(),
      description: description ?? '',
      temperament: (temperament ?? '')
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList(growable: false),
      origin: origin,
      countryCode: countryCode,
      lifeSpan: lifeSpan,
      weightKg: weightMetric,
      heightCm: heightMetric,
      breedGroup: breedGroup,
      history: history,
      intelligence: intelligence,
      adaptability: adaptability,
      imageUrl: resolvedImage,
      wikipediaUrl: wikipediaUrl,
    );
  }

  static String? _string(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? _metric(Object? value) =>
      value is Map ? _string(value['metric']) : null;

  /// Solo acepta la escala 1–5; cualquier otra cosa es "sin dato".
  static int? _score(Object? value) {
    final n = value is num ? value.toInt() : null;
    return (n != null && n >= 1 && n <= 5) ? n : null;
  }
}
