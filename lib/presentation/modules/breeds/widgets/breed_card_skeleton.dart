import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:catbreeds/presentation/modules/breeds/widgets/breed_card.dart';
import 'package:flutter/material.dart';

/// Esqueleto de [BreedCard]: mismo contorno y proporciones, para que la
/// lista no salte al llegar los datos.
///
/// No incluye su propio [AppShimmer]: lo pone la vista una sola vez.
class BreedCardSkeleton extends StatelessWidget {
  const BreedCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final s = context.spacing;
    return Container(
      padding: EdgeInsets.all(s.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.radius.xl),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(s.base, s.base, 0, s.lg),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppShimmerBox(width: 160, height: 20),
                      SizedBox(height: s.base),
                      const AppShimmerBox(width: 84, height: 10),
                    ],
                  ),
                ),
                AppShimmerBox(
                  width: 58,
                  height: 28,
                  radius: context.radius.full,
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: BreedCard.photoAspectRatio,
            child: AppShimmerBox(
              height: double.infinity,
              radius: context.radius.md,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(s.base, s.lg, s.base, s.base),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppShimmerBox(width: 90, height: 10),
                      SizedBox(height: s.base),
                      const AppShimmerBox(width: 120, height: 18),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const AppShimmerBox(width: 80, height: 10),
                    SizedBox(height: s.base),
                    const AppShimmerBox(width: 106, height: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
