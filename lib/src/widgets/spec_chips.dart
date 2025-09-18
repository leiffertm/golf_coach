import 'package:flutter/material.dart';

import '../domain/club_distance_table.dart';
import '../domain/enums.dart';
import '../domain/models.dart';

class ClubChip extends StatelessWidget {
  final Club club;
  const ClubChip({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _clubColor(club, scheme);
    return _SpecChip(
      color: color,
      label: club.label,
      visual: Icon(Icons.sports_golf, size: 16, color: color),
    );
  }
}

class CarryChip extends StatelessWidget {
  final ShotSpec spec;
  final SkillLevel skill;
  const CarryChip({super.key, required this.spec, required this.skill});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.primary;
    final (min, max) = ClubDistanceTable.range(spec.club, skill);
    final span = (max - min).clamp(1, 400);
    final fill = ((spec.carryYards - min) / span).clamp(0.0, 1.0);
    return _SpecChip(
      color: base,
      label: '${spec.carryYards} yds',
      visual: _CarryBar(fill: fill, color: base),
    );
  }
}

class TrajectoryChip extends StatelessWidget {
  final Trajectory trajectory;
  const TrajectoryChip({super.key, required this.trajectory});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _trajectoryColor(trajectory, scheme);
    final icon = switch (trajectory) {
      Trajectory.low => Icons.south_east,
      Trajectory.normal => Icons.arrow_outward,
      Trajectory.high => Icons.north_east,
    };
    return _SpecChip(
      color: color,
      label: trajectory.name,
      visual: Icon(icon, size: 16, color: color),
    );
  }
}

class CurveChip extends StatelessWidget {
  final CurveShape shape;
  final CurveMag magnitude;
  const CurveChip({super.key, required this.shape, required this.magnitude});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = _curveBaseColor(shape, scheme);
    final bool isStraight = shape == CurveShape.straight;
    final intensity = switch (magnitude) {
      CurveMag.small => 0.65,
      CurveMag.medium => 0.8,
      CurveMag.large => 1.0,
    };
    final color = isStraight ? base : (Color.lerp(base.withValues(alpha: 0.6), base, intensity) ?? base);
    return _SpecChip(
      color: color,
      label: isStraight ? shape.name : '${magnitude.name} ${shape.name}',
      visual: _CurveVisual(shape: shape, magnitude: magnitude, color: color),
    );
  }
}

class _SpecChip extends StatelessWidget {
  final Color color;
  final String label;
  final Widget visual;
  const _SpecChip({required this.color, required this.label, required this.visual});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            visual,
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _CarryBar extends StatelessWidget {
  final double fill;
  final Color color;
  const _CarryBar({required this.fill, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(decoration: BoxDecoration(color: color.withValues(alpha: 0.18))),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fill,
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withValues(alpha: 0.4), color])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurveVisual extends StatelessWidget {
  final CurveShape shape;
  final CurveMag magnitude;
  final Color color;
  const _CurveVisual({required this.shape, required this.magnitude, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(44, 16),
      painter: _CurvePainter(shape: shape, magnitude: magnitude, color: color),
    );
  }
}

class _CurvePainter extends CustomPainter {
  final CurveShape shape;
  final CurveMag magnitude;
  final Color color;
  _CurvePainter({required this.shape, required this.magnitude, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = shape == CurveShape.straight
          ? 3.0
          : switch (magnitude) {
              CurveMag.small => 2.5,
              CurveMag.medium => 3.5,
              CurveMag.large => 4.5,
            }
      ..color = color;

    final path = Path();
    final height = size.height;
    final width = size.width;

    switch (shape) {
      case CurveShape.straight:
        path.moveTo(0, height / 2);
        path.lineTo(width, height / 2);
        break;
      case CurveShape.draw:
        path.moveTo(0, height * 0.8);
        path.quadraticBezierTo(width * 0.45, height * 0.3, width, height * 0.45);
        break;
      case CurveShape.fade:
        path.moveTo(0, height * 0.45);
        path.quadraticBezierTo(width * 0.55, height * 0.2, width, height * 0.8);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvePainter oldDelegate) {
    return oldDelegate.shape != shape ||
        oldDelegate.magnitude != magnitude ||
        oldDelegate.color != color;
  }
}

Color _clubColor(Club club, ColorScheme scheme) {
  if (club == Club.driver) return scheme.secondary;
  if (club == Club.w3 || club == Club.w5) return scheme.secondaryContainer;
  if (club == Club.h3 || club == Club.h4) return scheme.tertiary;
  if (club == Club.i3 || club == Club.i4 || club == Club.i5 || club == Club.i6 || club == Club.i7 || club == Club.i8 || club == Club.i9) {
    return scheme.primary;
  }
  return scheme.tertiaryContainer;
}

Color _trajectoryColor(Trajectory trajectory, ColorScheme scheme) {
  if (trajectory == Trajectory.low) return Colors.amber.shade600;
  if (trajectory == Trajectory.normal) return scheme.primary;
  return Colors.teal.shade400;
}

Color _curveBaseColor(CurveShape shape, ColorScheme scheme) {
  if (shape == CurveShape.draw) return Colors.blue.shade500;
  if (shape == CurveShape.fade) return Colors.deepOrange.shade400;
  return scheme.outlineVariant;
}
