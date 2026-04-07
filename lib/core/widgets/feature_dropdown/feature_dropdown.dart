import 'package:app_lifecycle/core/theme/app_colors.dart';
import 'package:app_lifecycle/core/widgets/feature_dropdown/extension_on_appfeature.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeatureDropdownTitle extends StatefulWidget {
  final AppFeature current;
  const FeatureDropdownTitle({super.key, required this.current});

  @override
  State<FeatureDropdownTitle> createState() => _FeatureDropdownTitleState();
}

class _FeatureDropdownTitleState extends State<FeatureDropdownTitle>
    with SingleTickerProviderStateMixin {
  late AnimationController _chevronController;
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

    // Get the RenderBox position of the button
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => _DropdownOverlay(
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.current.label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 0.5).animate(_chevronController),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _DropdownOverlay extends StatelessWidget {
  final Offset anchorOffset;
  final Size anchorSize;
  final AppFeature currentFeature;
  final ValueChanged<AppFeature> onSelect;
  final VoidCallback onDismiss;

  const _DropdownOverlay({
    required this.anchorOffset,
    required this.anchorSize,
    required this.currentFeature,
    required this.onSelect,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Dismiss tap area
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        // The actual dropdown card
        Positioned(
          top: anchorOffset.dy + anchorSize.height + 8,
          left: anchorOffset.dx,
          child: Material(
            color: Colors.transparent,
            // In _DropdownOverlay, wrap the dropdown card:
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.9 + (0.1 * value), // 0.9 → 1.0
                    alignment: Alignment.topLeft, // grows from top-left corner
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: AppFeature.values.map((feature) {
                    final isSelected = feature == currentFeature;
                    return _DropdownItem(
                      feature: feature,
                      isSelected: isSelected,
                      onTap: () => onSelect(feature),
                      showDivider: feature != AppFeature.values.last,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final AppFeature feature;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDivider;

  const _DropdownItem({
    required this.feature,
    required this.isSelected,
    required this.onTap,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(feature.icon, color: Colors.white70, size: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    feature.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: AppColors.primary, size: 20),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Colors.white.withOpacity(0.08),
          ),
      ],
    );
  }
}
