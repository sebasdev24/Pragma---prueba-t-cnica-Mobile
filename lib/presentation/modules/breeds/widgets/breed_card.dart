import 'package:catbreeds/core/constants/app_strings.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// La card de cada raza (la "Breed Card" del Figma): nombre, botón "More",
/// foto, país de origen y peso. Se puede tocar toda la card; el "More" está
/// porque el wireframe lo pide.
///
/// El wireframe mostraba la inteligencia, pero la API ya no la manda, así
/// que en su lugar va el peso, que sí viene en todas las razas.
class BreedCard extends StatelessWidget {
  const BreedCard({super.key, required this.breed, required this.onTap});

  final Breed breed;
  final VoidCallback onTap;

  /// La foto mantiene la proporción del diseño (337 × 236).
  static const photoAspectRatio = 337 / 236;

  static String heroTag(String id) => 'breed-photo-$id';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(context.radius.xl);

    return Material(
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(context.spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.spacing.base - context.spacing.sx,
                  context.spacing.sm,
                  0,
                  context.spacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            breed.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.typography.display.md.copyWith(
                              color: colors.foreground,
                            ),
                          ),
                          if (breed.breedGroup != null) ...[
                            SizedBox(height: context.spacing.sx),
                            AppLabel(breed.breedGroup!.toUpperCase()),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(width: context.spacing.base),
                    AppPillButton(
                      label: AppStrings.more,
                      semanticLabel: AppStrings.moreAbout(breed.name),
                      onPressed: onTap,
                    ),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: photoAspectRatio,
                child: Hero(
                  tag: heroTag(breed.id),
                  child: AppNetworkImage(
                    url: breed.imageUrl,
                    semanticLabel: AppStrings.photoOf(breed.name),
                    fallbackLabel: AppStrings.noPhoto,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.spacing.base - context.spacing.sx,
                  context.spacing.md + context.spacing.sx,
                  context.spacing.base - context.spacing.sx,
                  context.spacing.sm,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: _Origin(breed: breed)),
                    SizedBox(width: context.spacing.md),
                    _Weight(breed: breed),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Weight extends StatelessWidget {
  const _Weight({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final weight = breed.weightKg;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppLabel(AppStrings.weightLabel),
        SizedBox(height: context.spacing.base),
        Text(
          weight == null ? AppStrings.noData : AppStrings.kilograms(weight),
          style: context.typography.system.callout.copyWith(
            color: weight == null ? colors.foregroundSubtle : colors.foreground,
          ),
        ),
      ],
    );
  }
}

class _Origin extends StatelessWidget {
  const _Origin({required this.breed});

  final Breed breed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final code = breed.countryCode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabel(AppStrings.originLabel),
        SizedBox(height: context.spacing.base),
        Row(
          children: [
            if (code != null) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.spacing.base - context.spacing.sx,
                  vertical: context.spacing.sx + 1,
                ),
                decoration: BoxDecoration(
                  color: colors.sunken,
                  borderRadius: BorderRadius.circular(context.radius.xs),
                ),
                child: AppLabel(code, color: colors.foregroundMuted),
              ),
              SizedBox(width: context.spacing.base),
            ],
            Flexible(
              child: Text(
                breed.origin ?? AppStrings.unknownOrigin,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.system.callout.copyWith(
                  color: breed.origin == null
                      ? colors.foregroundSubtle
                      : colors.foreground,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
