import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;
  const InfoTile({super.key, required this.title, required this.subtitle, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(title), subtitle: Text(subtitle), trailing: trailing),
    );
  }
}
