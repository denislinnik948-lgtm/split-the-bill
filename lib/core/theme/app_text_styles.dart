import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// Single font family for the whole app: Overpass Mono.
///
/// The bundled file is a variable font, so weights are selected through
/// [FontVariation] on the `wght` axis (with [FontWeight] kept in sync as a
/// fallback for platforms that ignore variations).
const String kFontFamily = 'OverpassMono';

abstract final class AppTextStyles {
  static TextStyle _base(double size, int weight, {Color? color}) {
    return TextStyle(
      fontFamily: kFontFamily,
      fontSize: size,
      height: 1.2,
      letterSpacing: 0,
      color: color ?? AppColors.primaryText,
      fontWeight: _toFontWeight(weight),
      fontVariations: [FontVariation('wght', weight.toDouble())],
    );
  }

  static FontWeight _toFontWeight(int weight) {
    return switch (weight) {
      <= 300 => FontWeight.w300,
      <= 400 => FontWeight.w400,
      <= 500 => FontWeight.w500,
      <= 600 => FontWeight.w600,
      _ => FontWeight.w700,
    };
  }

  /// 40px SemiBold — big numbers and screen identity.
  static final TextStyle display = _base(40, 600);

  /// 28px SemiBold — screen titles (NEW PARTY, CALCULATION).
  static final TextStyle h1 = _base(28, 600);

  /// 20px Medium — section headers and list primary text.
  static final TextStyle h2 = _base(20, 500);

  /// 16px Regular — body copy.
  static final TextStyle body = _base(16, 400);

  /// 16px Regular on the secondary colour.
  static final TextStyle bodyMuted = _base(16, 400, color: AppColors.secondaryText);

  /// 13px Regular — captions and metadata.
  static final TextStyle caption = _base(13, 400, color: AppColors.secondaryText);

  /// 16px SemiBold on the button text colour.
  static final TextStyle button = _base(16, 600, color: AppColors.buttonText);
}
