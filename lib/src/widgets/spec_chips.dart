// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

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
      enlarged: true,
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
    return _SpecChip(
      color: base,
      label: '${spec.carryYards} yds',
      enlarged: true,
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
    return _SpecChip(
      color: color,
      label: '${trajectory.name} height',
      enlarged: true,
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
      enlarged: true,
    );
  }
}

class _SpecChip extends StatelessWidget {
  final Color color;
  final String label;
  final Widget? visual;
  final bool enlarged;
  const _SpecChip({required this.color, required this.label, this.visual, this.enlarged = false});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (visual != null) ...[
          visual!,
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            height: 4,
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: enlarged ? 32 : 32,
          ),
        ),
      ],
    );
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
