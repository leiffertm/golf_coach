// file: lib/src/screens/home_screen.dart
import 'package:flutter/material.dart';
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
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('New shot generated')),
                          );
                        }
                      },
                    ),
                  ),
                  const HSpacer(12),
                  IconButton(
                    tooltip: 'Quick log',
                    onPressed: spec == null ? null : () => Navigator.of(context).pushNamed(LogAttemptScreen.route),
                    icon: const Icon(Icons.edit_note),
                  ),
                ],
              ),
              const VSpacer(16),
              if (spec == null)
                const Expanded(
                  child: EmptyState(
                    title: 'No shot yet',
                    message: 'Tap “Generate Shot” to get a random target to hit.',
                  ),
                )
              else
                // Keep Flex layout consistent with the null branch.
                Expanded(child: _SpecCard(spec: spec)),
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
  const _SpecCard({required this.spec});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Target Shot', style: Theme.of(context).textTheme.titleLarge),
          const VSpacer(8),
          Wrap(spacing: 12, runSpacing: 8, children: [
            Chip(label: Text(spec.club.label)),
            Chip(label: Text('${spec.carryYards} yds')),
            Chip(label: Text(spec.trajectory.name)),
            Chip(label: Text('${spec.curveMag.name} ${spec.curveShape.name}')),
          ]),
          const VSpacer(8),
          Row(
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.edit_note),
                label: const Text('Log Attempt'),
                onPressed: () {
                  Navigator.of(context).pushNamed(LogAttemptScreen.route);
                },
              ),
            ],
          ),
        ]),
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
      child: Padding(
        padding: const EdgeInsets.all(12),
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
      ),
    );
  }
}