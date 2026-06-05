import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Flat, monochrome theme. No shadows, no elevation, 16px radii, 1px borders.
abstract final class AppTheme {
  static const double radius = 16;
  static const BorderSide hairline = BorderSide(color: AppColors.border, width: 1);

  static ThemeData build() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.surface,
        primary: AppColors.primaryAction,
        onPrimary: AppColors.buttonText,
        surfaceTint: Colors.transparent,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.display,
        headlineMedium: AppTextStyles.h1,
        titleLarge: AppTextStyles.h2,
        bodyLarge: AppTextStyles.body,
        bodySmall: AppTextStyles.caption,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryText,
        selectionColor: Color(0x33111111),
        selectionHandleColor: AppColors.primaryText,
      ),
    );
  }
}
