import 'package:flutter/material.dart';
import 'src/app_model.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/log_attempt_screen.dart';
import 'src/screens/stats_screen.dart';
import 'src/screens/settings_screen.dart';

void main() {
  runApp(const GolfCoachApp());
}

class GolfCoachApp extends StatefulWidget {
  const GolfCoachApp({super.key});
  @override
  State<GolfCoachApp> createState() => _GolfCoachAppState();
}

class _GolfCoachAppState extends State<GolfCoachApp> {
  final AppModel model = AppModel.initial();

  int _index = 0;

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(model: model),
      StatsScreen(model: model),
      SettingsScreen(model: model),
    ];

    return AnimatedBuilder(
      animation: model,
      builder: (context, _) {
        return MaterialApp(
          title: 'Golf Coach',
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          routes: {
            LogAttemptScreen.route: (_) => LogAttemptScreen(model: model),
          },
          home: Scaffold(
            appBar: AppBar(title: const Text('Golf Coach')),
            body: pages[_index],
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.sports_golf), label: 'Generate'),
                NavigationDestination(icon: Icon(Icons.insights), label: 'Stats'),
                NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
              ],
            ),
          ),
        );
      },
    );
  }
}
