import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Los rótulos pequeños en Geist Mono con letras separadas (Mono/Label en
/// el Figma). El texto tiene que llegar ya en mayúsculas.
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
