import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Tiny local store for app flags (e.g. whether onboarding was seen).
class SettingsRepository {
  SettingsRepository(this._box);

  static const String boxName = 'settings';
  static const String _onboardingKey = 'onboardingDone';

  final Box _box;

  bool get onboardingDone =>
      _box.get(_onboardingKey, defaultValue: false) as bool;

  Future<void> markOnboardingDone() => _box.put(_onboardingKey, true);
}

/// Overridden in `main` once Hive is ready.
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  throw UnimplementedError('settingsRepositoryProvider must be overridden');
});
