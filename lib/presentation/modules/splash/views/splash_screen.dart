import 'package:catbreeds/core/constants/app_strings.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:catbreeds/core/router/app_routes.dart';
import 'package:catbreeds/presentation/global/widgets/widgets.dart';
import 'package:catbreeds/presentation/modules/breeds/providers/breeds_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// La splash de Flutter. Arranca igual que la nativa (mismo color y misma
/// silueta) y, mientras se ve, pide la primera página. Así la lista ya abre
/// con datos y no con placeholders.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  /// Lo mínimo que se queda en pantalla, para que alcance a verse la
  /// animación.
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
    // Esperamos al primer frame porque Riverpod no deja modificar un
    // provider mientras se está construyendo el árbol.
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmUpAndContinue());
  }

  Future<void> _warmUpAndContinue() async {
    // Si la carga falla, igual seguimos; la lista ya sabe mostrar el error.
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

  /// Igual que en la splash nativa, para que no se note el cambio de una a
  /// otra.
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
        // Sin SafeArea a propósito. La splash nativa centra la silueta en
        // toda la ventana y aquí tiene que caer exactamente en el mismo
        // punto.
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
                            AppStrings.appTitle,
                            textAlign: TextAlign.center,
                            style: context.typography.display.xl.copyWith(
                              color: colors.onAccent,
                              fontSize: _titleSize,
                            ),
                          ),
                          SizedBox(height: spacing.base),
                          Text(
                            AppStrings.splashTagline,
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
                          AppStrings.splashCredit,
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
