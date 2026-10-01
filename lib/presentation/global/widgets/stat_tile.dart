import 'package:catbreeds/core/constants/app_strings.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/presentation/global/widgets/app_label.dart';
import 'package:flutter/material.dart';

/// Una casilla de la ficha del detalle: rótulo, valor y, si hace falta, una
/// línea abajo (por ejemplo, el mismo peso en libras).
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.caption,
  });

  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.all(context.spacing.lg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.radius.lg),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLabel(label),
          SizedBox(height: context.spacing.md),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.typography.system.headline.copyWith(
              color: value == AppStrings.noData
                  ? colors.foregroundSubtle
                  : colors.foreground,
              fontSize: 19,
            ),
          ),
          if (caption != null) ...[
            SizedBox(height: context.spacing.sm),
            Text(
              caption!,
              style: context.typography.system.caption.copyWith(
                color: colors.foregroundMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
