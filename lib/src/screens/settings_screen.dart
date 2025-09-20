import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_model.dart';
import '../widgets/spacer.dart';
import '../domain/enums.dart';
import '../domain/models.dart';

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
        final showClub = model.prefs.showClubChip;
        final showCarry = model.prefs.showCarryChip;
        final yardages = model.prefs.yardages;
        final missing = model.clubsMissingYardages;

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
              Text('Generator Strictness',
                  style: Theme.of(context).textTheme.titleLarge),
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
              Text('Shot Display',
                  style: Theme.of(context).textTheme.titleLarge),
              const VSpacer(8),
              SwitchListTile(
                title: const Text('Show club chip'),
                value: showClub,
                onChanged: (on) => model.setShowClubChip(on),
              ),
              SwitchListTile(
                title: const Text('Show yardage chip'),
                value: showCarry,
                subtitle: missing.isEmpty
                    ? null
                    : Text(
                        'Add yardages for ${missing.map((c) => c.label).join(', ')}'),
                onChanged: (on) {
                  final changed = model.setShowCarryChip(on);
                  if (!changed) {
                    if (on) {
                      final names = model.clubsMissingYardages
                          .map((c) => c.label)
                          .join(', ');
                      final message = names.isEmpty
                          ? 'Add yardage ranges for each club in your bag before enabling yardage.'
                          : 'Add yardage ranges for $names before enabling yardage.';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Keep at least one shot chip visible.')),
                      );
                    }
                  }
                },
              ),
              const VSpacer(16),
              Text('In-Bag Clubs',
                  style: Theme.of(context).textTheme.titleLarge),
              const VSpacer(8),
              ...Club.values.map(
                (c) => _ClubYardageTile(
                  club: c,
                  selected: bag.contains(c),
                  range: yardages[c],
                  onToggle: (on) => model.toggleClub(c, on),
                  onRangeChanged: (min, max) =>
                      model.updateClubYardageRange(c, min: min, max: max),
                  highlightMissing:
                      bag.contains(c) && (yardages[c]?.isValid != true),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ClubYardageTile extends StatefulWidget {
  final Club club;
  final bool selected;
  final ClubYardageRange? range;
  final ValueChanged<bool> onToggle;
  final void Function(int?, int?) onRangeChanged;
  final bool highlightMissing;
  const _ClubYardageTile({
    required this.club,
    required this.selected,
    required this.range,
    required this.onToggle,
    required this.onRangeChanged,
    required this.highlightMissing,
  });

  @override
  State<_ClubYardageTile> createState() => _ClubYardageTileState();
}

class _ClubYardageTileState extends State<_ClubYardageTile> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;

  @override
  void initState() {
    super.initState();
    _minController =
        TextEditingController(text: widget.range?.min.toString() ?? '');
    _maxController =
        TextEditingController(text: widget.range?.max.toString() ?? '');
  }

  @override
  void didUpdateWidget(covariant _ClubYardageTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.range?.min != widget.range?.min) {
      _minController.text = widget.range?.min.toString() ?? '';
    }
    if (oldWidget.range?.max != widget.range?.max) {
      _maxController.text = widget.range?.max.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _handleChanged() {
    if (!widget.selected) return;
    final min = _parse(_minController.text);
    final max = _parse(_maxController.text);
    widget.onRangeChanged(min, max);
  }

  int? _parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    return int.tryParse(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final needsRange = widget.selected && widget.highlightMissing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CheckboxListTile(
          value: widget.selected,
          onChanged: (on) => widget.onToggle(on ?? false),
          title: Text(widget.club.label),
          contentPadding: EdgeInsets.zero,
        ),
        if (widget.selected) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Min carry',
                      suffixText: 'yds',
                    ),
                    onChanged: (_) => _handleChanged(),
                  ),
                ),
                const HSpacer(16),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: 'Max carry',
                      suffixText: 'yds',
                    ),
                    onChanged: (_) => _handleChanged(),
                  ),
                ),
              ],
            ),
          ),
          if (needsRange) ...[
            const VSpacer(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Enter both a minimum and maximum carry for this club.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            ),
          ],
          const VSpacer(12),
        ] else
          const VSpacer(8),
      ],
    );
  }
}
