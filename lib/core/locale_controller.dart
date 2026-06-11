import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings_repository.dart';

/// The user's manual language choice, or null to follow the system locale.
class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(settingsRepositoryProvider).localeCode;
    return code == null ? null : Locale(code);
  }

  Future<void> setLocale(Locale? locale) async {
    await ref
        .read(settingsRepositoryProvider)
        .setLocaleCode(locale?.languageCode);
    state = locale;
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);

/// Resolves the app locale: a chosen override wins; otherwise Ukrainian is the
/// default and English is used only when the system language is English.
Locale resolveAppLocale(Locale? incoming) {
  return incoming?.languageCode == 'en'
      ? const Locale('en')
      : const Locale('uk');
}
