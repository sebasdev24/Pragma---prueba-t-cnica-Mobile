import 'package:catbreeds/core/constants/app_strings.dart';
import 'package:catbreeds/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// El buscador, con el control que cada plataforma usa: en iOS
/// el `CupertinoSearchTextField` y en Android un `TextField` de Material.
/// Los dos usan los mismos colores.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  /// Se llama cuando se borra el texto o se toca "Cancel".
  final VoidCallback onClear;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_rebuild);
    widget.controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _focus.removeListener(_rebuild);
    widget.controller.removeListener(_rebuild);
    _focus.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _clear() {
    widget.controller.clear();
    widget.onClear();
  }

  void _cancel() {
    _clear();
    _focus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return context.isCupertino
        ? _buildCupertino(context)
        : _buildMaterial(context);
  }

  Widget _buildCupertino(BuildContext context) {
    final colors = context.colors;
    final showCancel = _focus.hasFocus || widget.controller.text.isNotEmpty;
    return Row(
      children: [
        Expanded(
          child: CupertinoSearchTextField(
            controller: widget.controller,
            focusNode: _focus,
            placeholder: AppStrings.searchHint,
            onChanged: widget.onChanged,
            onSuffixTap: _clear,
            autocorrect: false,
            style: context.typography.system.body.copyWith(
              color: colors.foreground,
            ),
            placeholderStyle: context.typography.system.body.copyWith(
              color: colors.foregroundSubtle,
            ),
            backgroundColor: colors.sunken,
            itemColor: colors.foregroundSubtle,
            borderRadius: BorderRadius.circular(context.radius.md),
            padding: EdgeInsets.symmetric(
              horizontal: context.spacing.base,
              vertical: context.spacing.md,
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: showCancel
              ? CupertinoButton(
                  padding: EdgeInsets.only(left: context.spacing.md),
                  minimumSize: Size.zero,
                  onPressed: _cancel,
                  child: Text(
                    AppStrings.searchCancel,
                    style: context.typography.system.body.copyWith(
                      color: colors.accent,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildMaterial(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(context.radius.md);
    final hasText = widget.controller.text.isNotEmpty;
    return TextField(
      controller: widget.controller,
      focusNode: _focus,
      onChanged: widget.onChanged,
      autocorrect: false,
      textInputAction: TextInputAction.search,
      style: context.typography.system.body.copyWith(color: colors.foreground),
      decoration: InputDecoration(
        hintText: AppStrings.searchHint,
        hintStyle: context.typography.system.body.copyWith(
          color: colors.foregroundSubtle,
        ),
        filled: true,
        fillColor: _focus.hasFocus ? colors.surface : colors.sunken,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: context.spacing.md),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: _focus.hasFocus ? colors.accent : colors.foregroundSubtle,
        ),
        suffixIcon: hasText
            ? IconButton(
                tooltip: AppStrings.searchClear,
                icon: Icon(
                  Icons.cancel_rounded,
                  color: colors.foregroundSubtle,
                ),
                onPressed: _clear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
      ),
    );
  }
}
