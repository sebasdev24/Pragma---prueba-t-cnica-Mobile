import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/presentation/global/widgets/app_label.dart';
import 'package:catbreeds/presentation/global/widgets/rating_meter.dart';
import 'package:flutter/material.dart';

/// Tile de la ficha del detalle. Dos variantes, como en Figma:
/// texto ([StatTile.text]) o escala 1–5 ([StatTile.rating]).
class StatTile extends StatelessWidget {
  const StatTile.text({
    super.key,
    required this.label,
    required String this.value,
    this.caption,
  }) : rating = null,
       _isRating = false;

  const StatTile.rating({super.key, required this.label, required this.rating})
    : value = null,
      caption = null,
      _isRating = true;

  final String label;
  final String? value;
  final String? caption;
  final int? rating;
  final bool _isRating;

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
          if (_isRating) ..._rating(context) else ..._text(context),
        ],
      ),
    );
  }

  List<Widget> _text(BuildContext context) {
    final colors = context.colors;
    return [
      Text(
        value!,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: context.typography.system.headline.copyWith(
          color: colors.foreground,
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
    ];
  }

  List<Widget> _rating(BuildContext context) {
    final colors = context.colors;
    final r = rating;
    return [
      ExcludeSemantics(
        child: Text(
          r?.toString() ?? '—',
          style: context.typography.display.lg.copyWith(
            color: r == null ? colors.foregroundSubtle : colors.foreground,
          ),
        ),
      ),
      SizedBox(height: context.spacing.base),
      RatingMeter(value: r, label: label, showScore: false),
    ];
  }
}
