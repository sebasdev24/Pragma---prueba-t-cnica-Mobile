import 'dart:async';

import 'package:catbreeds/core/constants/api_constants.dart';
import 'package:catbreeds/core/di/breed_dependencies.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/usecases/breed/search_breeds_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BreedSearchStatus { idle, loading, success, failure }

class BreedSearchState extends Equatable {
  final String query;
  final BreedSearchStatus status;
  final List<Breed> results;
  final Failure? failure;

  const BreedSearchState({
    this.query = '',
    this.status = BreedSearchStatus.idle,
    this.results = const [],
    this.failure,
  });

  /// Hay algo escrito en el buscador, así que la vista muestra resultados
  /// en vez de la lista completa.
  bool get isActive => query.isNotEmpty;

  @override
  List<Object?> get props => [query, status, results, failure];
}

/// La búsqueda por nombre contra `/v1/breeds/search`.
///
/// Espera a que el usuario deje de escribir antes de buscar (debounce), para
/// no lanzar una request por cada tecla.
///
/// Además, cada búsqueda lleva un número. Si cuando llega la respuesta ya
/// hay una búsqueda más nueva, la vieja se ignora. Así, si "ben" responde
/// después que "beng", no pisa los resultados buenos.
class BreedSearchNotifier extends StateNotifier<BreedSearchState> {
  BreedSearchNotifier(
    this._searchBreeds, {
    this.debounce = ApiConstants.searchDebounce,
  }) : super(const BreedSearchState());

  final SearchBreedsUseCase _searchBreeds;
  final Duration debounce;

  Timer? _timer;
  int _generation = 0;

  void onQueryChanged(String raw) {
    final query = raw.trim();
    if (query == state.query) return;
    _timer?.cancel();

    if (query.isEmpty) {
      clear();
      return;
    }

    _generation++;
    state = BreedSearchState(
      query: query,
      status: BreedSearchStatus.loading,
      results: state.results,
    );
    _timer = Timer(debounce, () => _run(query));
  }

  /// Vuelve a buscar lo mismo, sin esperar el debounce.
  Future<void> retry() async {
    if (!state.isActive) return;
    _timer?.cancel();
    _generation++;
    state = BreedSearchState(
      query: state.query,
      status: BreedSearchStatus.loading,
    );
    await _run(state.query);
  }

  void clear() {
    _timer?.cancel();
    _generation++;
    state = const BreedSearchState();
  }

  Future<void> _run(String query) async {
    final generation = _generation;
    final result = await _searchBreeds(query);
    if (!mounted || generation != _generation) return;

    state = result.fold(
      (f) => BreedSearchState(
        query: query,
        status: BreedSearchStatus.failure,
        failure: f,
      ),
      (breeds) => BreedSearchState(
        query: query,
        status: BreedSearchStatus.success,
        results: breeds,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final breedSearchProvider =
    StateNotifierProvider<BreedSearchNotifier, BreedSearchState>((ref) {
      return BreedSearchNotifier(ref.watch(searchBreedsUseCaseProvider));
    });
