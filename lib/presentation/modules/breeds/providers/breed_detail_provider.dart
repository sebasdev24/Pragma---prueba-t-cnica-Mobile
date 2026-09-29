import 'package:catbreeds/core/di/breed_dependencies.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breed_search_provider.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breeds_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Raza para el detalle.
///
/// Si viene de la lista o de la búsqueda ya está en memoria y no se pide de
/// nuevo. Solo se va a la red cuando se llega sin pasar por la lista (deep
/// link `/breeds/:id` o restauración del sistema).
///
/// Si falla, el error es el `Failure` tipado, así la vista puede mostrar su
/// `userMessage`.
final breedDetailProvider = FutureProvider.autoDispose.family<Breed, String>((
  ref,
  id,
) async {
  final cached = [
    ...ref.read(breedsListProvider).items,
    ...ref.read(breedSearchProvider).results,
  ].where((b) => b.id == id);
  if (cached.isNotEmpty) return cached.first;

  final result = await ref.watch(getBreedByIdUseCaseProvider)(id);
  return result.fold((failure) => throw failure, (breed) => breed);
});
