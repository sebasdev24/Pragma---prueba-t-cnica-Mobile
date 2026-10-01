import 'package:catbreeds/core/di/breed_dependencies.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breed_search_provider.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breeds_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// La raza que muestra el detalle.
///
/// Si llegaste desde la lista o la búsqueda, ya la tenemos en memoria y no
/// hay que pedirla otra vez. Solo vamos a la red cuando se entra directo,
/// por ejemplo con un deep link a `/breeds/:id`.
///
/// Si falla, lanzamos el `Failure` tal cual para que la vista pueda mostrar
/// su `userMessage`.
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
