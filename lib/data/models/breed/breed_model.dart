import 'package:catbreeds/domain/entities/breed.dart';

/// Una raza tal como la manda `/v1/breeds`.
///
/// El parseo se hizo desconfiado a propósito. The Cat API cambia sin avisar (ya
/// dejó de mandar `intelligence` y `adaptability`), así que si un campo
/// falta o llega con otro tipo, queda en null y la lista sigue cargando.
class BreedModel {
  final String id;
  final String name;
  final String? description;
  final String? temperament;
  final String? origin;
  final String? countryCode;
  final String? lifeSpan;
  final String? weightMetric;
  final String? weightImperial;
  final String? heightMetric;
  final String? heightImperial;
  final String? breedGroup;
  final String? history;
  final String? imageUrl;
  final String? referenceImageId;

  const BreedModel({
    required this.id,
    required this.name,
    this.description,
    this.temperament,
    this.origin,
    this.countryCode,
    this.lifeSpan,
    this.weightMetric,
    this.weightImperial,
    this.heightMetric,
    this.heightImperial,
    this.breedGroup,
    this.history,
    this.imageUrl,
    this.referenceImageId,
  });

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
      weightMetric: _unit(json['weight'], 'metric'),
      weightImperial: _unit(json['weight'], 'imperial'),
      heightMetric: _unit(json['height'], 'metric'),
      heightImperial: _unit(json['height'], 'imperial'),
      breedGroup: _string(json['breed_group']),
      history: _string(json['history']),
      imageUrl: image is Map ? _string(image['url']) : null,
      referenceImageId: _string(json['reference_image_id']),
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
      weightLb: weightImperial,
      heightCm: heightMetric,
      heightIn: heightImperial,
      breedGroup: breedGroup,
      history: history,
      imageUrl: resolvedImage,
    );
  }

  static String? _string(Object? value) {
    if (value is! String) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// `weight` y `height` vienen como `{metric, imperial}`; esto saca uno.
  static String? _unit(Object? value, String system) =>
      value is Map ? _string(value[system]) : null;
}
