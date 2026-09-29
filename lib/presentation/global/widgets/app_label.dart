import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Rótulo en Geist Mono, mayúsculas y con tracking (Mono/Label en Figma).
/// El texto debe llegar ya en mayúsculas desde las traducciones.
class AppLabel extends StatelessWidget {
  const AppLabel(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.typography.mono.label.copyWith(
        color: color ?? context.colors.foregroundSubtle,
      ),
    );
  }
}
