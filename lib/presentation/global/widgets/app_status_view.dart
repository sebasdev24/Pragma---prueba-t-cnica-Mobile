import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/presentation/global/widgets/app_buttons.dart';
import 'package:catbreeds/presentation/global/widgets/cat_mark.dart';
import 'package:flutter/material.dart';

enum AppStatusTone { neutral, error }

/// Lo que se muestra cuando no hay nada o algo falló: la silueta, un
/// título, un texto y un botón. La misma pieza sirve para "sin resultados"
/// y para "sin conexión".
class AppStatusView extends StatelessWidget {
  const AppStatusView({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.tone = AppStatusTone.neutral,
  });

  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final AppStatusTone tone;

  static const _badgeSize = 96.0;
  static const _markSize = 52.0;
  static const _maxTextWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isError = tone == AppStatusTone.error;
    final badgeBg = isError ? colors.dangerSoft : colors.accentSoft;
    final badgeFg = isError ? colors.danger : colors.accent;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.spacing.xl,
        vertical: context.spacing.safe,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _badgeSize,
            height: _badgeSize,
            decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: CatMark(size: _markSize, color: badgeFg, eyeColor: badgeBg),
          ),
          SizedBox(height: context.spacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.typography.display.md.copyWith(
              color: colors.foreground,
            ),
          ),
          SizedBox(height: context.spacing.md),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _maxTextWidth),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: context.typography.system.body.copyWith(
                color: colors.foregroundMuted,
              ),
            ),
          ),
          SizedBox(height: context.spacing.xl),
          if (isError)
            AppPrimaryButton(
              label: actionLabel,
              icon: Icons.refresh_rounded,
              onPressed: onAction,
            )
          else
            AppOutlinedButton(label: actionLabel, onPressed: onAction),
        ],
      ),
    );
  }
}
