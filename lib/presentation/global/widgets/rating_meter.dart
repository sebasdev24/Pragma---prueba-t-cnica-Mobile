import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Escala 1–5 en pastillas. Con `value == null` muestra "Sin dato":
/// hoy la API no devuelve `intelligence` ni `adaptability`.
class RatingMeter extends StatelessWidget {
  const RatingMeter({
    super.key,
    required this.value,
    required this.label,
    this.showScore = true,
  });

  final int? value;

  /// Para lectores de pantalla ("Inteligencia: 4 de 5").
  final String label;
  final bool showScore;

  static const _max = 5;
  static const _pipSize = Size(14, 6);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final v = value;
    final pips = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.spacing.sm,
      children: [
        for (var i = 1; i <= _max; i++)
          Container(
            width: _pipSize.width,
            height: _pipSize.height,
            decoration: BoxDecoration(
              color: v != null && i <= v ? colors.accent : colors.borderStrong,
              borderRadius: BorderRadius.circular(context.radius.full),
            ),
          ),
      ],
    );

    final score = v == null ? context.l10n.noData : context.l10n.ratingValue(v);
    final semantics = v == null
        ? '$label: ${context.l10n.noData}'
        : context.l10n.ratingSemantics(label, v);

    return Semantics(
      label: semantics,
      excludeSemantics: true,
      // Wrap y no Row: en tiles angostos o con texto grande (accesibilidad)
      // el puntaje baja de línea en vez de desbordarse.
      child: Wrap(
        spacing: context.spacing.base,
        runSpacing: context.spacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Opacity(opacity: v == null ? 0.5 : 1, child: pips),
          if (showScore || v == null)
            Text(
              score,
              style: context.typography.system.caption.copyWith(
                color: v == null
                    ? colors.foregroundSubtle
                    : colors.foregroundMuted,
              ),
            ),
        ],
      ),
    );
  }
}
