import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Una etiqueta con borde que no se puede tocar.
class AppChip extends StatelessWidget {
  const AppChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.md,
        vertical: context.spacing.base - context.spacing.sx,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.radius.full),
        border: Border.all(color: colors.borderStrong),
      ),
      child: Text(
        label,
        style: context.typography.system.caption.copyWith(
          color: colors.foreground,
        ),
      ),
    );
  }
}
