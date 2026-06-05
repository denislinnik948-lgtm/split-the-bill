import 'package:flutter/widgets.dart';

/// Monochrome, Apple-inspired palette. No accent colours, no gradients.
abstract final class AppColors {
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF111111);
  static const Color secondaryText = Color(0xFF7A7A7A);
  // One tone darker than the spec's #EAEAEA so divider/hairlines read clearly
  // without looking heavy.
  static const Color border = Color(0xFFDCDCDC);

  /// Filled primary action background.
  static const Color primaryAction = Color(0xFF111111);

  /// Text on top of the primary action.
  static const Color buttonText = Color(0xFFFAFAFA);
}
