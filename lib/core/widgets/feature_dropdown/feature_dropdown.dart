import 'package:app_lifecycle/core/theme/app_text_styles.dart';
import 'package:app_lifecycle/core/widgets/feature_dropdown/dropdown_overlay.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import 'extension_on_appfeature.dart';

class FeatureDropdownTitle extends StatefulWidget {
  final AppFeature current;

  const FeatureDropdownTitle({super.key, required this.current});

  @override
  State<FeatureDropdownTitle> createState() => _FeatureDropdownTitleState();
}

class _FeatureDropdownTitleState extends State<FeatureDropdownTitle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _chevronController;
  OverlayEntry? _overlay;

  @override
  void initState() {
    super.initState();
    _chevronController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _chevronController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _toggleDropdown(BuildContext context) {
    if (_overlay != null) {
      _chevronController.reverse();
      _removeOverlay();
      return;
    }

    _chevronController.forward();

    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => DropdownOverlay(
        anchorOffset: offset,
        anchorSize: size,
        currentFeature: widget.current,
        onSelect: (feature) {
          _chevronController.reverse();
          _removeOverlay();
          if (feature != widget.current) {
            context.go(feature.route);
          }
        },
        onDismiss: () {
          _chevronController.reverse();
          _removeOverlay();
        },
      ),
    );

    Overlay.of(context).insert(_overlay!);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _toggleDropdown(context),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.current.icon, color: AppColors.primary, size: 26),
            const SizedBox(width: 10),
            Text(
              widget.current.label,
              style: AppTextStyles.titleLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            RotationTransition(
              turns: Tween<double>(
                begin: 0.0,
                end: 0.5,
              ).animate(_chevronController),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textTertiary,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
