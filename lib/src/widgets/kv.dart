import 'package:flutter/material.dart';

class KV extends StatelessWidget {
  final String k;
  final String v;
  const KV({super.key, required this.k, required this.v});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(k, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: 8),
        Expanded(child: Text(v, textAlign: TextAlign.right)),
      ],
    );
  }
}
