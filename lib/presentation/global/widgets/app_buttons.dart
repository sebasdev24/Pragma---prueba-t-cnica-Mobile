import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// El botón principal, la pastilla terracota. Lo usamos para acciones como
/// "Retry".
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? null : Icon(icon, size: 18),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
        textStyle: context.typography.system.callout,
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.xl,
          vertical: context.spacing.md,
        ),
        shape: const StadiumBorder(),
      ),
    );
  }
}

/// Botón secundario, solo con borde, para acciones como "Clear search".
class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.foreground,
        backgroundColor: colors.surface,
        side: BorderSide(color: colors.borderStrong),
        textStyle: context.typography.system.callout,
        padding: EdgeInsets.symmetric(
          horizontal: context.spacing.xl,
          vertical: context.spacing.md,
        ),
        shape: const StadiumBorder(),
      ),
      child: Text(label),
    );
  }
}

/// La pastilla pequeña con flecha. Es el "More" de cada card.
class AppPillButton extends StatelessWidget {
  const AppPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      excludeSemantics: true,
      child: Material(
        color: colors.accentSoft,
        shape: const StadiumBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.spacing.md,
              context.spacing.base - context.spacing.sx,
              context.spacing.base,
              context.spacing.base - context.spacing.sx,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: context.spacing.sx,
              children: [
                Text(
                  label,
                  style: context.typography.system.caption.copyWith(
                    color: colors.accent,
                  ),
                ),
                Icon(Icons.north_east_rounded, size: 14, color: colors.accent),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
