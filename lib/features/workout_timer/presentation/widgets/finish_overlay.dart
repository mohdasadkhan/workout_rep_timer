library;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void showFinishOverlay(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Theme.of(context).colorScheme.surface.withOpacity(0.95),
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, __, ___) => const _FinishOverlay(),
    transitionBuilder: (ctx, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(opacity: curved, child: child);
    },
  ).then((_) {
    if (context.mounted) Navigator.of(context).pop();
  });
}

class _FinishOverlay extends StatefulWidget {
  const _FinishOverlay();

  @override
  State<_FinishOverlay> createState() => _FinishOverlayState();
}

class _FinishOverlayState extends State<_FinishOverlay>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late AnimationController _contentController;
  late Animation<double> _trophyScale;
  late Animation<double> _contentSlide;
  late String _quote;

  final List<String> _workoutQuotes = [
    "Every rep counts. Every session matters. 🔥",
    "Pain is temporary. Pride is forever. 💪",
    "You showed up. That's already a win. ⚡",
    "The body achieves what the mind believes. 🧠",
    "Sweat today. Stronger tomorrow. 🏋️",
    "Champions are built in sessions like this. 👑",
    "One more done. One step closer. 🚀",
    "You didn't quit. That's everything. 💯",
    "Discipline beats motivation every time. ⚔️",
    "Beast mode: activated. ✅",
  ];
  
  @override
  void initState() {
    super.initState();

    _quote = _workoutQuotes[Random().nextInt(_workoutQuotes.length)];

    _trophyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _trophyScale = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _trophyController, curve: Curves.elasticOut),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _trophyController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          const Positioned.fill(child: _ConfettiLayer()),
          Center(
            child: AnimatedBuilder(
              animation: _contentController,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, _contentSlide.value),
                child: Opacity(opacity: _contentController.value, child: child),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ScaleTransition(
                      scale: _trophyScale,
                      child: const Text(
                        '🎉',
                        style: TextStyle(
                          fontSize: 90,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Text(
                      'Workout Complete!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '"',
                            style: TextStyle(
                              fontSize: 40,
                              height: 0.5,
                              color: colorScheme.onSurface.withOpacity(0.3),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _quote,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                              height: 1.5,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = (progress - p.delay).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final x = (p.x + p.vx * t * 60) * size.width;
      final y =
          (p.y + p.vy * t * 60 + 0.5 * 0.0004 * t * t * 3600) * size.height;
      final alpha = (1 - (t * t)).clamp(0.0, 1.0);

      final paint = Paint()..color = p.color.withOpacity(alpha);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * 6);

      if (p.isRect) {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * 0.6,
          ),
          paint,
        );
      } else {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

class _Particle {
  double x, y, vx, vy, size, delay;
  Color color;
  bool isRect;
  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.color,
    required this.isRect,
    required this.delay,
  });
}

class _ConfettiLayer extends StatefulWidget {
  const _ConfettiLayer();

  @override
  State<_ConfettiLayer> createState() => _ConfettiLayerState();
}

class _ConfettiLayerState extends State<_ConfettiLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_Particle> _particles = [];
  final Random _rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _controller.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Generate particles here instead of initState
    _generateParticles();
  }

  void _generateParticles() {
    final newParticles = <_Particle>[];
    
    // Get theme-aware colors - now safe to access Theme.of(context)
    final colorScheme = Theme.of(context).colorScheme;
    
    final List<Color> themeColors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
      colorScheme.primaryContainer,
      colorScheme.secondaryContainer,
      colorScheme.tertiaryContainer,
    ];
    
    // Add some vibrant accent colors that work in both themes
    final List<Color> vibrantColors = [
      const Color(0xFF4CAF50), // Green
      const Color(0xFFFFC107), // Amber
      const Color(0xFFFF5722), // Deep Orange
      const Color(0xFF2196F3), // Blue
      const Color(0xFF9C27B0), // Purple
    ];
    
    // Combine theme colors with vibrant accents for visual interest
    final allColors = [...themeColors, ...vibrantColors];

    for (int i = 0; i < 80; i++) {
      newParticles.add(
        _Particle(
          x: 0.5 + (_rng.nextDouble() - 0.5) * 0.4,
          y: 0.35,
          vx: (_rng.nextDouble() - 0.5) * 0.015,
          vy: -_rng.nextDouble() * 0.025 - 0.005,
          size: _rng.nextDouble() * 6 + 3,
          color: allColors[_rng.nextInt(allColors.length)],
          isRect: _rng.nextBool(),
          delay: _rng.nextDouble() * 0.3,
        ),
      );
    }
    
    setState(() {
      _particles = newParticles;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) {
      return const SizedBox.shrink(); // Return empty widget while generating
    }
    
    return CustomPaint(
      painter: _ConfettiPainter(
        particles: _particles,
        progress: _controller.value,
      ),
    );
  }
}