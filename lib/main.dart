import 'package:flutter/material.dart';
import 'src/app_model.dart';
import 'src/screens/home_screen.dart';
import 'src/screens/stats_screen.dart';
import 'src/screens/settings_screen.dart';
import 'src/domain/club_distance_table.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize custom distances from JSON file
  await ClubDistanceTable.initializeCustomDistances();
  
  
  runApp(const GolfCoachApp());
}

class GolfCoachApp extends StatefulWidget {
  const GolfCoachApp({super.key});
  @override
  State<GolfCoachApp> createState() => _GolfCoachAppState();
}

class _GolfCoachAppState extends State<GolfCoachApp> {
  late final Future<AppModel> _modelFuture;
  AppModel? _model;

  @override
  void initState() {
    super.initState();
    _modelFuture = AppModel.initial();
    _modelFuture.then((model) {
      if (mounted) {
        setState(() {
          _model = model;
        });
      }
    });
  }

  @override
  void dispose() {
    _model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _model!,
      builder: (context, _) {
        return MaterialApp(
          title: 'Golf Coach',
          theme: ThemeData(
            colorSchemeSeed: Colors.green,
            useMaterial3: true,
            brightness: Brightness.light,
          ),
          routes: {
            '/stats': (_) => StatsScreen(model: _model!),
            '/settings': (_) => SettingsScreen(model: _model!),
          },
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Golf Coach'),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'stats':
                        Navigator.of(context).pushNamed('/stats');
                        break;
                      case 'settings':
                        Navigator.of(context).pushNamed('/settings');
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<String>(
                      value: 'stats',
                      child: Row(
                        children: [
                          Icon(Icons.insights),
                          SizedBox(width: 8),
                          Text('Stats'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 8),
                          Text('Settings'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: HomeScreen(model: _model!),
          ),
        );
      },
    );
  }
}
