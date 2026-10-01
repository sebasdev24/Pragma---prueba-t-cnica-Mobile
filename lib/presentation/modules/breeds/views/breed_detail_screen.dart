import 'package:catbreeds/core/constants/app_strings.dart';
import 'dart:math' as math;

import 'package:catbreeds/core/errors/failure.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breed_detail_provider.dart';
import 'package:catbreeds/presentation/modules/breeds/widgets/breed_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// El detalle de una raza.
///
/// El enunciado pide que la foto se quede quieta y que solo la información
/// haga scroll. Por eso la foto va por fuera del scroll y el `Scrollbar`
/// envuelve únicamente la ficha.
class BreedDetailScreen extends ConsumerWidget {
  const BreedDetailScreen({super.key, required this.breedId});

  final String breedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(breedDetailProvider(breedId));

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
              title: AppStrings.detailErrorTitle,
              message: error is Failure
                  ? error.userMessage
                  : const UnknownFailure('').userMessage,
              actionLabel: AppStrings.retry,
              onAction: () => ref.invalidate(breedDetailProvider(breedId)),
            ),
          ),
        ),
      ),
    );
  }
}

/// La foto ocupa más o menos un tercio de la pantalla, con un tope para que
/// en tablets no quede gigante.
double _photoHeight(BuildContext context) =>
    math.min(MediaQuery.sizeOf(context).height * 0.36, 360);

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

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
                semanticLabel: AppStrings.photoOf(breed.name),
                fallbackLabel: AppStrings.noPhoto,
              ),
            ),
          ),
        ),
        Expanded(
          child: _TopFade(
            height: spacing.safe,
            child: Scrollbar(
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
          ),
        ),
      ],
    );
  }
}

/// Desvanece el texto a medida que sube y se mete debajo de la foto. Sin
/// scroll no hay fade, así el título se ve completo al abrir el detalle; el
/// efecto entra de a poco durante los primeros píxeles de desplazamiento.
class _TopFade extends StatefulWidget {
  const _TopFade({required this.height, required this.child});

  /// Alto de la franja que se desvanece.
  final double height;
  final Widget child;

  @override
  State<_TopFade> createState() => _TopFadeState();
}

class _TopFadeState extends State<_TopFade> {
  /// 0 sin scroll, 1 cuando ya se desplazó el alto de la franja.
  final _progress = ValueNotifier<double>(0);

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification n) {
    if (n.depth == 0 && n.metrics.axis == Axis.vertical) {
      _progress.value = (n.metrics.pixels / widget.height).clamp(0.0, 1.0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: ValueListenableBuilder<double>(
        valueListenable: _progress,
        child: widget.child,
        // Siempre con ShaderMask: si se quitara al volver arriba, el árbol
        // cambiaría y el scroll perdería su posición.
        builder: (context, progress, child) {
          return ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (bounds) {
              final stop = (widget.height / bounds.height).clamp(0.0, 1.0);
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 1 - progress),
                  Colors.black,
                ],
                stops: [0, stop],
              ).createShader(bounds);
            },
            child: child,
          );
        },
      ),
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

    final eyebrow = breed.breedGroup?.toUpperCase() ?? '';

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
        AppLabel(AppStrings.breedSheet),
        SizedBox(height: spacing.md),
        _StatsGrid(breed: breed),
        if (breed.temperament.isNotEmpty) ...[
          SizedBox(height: spacing.xl2),
          AppLabel(AppStrings.temperament),
          SizedBox(height: spacing.md),
          Wrap(
            spacing: spacing.base,
            runSpacing: spacing.base,
            children: [for (final t in breed.temperament) AppChip(label: t)],
          ),
        ],
        if (breed.history != null) ...[
          SizedBox(height: spacing.xl2),
          AppLabel(AppStrings.history),
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
        AppLabel(AppStrings.source(breed.id.toUpperCase())),
      ],
    );
  }
}

/// La ficha de 2×2: origen, peso, altura y esperanza de vida.
///
/// El enunciado pedía inteligencia y adaptabilidad, pero The Cat API ya no
/// los manda en ningún endpoint. Peso y altura sí vienen en todas las
/// razas, en kilos y libras, y en centímetros y pulgadas.
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
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
          StatTile(
            label: AppStrings.originLabel,
            value: breed.origin ?? AppStrings.unknownOrigin,
            caption: breed.countryCode == null
                ? null
                : AppStrings.countryCodeValue(breed.countryCode!),
          ),
          StatTile(
            label: AppStrings.weightLabel,
            value: _or(breed.weightKg, AppStrings.kilograms),
            caption: _optional(breed.weightLb, AppStrings.pounds),
          ),
        ),
        SizedBox(height: gap),
        row(
          StatTile(
            label: AppStrings.heightLabel,
            value: _or(breed.heightCm, AppStrings.centimeters),
            caption: _optional(breed.heightIn, AppStrings.inches),
          ),
          StatTile(
            label: AppStrings.lifeSpanLabel,
            value: _or(breed.lifeSpan, AppStrings.lifeSpanValue),
          ),
        ),
      ],
    );
  }
}

/// El rango con su unidad, o "No data" si no vino.
String _or(String? range, String Function(String) unit) =>
    range == null ? AppStrings.noData : unit(range);

String? _optional(String? range, String Function(String) unit) =>
    range == null ? null : unit(range);

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
