import 'dart:math' as math;

import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breed_detail_provider.dart';
import 'package:catbreeds/presentation/modules/breeds/widgets/breed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Detalle de una raza.
///
/// Requisito del enunciado: la imagen queda fija y solo la información se
/// desplaza. Por eso la foto está fuera del scroll y el `Scrollbar` solo
/// envuelve la ficha.
class BreedDetailScreen extends ConsumerWidget {
  const BreedDetailScreen({super.key, required this.breedId});

  final String breedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(breedDetailProvider(breedId));
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(detail.valueOrNull?.name ?? ''),
        leading: const BackButton(),
      ),
      body: detail.when(
        data: (breed) => _DetailBody(breed: breed),
        loading: () => const _DetailSkeleton(),
        error: (error, _) => Center(
          child: SingleChildScrollView(
            child: AppStatusView(
              tone: AppStatusTone.error,
              title: l10n.detailErrorTitle,
              message: error is Failure
                  ? error.userMessage
                  : const UnknownFailure('').userMessage,
              actionLabel: l10n.retry,
              onAction: () => ref.invalidate(breedDetailProvider(breedId)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alto de la foto fija: ~36 % de la pantalla, con tope para tablets.
double _photoHeight(BuildContext context) =>
    math.min(MediaQuery.sizeOf(context).height * 0.36, 360);

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(spacing.lg, spacing.base, spacing.lg, 0),
          child: SizedBox(
            height: _photoHeight(context),
            child: Hero(
              tag: BreedCard.heroTag(breed.id),
              child: AppNetworkImage(
                url: breed.imageUrl,
                borderRadius: BorderRadius.circular(context.radius.xl2),
                semanticLabel: l10n.photoOf(breed.name),
                fallbackLabel: l10n.noPhoto,
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              Scrollbar(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    spacing.lg,
                    spacing.xl,
                    spacing.lg,
                    MediaQuery.paddingOf(context).bottom + spacing.safe,
                  ),
                  child: _BreedInfo(breed: breed),
                ),
              ),
              // Borde superior difuminado: se lee que el texto pasa por
              // debajo del límite de la foto, que no se mueve.
              IgnorePointer(
                child: Container(
                  height: spacing.lg,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.background,
                        colors.background.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BreedInfo extends StatelessWidget {
  const _BreedInfo({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final colors = context.colors;
    final l10n = context.l10n;

    final eyebrow = [
      if (breed.breedGroup != null) breed.breedGroup!.toUpperCase(),
      if (breed.heightCm != null) '${breed.heightCm} CM',
    ].join(' · ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow.isNotEmpty) ...[
          AppLabel(eyebrow, color: colors.accent),
          SizedBox(height: spacing.base),
        ],
        Semantics(
          header: true,
          child: Text(
            breed.name,
            style: context.typography.display.lg.copyWith(
              color: colors.foreground,
            ),
          ),
        ),
        if (breed.description.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          Text(
            breed.description,
            style: context.typography.system.body.copyWith(
              color: colors.foregroundMuted,
            ),
          ),
        ],
        SizedBox(height: spacing.xl2),
        AppLabel(l10n.breedSheet),
        SizedBox(height: spacing.md),
        _StatsGrid(breed: breed),
        if (breed.temperament.isNotEmpty) ...[
          SizedBox(height: spacing.xl2),
          AppLabel(l10n.temperament),
          SizedBox(height: spacing.md),
          Wrap(
            spacing: spacing.base,
            runSpacing: spacing.base,
            children: [for (final t in breed.temperament) AppChip(label: t)],
          ),
        ],
        if (breed.history != null) ...[
          SizedBox(height: spacing.xl2),
          AppLabel(l10n.history),
          SizedBox(height: spacing.md),
          Text(
            breed.history!,
            style: context.typography.system.body.copyWith(
              color: colors.foregroundMuted,
            ),
          ),
        ],
        SizedBox(height: spacing.xl2),
        Divider(height: 1, color: colors.border),
        SizedBox(height: spacing.lg),
        AppLabel(l10n.source(breed.id.toUpperCase())),
      ],
    );
  }
}

/// Ficha 2×2: país de origen, inteligencia, adaptabilidad y esperanza de
/// vida (los cuatro datos que pide el enunciado).
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final gap = context.spacing.md;

    Widget row(Widget a, Widget b) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          SizedBox(width: gap),
          Expanded(child: b),
        ],
      ),
    );

    return Column(
      children: [
        row(
          StatTile.text(
            label: l10n.originLabel,
            value: breed.origin ?? l10n.unknownOrigin,
            caption: breed.countryCode == null
                ? null
                : l10n.countryCodeValue(breed.countryCode!),
          ),
          StatTile.rating(
            label: l10n.intelligenceLabel,
            rating: breed.intelligence,
          ),
        ),
        SizedBox(height: gap),
        row(
          StatTile.rating(
            label: l10n.adaptabilityLabel,
            rating: breed.adaptability,
          ),
          StatTile.text(
            label: l10n.lifeSpanLabel,
            value: breed.lifeSpan == null
                ? l10n.noData
                : l10n.lifeSpanValue(breed.lifeSpan!),
            caption: breed.weightKg == null
                ? null
                : l10n.weightValue(breed.weightKg!),
          ),
        ),
      ],
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.fromLTRB(spacing.lg, spacing.base, spacing.lg, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppShimmerBox(
              width: double.infinity,
              height: _photoHeight(context),
              radius: context.radius.xl2,
            ),
            SizedBox(height: spacing.xl),
            const AppShimmerBox(width: 120, height: 10),
            SizedBox(height: spacing.md),
            const AppShimmerBox(width: 200, height: 30),
            SizedBox(height: spacing.lg),
            const AppShimmerBox(width: double.infinity, height: 14),
            SizedBox(height: spacing.base),
            const AppShimmerBox(width: double.infinity, height: 14),
            SizedBox(height: spacing.base),
            const AppShimmerBox(width: 220, height: 14),
          ],
        ),
      ),
    );
  }
}
