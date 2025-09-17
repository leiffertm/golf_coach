import 'package:flutter/material.dart';
import '../app_model.dart';
import '../widgets/spacer.dart';
import '../domain/enums.dart';

class SettingsScreen extends StatelessWidget {
  final AppModel model;
  const SettingsScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    // Rebuild when AppModel notifies (after skill/strictness/club changes).
    return AnimatedBuilder(
      animation: model,
      builder: (context, _) {
        final skill = model.prefs.skill;
        final strict = model.prefs.generatorStrictness;
        final bag = model.prefs.inBag;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Text('Skill', style: Theme.of(context).textTheme.titleLarge),
              const VSpacer(8),
              Wrap(
                spacing: 8,
                children: SkillLevel.values.map((s) {
                  final selected = s == skill;
                  return ChoiceChip(
                    label: Text(s.name),
                    selected: selected,
                    onSelected: (_) => model.updateSkill(s),
                  );
                }).toList(),
              ),
              const VSpacer(16),
              Text('Generator Strictness', style: Theme.of(context).textTheme.titleLarge),
              const VSpacer(8),
              Wrap(
                spacing: 8,
                children: GeneratorStrictness.values.map((g) {
                  final selected = g == strict;
                  return ChoiceChip(
                    label: Text(g.name),
                    selected: selected,
                    onSelected: (_) => model.updateStrictness(g),
                  );
                }).toList(),
              ),
              const VSpacer(16),
              Text('In-Bag Clubs', style: Theme.of(context).textTheme.titleLarge),
              const VSpacer(8),
              ...Club.values.map(
                (c) => CheckboxListTile(
                  value: bag.contains(c),
                  onChanged: (on) => model.toggleClub(c, on ?? false),
                  title: Text(c.label),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}