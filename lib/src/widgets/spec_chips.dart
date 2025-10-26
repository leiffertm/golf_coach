// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

import '../domain/enums.dart';
import '../domain/models.dart';
// import 'package:auto_size_text/auto_size_text.dart';


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
    );
  }
}

class _SpecChip extends StatelessWidget {
  final Color color;
  final String label;
  final Widget? visual;
  const _SpecChip({required this.color, required this.label, this.visual});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    
    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (visual != null) ...[
            visual!,
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
