import 'package:catbreeds/domain/entities/breed.dart';
import 'package:equatable/equatable.dart';

/// Un pedazo del listado de razas.
class BreedPage extends Equatable {
  final List<Breed> items;

  /// Número de página. Arranca en 0 porque así pagina The Cat API.
  final int page;

  /// Cuántas razas hay en total, según el header `pagination-count`.
  final int total;

  const BreedPage({
    required this.items,
    required this.page,
    required this.total,
  });

  @override
  List<Object?> get props => [items, page, total];
}
