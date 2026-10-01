import 'package:catbreeds/core/constants/app_images.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// La silueta del gato de la marca, pintada con [color]. Con [eyeColor]
/// también lleva ojos (como en la splash); en tamaños pequeños no hacen
/// falta.
class CatMark extends StatelessWidget {
  const CatMark({
    super.key,
    required this.size,
    required this.color,
    this.eyeColor,
  });

  final double size;
  final Color color;
  final Color? eyeColor;

  @override
  Widget build(BuildContext context) {
    final silhouette = SvgPicture.asset(
      AppImages.catMark,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
    final eyes = eyeColor;
    if (eyes == null) return ExcludeSemantics(child: silhouette);

    // Dónde van los ojos dentro del SVG, que mide 120×120.
    final s = size / 120;
    Widget eye(double cx) => Positioned(
      left: (cx - 3) * s,
      top: 38 * s,
      child: Container(
        width: 6 * s,
        height: 8.5 * s,
        decoration: BoxDecoration(
          color: eyes,
          borderRadius: BorderRadius.all(Radius.elliptical(3 * s, 4.25 * s)),
        ),
      ),
    );

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: Stack(children: [silhouette, eye(51.5), eye(68.5)]),
      ),
    );
  }
}
