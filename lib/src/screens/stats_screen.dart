import 'package:flutter/material.dart';
import '../app_model.dart';
import '../widgets/spacer.dart';
import '../utils/format.dart';

class StatsScreen extends StatelessWidget {
  final AppModel model;
  const StatsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Text('Overview', style: Theme.of(context).textTheme.titleLarge),
          const VSpacer(8),
          Row(
            children: [
              Expanded(child: _StatTile(title: 'Attempts', value: '${model.totalAttempts}')),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(title: 'Avg Score', value: formatNumber(model.avgScore, 1))),
            ],
          ),
          const VSpacer(16),
          Text('Insights', style: Theme.of(context).textTheme.titleLarge),
          const VSpacer(8),
          if (model.insights.isEmpty)
            const Text('No insights yet. Log attempts to see patterns.')
          else
            ...model.insights.map((p) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.lightbulb_outline),
                    title: Text(p.toUserString()),
                    subtitle: Text('Samples: ${p.count} • Opposite-shape: ${(p.oppositeShapeRate * 100).round()}%'),
                  ),
                )),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;
  const _StatTile({required this.title, required this.value});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
        ]),
      ),
    );
  }
}
