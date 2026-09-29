import 'package:catbreeds/core/constants/api_constants.dart';
import 'package:catbreeds/core/di/breed_dependencies.dart';
import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/domain/usecases/breed/get_breeds_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum BreedsListStatus { initial, loading, success, failure }

class BreedsListState extends Equatable {
  final BreedsListStatus status;
  final List<Breed> items;

  /// Total según la API (`pagination-count`).
  final int total;

  /// Próxima página a pedir (la API pagina desde 0).
  final int nextPage;
  final bool isLoadingMore;

  /// Error de la primera página: ocupa toda la pantalla.
  final Failure? failure;

  /// Error al paginar: solo afecta al pie de la lista.
  final Failure? loadMoreFailure;

  const BreedsListState({
    this.status = BreedsListStatus.initial,
    this.items = const [],
    this.total = 0,
    this.nextPage = 0,
    this.isLoadingMore = false,
    this.failure,
    this.loadMoreFailure,
  });

  bool get hasMore => items.length < total;

  BreedsListState copyWith({
    BreedsListStatus? status,
    List<Breed>? items,
    int? total,
    int? nextPage,
    bool? isLoadingMore,
    Failure? Function()? failure,
    Failure? Function()? loadMoreFailure,
  }) {
    return BreedsListState(
      status: status ?? this.status,
      items: items ?? this.items,
      total: total ?? this.total,
      nextPage: nextPage ?? this.nextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure != null ? failure() : this.failure,
      loadMoreFailure: loadMoreFailure != null
          ? loadMoreFailure()
          : this.loadMoreFailure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    total,
    nextPage,
    isLoadingMore,
    failure,
    loadMoreFailure,
  ];
}

/// Listado paginado de razas (scroll infinito).
///
/// No es `autoDispose`: al volver del detalle la lista conserva sus páginas
/// y su posición en vez de recargarse desde cero.
class BreedsListNotifier extends StateNotifier<BreedsListState> {
  BreedsListNotifier(this._getBreeds, {this.pageSize = ApiConstants.pageSize})
    : super(const BreedsListState());

  final GetBreedsUseCase _getBreeds;
  final int pageSize;

  /// Carga la primera página. Idempotente: si ya hay datos o una carga en
  /// curso, no hace nada (la splash y la lista pueden llamarla ambas).
  Future<void> loadFirstPage() async {
    if (state.status == BreedsListStatus.loading ||
        state.status == BreedsListStatus.success) {
      return;
    }
    state = state.copyWith(
      status: BreedsListStatus.loading,
      failure: () => null,
    );
    await _fetchFirstPage();
  }

  /// Pull-to-refresh: vuelve a la página 0 sin vaciar la lista mientras
  /// carga. Si falla, conserva lo que había.
  Future<void> refresh() async {
    if (state.items.isEmpty) {
      state = state.copyWith(status: BreedsListStatus.loading);
    }
    await _fetchFirstPage(keepOnError: state.items.isNotEmpty);
  }

  Future<void> loadMore() async {
    if (state.status != BreedsListStatus.success ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }
    state = state.copyWith(isLoadingMore: true, loadMoreFailure: () => null);

    final result = await _getBreeds(page: state.nextPage, limit: pageSize);
    if (!mounted) return;

    state = result.fold(
      (f) => state.copyWith(isLoadingMore: false, loadMoreFailure: () => f),
      (page) {
        // Por si la API reordena entre páginas: nunca duplicar una raza.
        final seen = state.items.map((b) => b.id).toSet();
        final fresh = page.items.where((b) => seen.add(b.id));
        return state.copyWith(
          items: [...state.items, ...fresh],
          total: page.total,
          nextPage: page.page + 1,
          isLoadingMore: false,
        );
      },
    );
  }

  Future<void> _fetchFirstPage({bool keepOnError = false}) async {
    final result = await _getBreeds(page: 0, limit: pageSize);
    if (!mounted) return;

    state = result.fold(
      (f) => keepOnError
          ? state.copyWith(status: BreedsListStatus.success)
          : BreedsListState(status: BreedsListStatus.failure, failure: f),
      (page) => BreedsListState(
        status: BreedsListStatus.success,
        items: page.items,
        total: page.total,
        nextPage: page.page + 1,
      ),
    );
  }
}

final breedsListProvider =
    StateNotifierProvider<BreedsListNotifier, BreedsListState>((ref) {
      return BreedsListNotifier(ref.watch(getBreedsUseCaseProvider));
    });
