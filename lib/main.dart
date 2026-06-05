import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/app_info.dart';
import 'core/settings_repository.dart';
import 'core/theme/app_theme.dart';
import 'features/parties/data/party_repository.dart';
import 'features/parties/screens/splash_screen.dart';
import 'features/parties/state/parties_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Offline-first storage: everything lives in local Hive boxes.
  await Hive.initFlutter();
  final partiesBox = await Hive.openBox<String>(HivePartyRepository.boxName);
  final settingsBox = await Hive.openBox(SettingsRepository.boxName);

  runApp(
    ProviderScope(
      overrides: [
        partyRepositoryProvider
            .overrideWithValue(HivePartyRepository(partiesBox)),
        settingsRepositoryProvider
            .overrideWithValue(SettingsRepository(settingsBox)),
      ],
      child: const SplitTripApp(),
    ),
  );
}

class SplitTripApp extends StatelessWidget {
  const SplitTripApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
