import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A decorative radial progress ring: a pale track, a gradient progress arc
/// and a small filled "thumb" dot at the arc's leading edge.
class RadialGauge extends StatelessWidget {
  final double size;
  final double progress;
  final Color trackColor;
  final List<Color> gradientColors;
  final double strokeWidth;
  final Widget? center;

  const RadialGauge({
    super.key,
    required this.size,
    required this.progress,
    required this.trackColor,
    required this.gradientColors,
    this.strokeWidth = 8,
    this.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RadialGaugePainter(
              progress: progress.clamp(0, 1),
              trackColor: trackColor,
              gradientColors: gradientColors,
              strokeWidth: strokeWidth,
            ),
          ),
          ?center,
        ],
      ),
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  static const double _startAngle = 130 * math.pi / 180;
  static const double _sweepAngle = 280 * math.pi / 180;

  final double progress;
  final Color trackColor;
  final List<Color> gradientColors;
  final double strokeWidth;

  _RadialGaugePainter({
    required this.progress,
    required this.trackColor,
    required this.gradientColors,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final arcRect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, _startAngle, _sweepAngle, false, trackPaint);

    final progressSweep = _sweepAngle * progress;
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: _startAngle,
        endAngle: _startAngle + _sweepAngle,
        colors: gradientColors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(arcRect, _startAngle, progressSweep, false, progressPaint);

    if (progress > 0) {
      final thumbAngle = _startAngle + progressSweep;
      final thumbCenter = Offset(
        center.dx + radius * math.cos(thumbAngle),
        center.dy + radius * math.sin(thumbAngle),
      );
      final thumbPaint = Paint()..color = gradientColors.last;
      canvas.drawCircle(thumbCenter, strokeWidth * 0.65, thumbPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.gradientColors != gradientColors ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
