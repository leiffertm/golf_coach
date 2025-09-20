// file: lib/src/screens/home_screen.dart
import 'package:flutter/material.dart';
// import 'package:golf_coach/src/widgets/club_chip.dart';
import '../app_model.dart';
// import '../widgets/kv.dart';
// import '../widgets/segmented_enum.dart';
import '../widgets/empty_state.dart';
// import '../widgets/tiles.dart';
import '../widgets/spacer.dart';
import '../utils/format.dart';
import '../domain/enums.dart';
import '../domain/models.dart';
import 'log_attempt_screen.dart';
import '../widgets/spec_chips.dart';

class HomeScreen extends StatelessWidget {
  final AppModel model;
  const HomeScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // Why: Rebuild this screen whenever AppModel notifies (after generate/log).
    return AnimatedBuilder(
      animation: model,
      builder: (context, _) {
        final spec = model.currentSpec;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.casino),
                    label: const Text('Generate Shot'),
                    onPressed: () async {
                      await model.generate();
                    },
                  ),
                ),
              ],
            ),
            const VSpacer(16),
            Expanded(
              child: spec == null
                  ? const EmptyState(
                      title: 'No shot yet',
                      message: 'Tap “Generate Shot” to get a random target to hit.',
                    )
                  : _SpecCard(
                      spec: spec,
                      skill: model.prefs.skill,
                      showClub: model.prefs.showClubChip,
                      showCarry: model.prefs.showCarryChip,
                    ),
            ),
            if (spec != null) ...[
              const VSpacer(12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Log Attempt'),
                      onPressed: () {
                        Navigator.of(context).pushNamed(LogAttemptScreen.route);
                      },
                    ),
                  ),
                ],
              ),
            ],
              const VSpacer(16),
              _QuickStats(model: model),
              const VSpacer(8),
              _TopInsights(model: model),
            ],
          ),
        );
      },
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
    final tiles = <Widget>[
      if (showClub) ClubChip(club: spec.club),
      if (showCarry) CarryChip(spec: spec, skill: skill),
      TrajectoryChip(trajectory: spec.trajectory),
      CurveChip(shape: spec.curveShape, magnitude: spec.curveMag),
    ];

    return Card(
      margin: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const horizontalPadding = 0; // 16 on each side
          const verticalPadding = 0; // 16 top/bottom
          const crossAxisSpacing = 0.0;
          const mainAxisSpacing = 0.0;
          const crossAxisCount = 2;
          final rowCount = tiles.isEmpty ? 1 : ((tiles.length + crossAxisCount - 1) ~/ crossAxisCount);

          final availableWidth = (constraints.maxWidth - horizontalPadding -
                  (crossAxisCount - 1) * crossAxisSpacing)
              .clamp(0.0, double.infinity);
          final availableHeight = (constraints.maxHeight - verticalPadding -
                  (rowCount - 1) * mainAxisSpacing)
              .clamp(0.0, double.infinity);

          final itemWidth = crossAxisCount > 0 ? availableWidth / crossAxisCount : availableWidth;
          final itemHeight = rowCount > 0 ? availableHeight / rowCount : availableHeight;
          final aspectRatio = itemHeight > 0 ? itemWidth / itemHeight : 1.0;

          return Padding(
            padding: const EdgeInsets.all(0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: mainAxisSpacing,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: aspectRatio,
              ),
              itemCount: tiles.length,
              itemBuilder: (context, index) => SizedBox.expand(
                child: Center(child: tiles[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final AppModel model;
  const _QuickStats({required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: const Text('Practice Summary'),
        subtitle: Text('Attempts: ${model.totalAttempts}   •   Avg Score: ${formatNumber(model.avgScore, 1)}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _TopInsights extends StatelessWidget {
  final AppModel model;
  const _TopInsights({required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.insights.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Recent Insights', style: Theme.of(context).textTheme.titleMedium),
        const VSpacer(8),
        ...model.insights.take(3).map((p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(p.toUserString())),
                ],
              ),
            )),
      ]),
    );
  }
}
