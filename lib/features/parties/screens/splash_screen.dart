import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app_info.dart';
import '../../../core/settings_repository.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../onboarding/onboarding_screen.dart';
import 'home_screen.dart';

/// App launch screen. Shows the identity briefly, then opens onboarding (first
/// launch) or Home.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      final onboardingDone =
          ref.read(settingsRepositoryProvider).onboardingDone;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              onboardingDone ? const HomeScreen() : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/logo.svg', width: 88, height: 88),
            const SizedBox(height: 20),
            Text(kAppName, style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).splashTagline,
                style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
