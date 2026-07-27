import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Reusable Animated Weather Icon Widget.
/// Dynamically renders custom vector-animated icons for Sunny, Cloudy, Rain, Snow, Thunderstorm, Fog, and Default states.
class AnimatedWeatherIcon extends StatefulWidget {
  final String condition;
  final double size;

  const AnimatedWeatherIcon({
    super.key,
    required this.condition,
    this.size = 54.0,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Continuous smooth animation loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lower = widget.condition.toLowerCase();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (lower.contains('sun') || lower.contains('clear')) {
          return _buildSunnyAnimation();
        } else if (lower.contains('rain') || lower.contains('drizzle')) {
          return _buildRainAnimation();
        } else if (lower.contains('cloud')) {
          return _buildCloudyAnimation();
        } else if (lower.contains('snow') || lower.contains('ice')) {
          return _buildSnowAnimation();
        } else if (lower.contains('thunder') || lower.contains('storm')) {
          return _buildThunderstormAnimation();
        } else if (lower.contains('fog') || lower.contains('mist') || lower.contains('haze')) {
          return _buildFogAnimation();
        }
        // Default fallback for unknown conditions
        return _buildDefaultAnimation();
      },
    );
  }

  // 1. Sunny Animation: Rotating Golden Sun with Pulsing Rays
  Widget _buildSunnyAnimation() {
    final double angle = _controller.value * 2 * math.pi;
    final double pulse = 0.95 + 0.1 * math.sin(_controller.value * 2 * math.pi);

    return Transform.rotate(
      angle: angle,
      child: Transform.scale(
        scale: pulse,
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SunnyPainter(),
        ),
      ),
    );
  }

  // 2. Cloudy Animation: Floating Pulsing Cloud Layers
  Widget _buildCloudyAnimation() {
    final double offset = math.sin(_controller.value * 2 * math.pi) * 3;

    return Transform.translate(
      offset: Offset(offset, 0),
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _CloudyPainter(),
      ),
    );
  }

  // 3. Rain Animation: Falling Rain Droplets
  Widget _buildRainAnimation() {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _RainPainter(progress: _controller.value),
    );
  }

  // 4. Snow Animation: Drifting Falling Snowflakes
  Widget _buildSnowAnimation() {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _SnowPainter(progress: _controller.value),
    );
  }

  // 5. Thunderstorm Animation: Flashing Lightning Bolt
  Widget _buildThunderstormAnimation() {
    final double flash = (_controller.value * 4).floor() % 2 == 0 ? 1.0 : 0.4;

    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _ThunderstormPainter(flashOpacity: flash),
    );
  }

  // 6. Fog Animation: Floating Horizontal Fog Layers
  Widget _buildFogAnimation() {
    final double offset = math.sin(_controller.value * 2 * math.pi) * 5;

    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _FogPainter(offset: offset),
    );
  }

  // 7. Default Animation: Soft Pulsing Sun + Cloud
  Widget _buildDefaultAnimation() {
    final double scale = 0.95 + 0.08 * math.sin(_controller.value * 2 * math.pi);

    return Transform.scale(
      scale: scale,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _CloudyPainter(),
      ),
    );
  }
}

// Custom Vector Painters for High Performance Render

class _SunnyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.25;

    final sunPaint = Paint()
      ..color = const Color(0xFFFFD166)
      ..style = PaintingStyle.fill;

    final rayPaint = Paint()
      ..color = const Color(0xFFFFD166).withValues(alpha: 0.8)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Draw Sun Center Core
    canvas.drawCircle(center, radius, sunPaint);

    // Draw 8 Rotating Rays
    for (int i = 0; i < 8; i++) {
      final double angle = (i * math.pi / 4);
      final Offset rayStart = Offset(
        center.dx + (radius + 4) * math.cos(angle),
        center.dy + (radius + 4) * math.sin(angle),
      );
      final Offset rayEnd = Offset(
        center.dx + (radius + 10) * math.cos(angle),
        center.dy + (radius + 10) * math.sin(angle),
      );
      canvas.drawLine(rayStart, rayEnd, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _CloudyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;

    path.addOval(Rect.fromLTWH(w * 0.2, h * 0.35, w * 0.45, h * 0.45));
    path.addOval(Rect.fromLTWH(w * 0.45, h * 0.25, w * 0.4, h * 0.45));
    path.addOval(Rect.fromLTWH(w * 0.15, h * 0.45, w * 0.7, h * 0.35));

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _RainPainter extends CustomPainter {
  final double progress;
  _RainPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw cloud top
    final cloudPainter = _CloudyPainter();
    cloudPainter.paint(canvas, size);

    final rainPaint = Paint()
      ..color = const Color(0xFF60A5FA)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Draw 3 falling raindrops
    for (int i = 0; i < 3; i++) {
      final double x = w * (0.3 + i * 0.2);
      final double startY = h * 0.65 + ((progress + i * 0.33) % 1.0) * (h * 0.25);
      final double endY = startY + 6;

      canvas.drawLine(Offset(x, startY), Offset(x - 2, endY), rainPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _SnowPainter extends CustomPainter {
  final double progress;
  _SnowPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPainter = _CloudyPainter();
    cloudPainter.paint(canvas, size);

    final snowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    for (int i = 0; i < 3; i++) {
      final double x = w * (0.3 + i * 0.2) + math.sin((progress + i) * math.pi) * 3;
      final double y = h * 0.65 + ((progress + i * 0.33) % 1.0) * (h * 0.25);

      canvas.drawCircle(Offset(x, y), 3.0, snowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ThunderstormPainter extends CustomPainter {
  final double flashOpacity;
  _ThunderstormPainter({required this.flashOpacity});

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPainter = _CloudyPainter();
    cloudPainter.paint(canvas, size);

    final boltPaint = Paint()
      ..color = const Color(0xFFFFD166).withValues(alpha: flashOpacity)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final boltPath = Path();
    boltPath.moveTo(w * 0.55, h * 0.55);
    boltPath.lineTo(w * 0.45, h * 0.72);
    boltPath.lineTo(w * 0.52, h * 0.72);
    boltPath.lineTo(w * 0.42, h * 0.92);
    boltPath.lineTo(w * 0.62, h * 0.68);
    boltPath.lineTo(w * 0.54, h * 0.68);
    boltPath.close();

    canvas.drawPath(boltPath, boltPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _FogPainter extends CustomPainter {
  final double offset;
  _FogPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final fogPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    canvas.drawLine(
      Offset(w * 0.2 + offset, h * 0.4),
      Offset(w * 0.8 + offset, h * 0.4),
      fogPaint,
    );
    canvas.drawLine(
      Offset(w * 0.15 - offset, h * 0.55),
      Offset(w * 0.85 - offset, h * 0.55),
      fogPaint,
    );
    canvas.drawLine(
      Offset(w * 0.25 + offset, h * 0.7),
      Offset(w * 0.75 + offset, h * 0.7),
      fogPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
