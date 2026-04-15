import 'dart:math';
import 'package:flutter/material.dart';

class CelebrationOverlay extends StatefulWidget {
  final String goalName;
  final VoidCallback onDismiss;

  const CelebrationOverlay({
    super.key,
    required this.goalName,
    required this.onDismiss,
  });

  static void show(BuildContext context, String goalName) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => CelebrationOverlay(
        goalName: goalName,
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;
  late AnimationController _confettiController;
  late Animation<double> _bgFade;
  late Animation<double> _contentScale;
  late Animation<double> _contentFade;

  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 60; i++) {
      _particles.add(_ConfettiParticle(random: _random));
    }

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _bgFade = CurvedAnimation(parent: _bgController, curve: Curves.easeIn);

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _contentScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutBack),
    );
    _contentFade =
        CurvedAnimation(parent: _contentController, curve: Curves.easeIn);

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _bgController.forward();
    _contentController.forward();
    _confettiController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() {
    _bgController.reverse().then((_) => widget.onDismiss());
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: _dismiss,
      child: FadeTransition(
        opacity: _bgFade,
        child: Stack(
          children: [
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              width: double.infinity,
              height: double.infinity,
            ),
            AnimatedBuilder(
              animation: _confettiController,
              builder: (_, __) {
                return CustomPaint(
                  painter: _ConfettiPainter(
                    particles: _particles,
                    progress: _confettiController.value,
                    screenSize: size,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
            Center(
              child: FadeTransition(
                opacity: _contentFade,
                child: ScaleTransition(
                  scale: _contentScale,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.1),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          builder: (_, scale, child) =>
                              Transform.scale(scale: scale, child: child),
                          child: const Text(
                            '🏆',
                            style: TextStyle(fontSize: 64),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Meta atingida!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B4332),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Parabéns! Você concluiu\n"${widget.goalName}"',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _dismiss,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(180, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text('Continuar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfettiParticle {
  late double x;
  late double y;
  late double size;
  late Color color;
  late double speed;
  late double angle;
  late double rotation;
  late double rotationSpeed;

  static const _colors = [
    Color(0xFFF4A261),
    Color(0xFF52B788),
    Color(0xFF1B6CA8),
    Color(0xFFE63946),
    Color(0xFF9B5DE5),
    Color(0xFFFFB703),
  ];

  _ConfettiParticle({required Random random}) {
    x = random.nextDouble();
    y = -random.nextDouble() * 0.5;
    size = 6 + random.nextDouble() * 8;
    color = _colors[random.nextInt(_colors.length)];
    speed = 0.3 + random.nextDouble() * 0.5;
    angle = (random.nextDouble() - 0.5) * 0.8;
    rotation = random.nextDouble() * 2 * pi;
    rotationSpeed = (random.nextDouble() - 0.5) * 0.2;
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;
  final Size screenSize;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final currentY = (p.y + progress * p.speed) % 1.2;
      final currentX = p.x + sin(progress * 3 + p.angle) * 0.05;
      final currentRotation = p.rotation + progress * p.rotationSpeed * 10;

      if (currentY < 0) continue;

      final cx = currentX * size.width;
      final cy = currentY * size.height;

      canvas.save();
      canvas.translate(cx, cy);
      canvas.rotate(currentRotation);

      final paint = Paint()
        ..color = p.color.withValues(alpha: 1 - progress * 0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.5),
          const Radius.circular(2),
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
