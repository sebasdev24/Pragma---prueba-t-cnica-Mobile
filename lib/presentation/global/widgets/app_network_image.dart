import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/presentation/global/widgets/cat_mark.dart';
import 'package:flutter/material.dart';

/// Imagen remota con caché en disco, placeholder y fallback de marca.
///
/// Las fotos de The Cat API son originales de 1–6 MB y hasta 4000 px.
/// Se decodifican al ancho real en pantalla (`memCacheWidth`) para no
/// cargar bitmaps de 50 MB en memoria por cada card.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.borderRadius,
    this.semanticLabel,
    this.fallbackLabel,
  });

  final String? url;
  final BorderRadius? borderRadius;
  final String? semanticLabel;

  /// Texto bajo la silueta cuando no hay foto.
  final String? fallbackLabel;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(context.radius.md);
    return ClipRRect(
      borderRadius: radius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final src = url;
          if (src == null || src.isEmpty) {
            return _Fallback(label: fallbackLabel);
          }
          final dpr = MediaQuery.devicePixelRatioOf(context);
          final width = constraints.maxWidth.isFinite
              ? (constraints.maxWidth * dpr).round()
              : null;
          return CachedNetworkImage(
            imageUrl: src,
            fit: BoxFit.cover,
            memCacheWidth: width,
            fadeInDuration: const Duration(milliseconds: 220),
            placeholder: (_, _) => ColoredBox(color: context.colors.sunken),
            errorWidget: (_, _, _) => _Fallback(label: fallbackLabel),
            imageBuilder: (context, provider) => Semantics(
              image: true,
              label: semanticLabel,
              child: Image(image: provider, fit: BoxFit.cover),
            ),
          );
        },
      ),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.sunken,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.35,
              child: CatMark(size: 56, color: colors.foregroundSubtle),
            ),
            if (label != null) ...[
              SizedBox(height: context.spacing.base),
              Text(
                label!,
                style: context.typography.system.caption.copyWith(
                  color: colors.foregroundSubtle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
