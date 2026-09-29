import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/domain/entities/breed.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// Card de la lista (Figma: "Breed Card"). Nombre + "Más", foto, país de
/// origen e inteligencia. Toda la card navega al detalle; "Más" es el
/// atajo visible que pide el wireframe.
class BreedCard extends StatelessWidget {
  const BreedCard({super.key, required this.breed, required this.onTap});

  final Breed breed;
  final VoidCallback onTap;

  /// Proporción de la foto en el diseño (337 × 236).
  static const photoAspectRatio = 337 / 236;

  static String heroTag(String id) => 'breed-photo-$id';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
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
                      label: l10n.more,
                      semanticLabel: l10n.moreAbout(breed.name),
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
                    semanticLabel: l10n.photoOf(breed.name),
                    fallbackLabel: l10n.noPhoto,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppLabel(l10n.intelligenceLabel),
                        SizedBox(height: context.spacing.md),
                        RatingMeter(
                          value: breed.intelligence,
                          label: l10n.intelligenceLabel,
                        ),
                      ],
                    ),
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
        AppLabel(context.l10n.originLabel),
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
                breed.origin ?? context.l10n.unknownOrigin,
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
