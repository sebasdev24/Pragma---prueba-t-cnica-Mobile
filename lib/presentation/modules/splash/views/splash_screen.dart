import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/core/router/app_routes.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breeds_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Splash: continúa el splash nativo (mismo color y silueta) y aprovecha
/// para pedir la primera página. Así la lista abre con datos, no con
/// skeletons.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  /// Tiempo mínimo en pantalla para que la animación de entrada se lea.
  static const minDuration = Duration(milliseconds: 1400);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  @override
  void initState() {
    super.initState();
    // Tras el primer frame: Riverpod no permite modificar un provider
    // mientras se construye el árbol (initState incluido).
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmUpAndContinue());
  }

  Future<void> _warmUpAndContinue() async {
    // Un error aquí no bloquea: la lista mostrará su propio estado de error.
    await Future.wait([
      Future<void>.delayed(SplashScreen.minDuration),
      ref.read(breedsListProvider.notifier).loadFirstPage(),
    ]);
    if (mounted) context.go(AppRoutes.breeds);
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  /// Mismo tamaño que la silueta del splash nativo, para que el relevo
  /// entre ambos no salte.
  static const _markSize = 132.0;
  static const _titleSize = 52.0;
  static const _progressWidth = 96.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final fade = CurvedAnimation(parent: _intro, curve: Curves.easeOutCubic);
    final rise = Tween(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(fade);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: colors.accent,
        // Sin SafeArea a propósito: el splash nativo centra la silueta en
        // la ventana completa y aquí debe quedar en el mismo punto.
        body: LayoutBuilder(
          builder: (context, constraints) {
            final center = constraints.maxHeight / 2;
            return Stack(
              children: [
                Center(
                  child: CatMark(
                    size: _markSize,
                    color: colors.onAccent,
                    eyeColor: colors.accent,
                  ),
                ),
                Positioned(
                  top: center + _markSize / 2 + spacing.lg,
                  left: spacing.lg,
                  right: spacing.lg,
                  child: FadeTransition(
                    opacity: fade,
                    child: SlideTransition(
                      position: rise,
                      child: Column(
                        children: [
                          Text(
                            context.l10n.appTitle,
                            textAlign: TextAlign.center,
                            style: context.typography.display.xl.copyWith(
                              color: colors.onAccent,
                              fontSize: _titleSize,
                            ),
                          ),
                          SizedBox(height: spacing.base),
                          Text(
                            context.l10n.splashTagline,
                            textAlign: TextAlign.center,
                            style: context.typography.display.italic.copyWith(
                              color: colors.onAccent.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: bottomInset + spacing.xl2,
                  child: FadeTransition(
                    opacity: fade,
                    child: Column(
                      children: [
                        SizedBox(
                          width: _progressWidth,
                          child: LinearProgressIndicator(
                            minHeight: 3,
                            borderRadius: BorderRadius.circular(
                              context.radius.full,
                            ),
                            color: colors.onAccent,
                            backgroundColor: colors.onAccent.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),
                        SizedBox(height: spacing.lg),
                        AppLabel(
                          context.l10n.splashCredit,
                          color: colors.onAccent.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
