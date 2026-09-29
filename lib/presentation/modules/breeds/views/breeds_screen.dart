import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/core/router/app_routes.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breed_search_provider.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breeds_list_provider.dart';
import 'package:catbreeds/presentation/modules/breeds/widgets/breed_card.dart';
import 'package:catbreeds/presentation/modules/breeds/widgets/breed_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Landing: título, buscador fijo y cards. Con texto en el buscador muestra
/// resultados de `/breeds/search`; sin texto, el listado paginado.
class BreedsScreen extends ConsumerStatefulWidget {
  const BreedsScreen({super.key});

  @override
  ConsumerState<BreedsScreen> createState() => _BreedsScreenState();
}

class _BreedsScreenState extends ConsumerState<BreedsScreen> {
  final _queryController = TextEditingController();
  final _scrollController = ScrollController();

  /// Distancia al final a la que se pide la siguiente página.
  static const _loadMoreThreshold = 900.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Si se entra sin pasar por la splash (deep link), carga aquí. Tras el
    // primer frame: no se puede modificar un provider durante initState.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(breedsListProvider.notifier).loadFirstPage(),
    );
    // Conserva el texto si se vuelve a esta pantalla con una búsqueda activa.
    _queryController.text = ref.read(breedSearchProvider).query;
  }

  @override
  void dispose() {
    _queryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (ref.read(breedSearchProvider).isActive) return;
    final position = _scrollController.position;
    if (position.extentAfter < _loadMoreThreshold) {
      ref.read(breedsListProvider.notifier).loadMore();
    }
  }

  void _openDetail(Breed breed) {
    FocusScope.of(context).unfocus();
    context.push(AppRoutes.breedDetailPath(breed.id));
  }

  void _onQueryChanged(String query) {
    // Los resultados empiezan arriba: si la lista estaba desplazada, se
    // vuelve al inicio para que no queden fuera de vista.
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.jumpTo(0);
    }
    ref.read(breedSearchProvider.notifier).onQueryChanged(query);
  }

  void _clearSearch() {
    _queryController.clear();
    ref.read(breedSearchProvider.notifier).clear();
  }

  Future<void> _onRefresh() {
    final search = ref.read(breedSearchProvider);
    return search.isActive
        ? ref.read(breedSearchProvider.notifier).retry()
        : ref.read(breedsListProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final list = ref.watch(breedsListProvider);
    final search = ref.watch(breedSearchProvider);
    final spacing = context.spacing;

    // Sin AppBar, así que la pantalla fija íconos oscuros en la barra de
    // estado (el splash la deja en claro).
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator.adaptive(
            onRefresh: _onRefresh,
            color: context.colors.accent,
            child: CustomScrollView(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    spacing.md,
                    spacing.lg,
                    spacing.sm,
                  ),
                  sliver: SliverToBoxAdapter(child: _Header(list: list)),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _PinnedSearch(
                    background: context.colors.background,
                    padding: EdgeInsets.fromLTRB(
                      spacing.lg,
                      spacing.md,
                      spacing.lg,
                      spacing.md,
                    ),
                    child: AppSearchField(
                      controller: _queryController,
                      onChanged: _onQueryChanged,
                      onClear: () =>
                          ref.read(breedSearchProvider.notifier).clear(),
                    ),
                  ),
                ),
                if (search.isActive)
                  ..._searchSlivers(search)
                else
                  ..._listSlivers(list),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + spacing.xl2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Listado
  // ---------------------------------------------------------------------------

  List<Widget> _listSlivers(BreedsListState list) {
    final l10n = context.l10n;
    switch (list.status) {
      case BreedsListStatus.initial:
      case BreedsListStatus.loading:
        return [
          _sectionLabel(l10n.allBreeds, trailing: l10n.sortAZ),
          const _SkeletonList(count: 3),
        ];
      case BreedsListStatus.failure:
        return [
          SliverToBoxAdapter(
            child: AppStatusView(
              tone: AppStatusTone.error,
              title: l10n.errorTitle,
              message: list.failure!.userMessage,
              actionLabel: l10n.retry,
              onAction: () =>
                  ref.read(breedsListProvider.notifier).loadFirstPage(),
            ),
          ),
        ];
      case BreedsListStatus.success:
        return [
          _sectionLabel(l10n.allBreeds, trailing: l10n.sortAZ),
          _cards(list.items),
          SliverToBoxAdapter(child: _ListFooter(list: list)),
        ];
    }
  }

  // ---------------------------------------------------------------------------
  // Búsqueda
  // ---------------------------------------------------------------------------

  List<Widget> _searchSlivers(BreedSearchState search) {
    final l10n = context.l10n;
    switch (search.status) {
      case BreedSearchStatus.idle:
      case BreedSearchStatus.loading:
        return [_sectionLabel(l10n.searching), const _SkeletonList(count: 2)];
      case BreedSearchStatus.failure:
        return [
          SliverToBoxAdapter(
            child: AppStatusView(
              tone: AppStatusTone.error,
              title: l10n.errorTitle,
              message: search.failure!.userMessage,
              actionLabel: l10n.retry,
              onAction: () => ref.read(breedSearchProvider.notifier).retry(),
            ),
          ),
        ];
      case BreedSearchStatus.success:
        if (search.results.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: AppStatusView(
                title: l10n.emptyTitle,
                message: l10n.emptyBody(search.query),
                actionLabel: l10n.clearSearch,
                onAction: _clearSearch,
              ),
            ),
          ];
        }
        return [
          _sectionLabel(
            l10n.searchResults(search.results.length, search.query),
          ),
          _cards(search.results),
        ];
    }
  }

  // ---------------------------------------------------------------------------
  // Piezas compartidas
  // ---------------------------------------------------------------------------

  Widget _sectionLabel(String text, {String? trailing}) {
    final spacing = context.spacing;
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg + spacing.sm,
        spacing.base,
        spacing.lg + spacing.sm,
        spacing.md + spacing.sx,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            Expanded(
              child: AppLabel(text, color: context.colors.foregroundMuted),
            ),
            if (trailing != null) AppLabel(trailing),
          ],
        ),
      ),
    );
  }

  Widget _cards(List<Breed> breeds) {
    return SliverPadding(
      padding: context.spacing.screen,
      sliver: SliverList.separated(
        itemCount: breeds.length,
        separatorBuilder: (_, _) => SizedBox(height: context.spacing.lg),
        itemBuilder: (_, i) => BreedCard(
          key: ValueKey(breeds[i].id),
          breed: breeds[i],
          onTap: () => _openDetail(breeds[i]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.list});

  final BreedsListState list;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final isFailure = list.status == BreedsListStatus.failure;
    final eyebrow = list.status == BreedsListStatus.success
        ? l10n.breedsEyebrow(list.total)
        : l10n.breedsEyebrowLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFailure)
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: colors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: context.spacing.base),
              AppLabel(eyebrow),
            ],
          ),
        SizedBox(height: context.spacing.md),
        Semantics(
          header: true,
          child: Text(
            l10n.appTitle,
            style: context.typography.display.xl.copyWith(
              color: colors.foreground,
            ),
          ),
        ),
        SizedBox(height: context.spacing.sm),
        Text(
          l10n.breedsSubtitle,
          style: context.typography.display.italic.copyWith(
            color: colors.foregroundMuted,
          ),
        ),
      ],
    );
  }
}

class _ListFooter extends ConsumerWidget {
  const _ListFooter({required this.list});

  final BreedsListState list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final l10n = context.l10n;

    final Widget child;
    if (list.isLoadingMore) {
      child = const CircularProgressIndicator.adaptive();
    } else if (list.loadMoreFailure != null) {
      child = Column(
        children: [
          Text(
            l10n.loadMoreError,
            style: context.typography.system.subhead.copyWith(
              color: context.colors.foregroundMuted,
            ),
          ),
          SizedBox(height: spacing.md),
          AppOutlinedButton(
            label: l10n.retry,
            onPressed: () => ref.read(breedsListProvider.notifier).loadMore(),
          ),
        ],
      );
    } else if (!list.hasMore) {
      child = AppLabel(l10n.endOfList(list.items.length));
    } else {
      child = const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xl),
      child: Center(child: child),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: context.spacing.screen,
      sliver: SliverToBoxAdapter(
        child: AppShimmer(
          child: Column(
            spacing: context.spacing.lg,
            children: List.generate(count, (_) => const BreedCardSkeleton()),
          ),
        ),
      ),
    );
  }
}

/// Mantiene el buscador visible mientras se hace scroll.
class _PinnedSearch extends SliverPersistentHeaderDelegate {
  _PinnedSearch({
    required this.child,
    required this.background,
    required this.padding,
  });

  final Widget child;
  final Color background;
  final EdgeInsets padding;

  /// Alto del campo (44–48 según plataforma) más su padding vertical.
  static const _fieldHeight = 48.0;

  @override
  double get minExtent => _fieldHeight + padding.vertical;

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    return ColoredBox(
      color: background,
      child: Padding(
        padding: padding,
        child: Center(child: child),
      ),
    );
  }

  @override
  bool shouldRebuild(_PinnedSearch old) =>
      old.child != child || old.background != background;
}
