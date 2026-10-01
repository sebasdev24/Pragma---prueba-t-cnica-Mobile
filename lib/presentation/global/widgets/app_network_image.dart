import 'package:cached_network_image/cached_network_image.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/presentation/global/widgets/cat_mark.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Una foto de internet con caché en disco, un loader mientras baja y la
/// silueta de la marca si no hay foto o falla.
///
/// Las fotos de The Cat API son pesadas (de 1 a 6 MB y hasta 4000 px). Por
/// eso las decodificamos al tamaño en que se ven (`memCacheWidth`); si no,
/// cada card podría ocupar unos 50 MB de memoria.
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

  /// Texto que va debajo de la silueta cuando no hay foto.
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
            // Como las fotos pesan varios MB, si el servidor dice el tamaño
            // mostramos cuánto va de la descarga.
            progressIndicatorBuilder: (_, _, progress) =>
                _Loader(progress: progress.progress),
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

/// El loader de cada plataforma.
class _Loader extends StatelessWidget {
  const _Loader({this.progress});

  /// De 0 a 1, o `null` mientras no sepamos cuánto pesa la foto.
  final double? progress;

  static const _size = 28.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.sunken,
      child: Center(
        child: SizedBox.square(
          dimension: _size,
          child: context.isCupertino
              ? const CupertinoActivityIndicator()
              : CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2.5,
                  strokeCap: StrokeCap.round,
                  color: colors.accent,
                  backgroundColor: colors.borderStrong,
                ),
        ),
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
