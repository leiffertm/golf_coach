import 'package:flutter/material.dart';

class SegmentedEnum<T> extends StatelessWidget {
  final String label;
  final List<T> values;
  final T value;
  final String Function(T) toLabel;
  final void Function(T) onChanged;

  const SegmentedEnum({
    super.key,
    required this.label,
    required this.values,
    required this.value,
    required this.toLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: Theme.of(context).textTheme.labelLarge),
      const SizedBox(height: 8),
      SegmentedButton<T>(
        segments: values.map((v) => ButtonSegment(value: v, label: Text(toLabel(v)))).toList(),
        selected: {value},
        onSelectionChanged: (s) => onChanged(s.first),
        showSelectedIcon: false,
      ),
    ]);
  }
}
