import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Brillo animado para placeholders de carga.
///
/// Regla (igual que en 121Pass): **un solo `AppShimmer` por vista**, que
/// envuelve todos sus [AppShimmerBox]. Hay un único `AnimationController` y
/// un único degradado del tamaño de la vista; cada bloque pinta solo su
/// porción, así todos brillan en fase como una sola onda y las superficies
/// que no son bloques (el fondo de la card) no se tiñen.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});

  final Widget child;

  static AppShimmerState? maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<AppShimmerState>();

  @override
  State<AppShimmer> createState() => AppShimmerState();
}

class AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController.unbounded(
    vsync: this,
  )..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1400));

  Listenable get animation => _controller;

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject()! as RenderBox).size;

  Offset offsetOf(RenderBox descendant) {
    final root = context.findRenderObject()! as RenderBox;
    return descendant.localToGlobal(Offset.zero, ancestor: root);
  }

  LinearGradient gradient(Color base, Color highlight) => LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [base, highlight, base],
    stops: const [0.1, 0.3, 0.5],
    transform: _SlideGradient(_controller.value),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * percent, 0, 0);
}

/// Bloque de placeholder. Se pinta con el degradado de su [AppShimmer];
/// sin uno, o con "reducir movimiento" activo, queda como bloque estático.
class AppShimmerBox extends StatefulWidget {
  const AppShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius,
  });

  final double? width;
  final double height;
  final double? radius;

  @override
  State<AppShimmerBox> createState() => _AppShimmerBoxState();
}

class _AppShimmerBoxState extends State<AppShimmerBox> {
  Listenable? _animation;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _animation?.removeListener(_onTick);
    _animation = MediaQuery.disableAnimationsOf(context)
        ? null
        : AppShimmer.maybeOf(context)?.animation;
    _animation?.addListener(_onTick);
  }

  @override
  void dispose() {
    _animation?.removeListener(_onTick);
    super.dispose();
  }

  void _onTick() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final block = Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: colors.sunken,
        borderRadius: BorderRadius.circular(widget.radius ?? context.radius.xs),
      ),
    );

    final shimmer = AppShimmer.maybeOf(context);
    final box = context.findRenderObject() as RenderBox?;
    if (_animation == null ||
        shimmer == null ||
        !shimmer.isSized ||
        box == null ||
        !box.hasSize) {
      return block;
    }

    final offset = shimmer.offsetOf(box);
    final full = shimmer.size;
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (_) => shimmer
          .gradient(colors.sunken, colors.surface)
          .createShader(
            Rect.fromLTWH(-offset.dx, -offset.dy, full.width, full.height),
          ),
      child: block,
    );
  }
}
