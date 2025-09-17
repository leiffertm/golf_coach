import 'models.dart';

abstract class Store {
  Future<void> putSpec(ShotSpec spec);
  Future<void> putAttempt(ShotAttempt attempt);
  Future<ShotSpec?> getSpec(String id);
  Future<List<ShotAttempt>> allAttempts();
}

class InMemoryStore implements Store {
  final Map<String, ShotSpec> _specs = {};
  final Map<String, ShotAttempt> _attempts = {};

  @override
  Future<void> putSpec(ShotSpec spec) async => _specs[spec.id] = spec;

  @override
  Future<void> putAttempt(ShotAttempt attempt) async => _attempts[attempt.id] = attempt;

  @override
  Future<ShotSpec?> getSpec(String id) async => _specs[id];

  @override
  Future<List<ShotAttempt>> allAttempts() async =>
      _attempts.values.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
}
