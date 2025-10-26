// file: lib/src/screens/home_screen.dart
import 'package:flutter/material.dart';
// import 'package:golf_coach/src/widgets/club_chip.dart';
import '../app_model.dart';
// import '../widgets/kv.dart';
// import '../widgets/segmented_enum.dart';
import '../widgets/empty_state.dart';
// import '../widgets/tiles.dart';
import '../utils/format.dart';
import '../domain/enums.dart';
import '../domain/models.dart';

class HomeScreen extends StatefulWidget {
  final AppModel model;
  const HomeScreen({super.key, required this.model});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _actualCarry = 150; // Default fallback value
  int _endSide = 0;
  Trajectory _actualTrajectory = Trajectory.normal;
  CurveShape _actualCurveShape = CurveShape.straight;
  CurveMag _actualCurveMag = CurveMag.small;

  @override
  void initState() {
    super.initState();
    _updateSliderValues();
  }

  void _updateSliderValues() {
    final spec = widget.model.currentSpec;
    if (spec != null) {
      final carryRange = (spec.carryYards * 0.7).round();
      final carryMax = (spec.carryYards * 1.3).round();
      
      setState(() {
        // Ensure carry is within valid range
        _actualCarry = spec.carryYards.clamp(carryRange, carryMax);
        _endSide = 0;
        _actualTrajectory = spec.trajectory;
        _actualCurveShape = spec.curveShape;
        _actualCurveMag = spec.curveMag;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Why: Rebuild this screen whenever AppModel notifies (after generate/log).
    return AnimatedBuilder(
      animation: widget.model,
      builder: (context, _) {
        final spec = widget.model.currentSpec;
        
        // Update sliders when spec changes
        if (spec != null && _actualCarry != spec.carryYards) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _updateSliderValues();
          });
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                // Generate Shot Button - Compact
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.casino, size: 16),
                    label: const Text(
                      'Generate Shot',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onPressed: () async {
                      await widget.model.generate();
                    },
                  ),
                ),
                const SizedBox(height: 2),
                // Shot details section - Expanded
                if (spec == null)
                  Expanded(
                    flex: 1,
                    child: EmptyState(
                      title: 'No shot yet',
                      message: 'Tap "Generate Shot" to get a random target to hit.',
                    ),
                  )
                else
                  Expanded(
                    flex: 0,
                    child: _SpecCard(
                      spec: spec,
                      skill: widget.model.prefs.skill,
                      showClub: widget.model.prefs.showClubChip,
                      showCarry: widget.model.prefs.showCarryChip,
                    ),
                  ),
                if (spec != null) ...[
                  const SizedBox(height: 2),
                  Expanded(
                    flex: 0,
                    child: _LoggingSection(
                      spec: spec,
                      actualCarry: _actualCarry,
                      endSide: _endSide,
                      actualTrajectory: _actualTrajectory,
                      actualCurveShape: _actualCurveShape,
                      actualCurveMag: _actualCurveMag,
                      onCarryChanged: (value) => setState(() => _actualCarry = value),
                      onSideChanged: (value) => setState(() => _endSide = value),
                      onTrajectoryChanged: (value) => setState(() => _actualTrajectory = value),
                      onCurveShapeChanged: (value) => setState(() => _actualCurveShape = value),
                      onCurveMagChanged: (value) => setState(() => _actualCurveMag = value),
                      onSave: () async {
                        final carryRange = (spec.carryYards * 0.7).round();
                        final carryMax = (spec.carryYards * 1.3).round();
                        final clampedCarry = _actualCarry.clamp(carryRange, carryMax);
                        
                        await widget.model.logAttempt(
                          carry: clampedCarry,
                          height: _actualTrajectory,
                          curveShape: _actualCurveShape,
                          curveMag: _actualCurveMag,
                          endSide: _endSide,
                        );
                        await widget.model.generate();
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 2),
                // Quick stats at bottom - Flexible height
                Flexible(
                  flex: 0,
                  child: _QuickStats(model: widget.model),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoggingSection extends StatelessWidget {
  final ShotSpec spec;
  final int actualCarry;
  final int endSide;
  final Trajectory actualTrajectory;
  final CurveShape actualCurveShape;
  final CurveMag actualCurveMag;
  final ValueChanged<int> onCarryChanged;
  final ValueChanged<int> onSideChanged;
  final ValueChanged<Trajectory> onTrajectoryChanged;
  final ValueChanged<CurveShape> onCurveShapeChanged;
  final ValueChanged<CurveMag> onCurveMagChanged;
  final VoidCallback onSave;

  const _LoggingSection({
    required this.spec,
    required this.actualCarry,
    required this.endSide,
    required this.actualTrajectory,
    required this.actualCurveShape,
    required this.actualCurveMag,
    required this.onCarryChanged,
    required this.onSideChanged,
    required this.onTrajectoryChanged,
    required this.onCurveShapeChanged,
    required this.onCurveMagChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carryRange = (spec.carryYards * 0.7).round();
    final carryMin = carryRange;
    final carryMax = (spec.carryYards * 1.3).round();
    
    // Ensure actualCarry is within the valid range - handle this in parent widget
    final clampedCarry = actualCarry.clamp(carryMin, carryMax);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.edit_note,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Log Your Attempt',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            
            // Actual Carry Slider
            Text(
              'Actual Carry: $clampedCarry yards',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 6),
            Slider(
              value: clampedCarry.toDouble(),
              min: carryMin.toDouble(),
              max: carryMax.toDouble(),
              divisions: (carryMax - carryMin).clamp(1, 50), // Reduced divisions for smoother interaction
              label: '$clampedCarry yds',
              onChanged: (value) => onCarryChanged(value.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '$carryMin yds',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    '$carryMax yds',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // End Side Slider
            Text(
              'End Side: ${endSide > 0 ? '+' : ''}$endSide yards ${endSide > 0 ? '(Right)' : endSide < 0 ? '(Left)' : '(Straight)'}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary,
                fontSize: 10,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 6),
            Slider(
              value: endSide.toDouble(),
              min: -30.0,
              max: 30.0,
              divisions: 20, // Further reduced divisions for smoother sliding
              label: '${endSide > 0 ? '+' : ''}$endSide yds',
              onChanged: (value) => onSideChanged(value.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    '-30 yds (L)',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    '0 yds',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    '+30 yds (R)',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 8),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Trajectory Selection
            Text(
              'Trajectory: ${actualTrajectory.name}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.tertiary,
                fontSize: 9,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Row(
              children: Trajectory.values.map((trajectory) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: FilterChip(
                    label: Text(
                      trajectory.name,
                      style: TextStyle(fontSize: 8),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    selected: actualTrajectory == trajectory,
                    onSelected: (selected) {
                      if (selected) onTrajectoryChanged(trajectory);
                    },
                    selectedColor: theme.colorScheme.tertiary.withValues(alpha: 0.2),
                    checkmarkColor: theme.colorScheme.tertiary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              )).toList(),
            ),
            
            const SizedBox(height: 8),
            
            // Curve Selection
            Text(
              'Curve: ${actualCurveMag.name} ${actualCurveShape.name}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text('Shape:', style: theme.textTheme.bodySmall?.copyWith(fontSize: 9)),
                ),
                ...CurveShape.values.map((shape) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: FilterChip(
                      label: Text(
                        shape.name,
                        style: TextStyle(fontSize: 9),
                      ),
                      selected: actualCurveShape == shape,
                      onSelected: (selected) {
                        if (selected) onCurveShapeChanged(shape);
                      },
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      checkmarkColor: theme.colorScheme.primary,
                    ),
                  ),
                )),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text('Size:', style: theme.textTheme.bodySmall?.copyWith(fontSize: 9)),
                ),
                ...CurveMag.values.map((mag) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    child: FilterChip(
                      label: Text(
                        mag.name,
                        style: TextStyle(fontSize: 9),
                      ),
                      selected: actualCurveMag == mag,
                      onSelected: (selected) {
                        if (selected) onCurveMagChanged(mag);
                      },
                      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                      checkmarkColor: theme.colorScheme.primary,
                    ),
                  ),
                )),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              height: 36,
              child: FilledButton.icon(
                icon: const Icon(Icons.save, size: 16),
                label: const Text(
                  'Save & Generate Next',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onSave,
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class _SpecCard extends StatelessWidget {
  final ShotSpec spec;
  final SkillLevel skill;
  final bool showClub;
  final bool showCarry;
  const _SpecCard({required this.spec, required this.skill, required this.showClub, required this.showCarry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.golf_course,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Shot Details',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            _ShotDetailsGrid(
              spec: spec,
              skill: skill,
              showClub: showClub,
              showCarry: showCarry,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShotDetailsGrid extends StatelessWidget {
  final ShotSpec spec;
  final SkillLevel skill;
  final bool showClub;
  final bool showCarry;
  
  const _ShotDetailsGrid({
    required this.spec,
    required this.skill,
    required this.showClub,
    required this.showCarry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = <_DetailItem>[];
    
    if (showClub) {
      details.add(_DetailItem(
        icon: Icons.sports_golf,
        label: 'Club',
        value: spec.club.label,
        color: theme.colorScheme.primary,
      ));
    }
    
    if (showCarry) {
      details.add(_DetailItem(
        icon: Icons.straighten,
        label: 'Distance',
        value: '${spec.carryYards} yds',
        color: theme.colorScheme.secondary,
      ));
    }
    
    details.add(_DetailItem(
      icon: Icons.trending_up,
      label: 'Trajectory',
      value: '${spec.trajectory.name} height',
      color: theme.colorScheme.tertiary,
    ));
    
    details.add(_DetailItem(
      icon: Icons.swap_horiz,
      label: 'Shape',
      value: spec.curveShape == CurveShape.straight 
          ? spec.curveShape.name 
          : '${spec.curveMag.name} ${spec.curveShape.name}',
      color: theme.colorScheme.primary,
    ));
    
    return Row(
      children: details.map((item) => Expanded(
        child: _DetailCard(
          icon: item.icon,
          label: item.label,
          value: item.value,
          color: item.color,
        ),
      )).toList(),
    );
  }
}

class _DetailItem {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  
  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  
  const _DetailCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
              fontSize: 7,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 1),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 8,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final AppModel model;
  const _QuickStats({required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 12,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 3),
                Text(
                  'Practice Summary',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Attempts',
                    value: '${model.totalAttempts}',
                    theme: theme,
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: theme.colorScheme.outlineVariant,
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Avg Score',
                    value: formatNumber(model.avgScore, 1),
                    theme: theme,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  
  const _StatItem({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 8,
          ),
        ),
      ],
    );
  }
}

