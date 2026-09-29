import 'package:catbreeds/domain/entities/breed.dart';
import 'package:equatable/equatable.dart';

/// Una página del listado de razas.
class BreedPage extends Equatable {
  final List<Breed> items;

  /// Página actual, empezando en 0 (así pagina The Cat API).
  final int page;

  /// Total de razas según el header `pagination-count`.
  final int total;

  const BreedPage({
    required this.items,
    required this.page,
    required this.total,
  });

  @override
  List<Object?> get props => [items, page, total];
}
