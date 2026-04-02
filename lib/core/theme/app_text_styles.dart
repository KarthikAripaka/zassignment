// ─── lib/core/theme/app_text_styles.dart ───
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Display / Headings - DM Serif Display
  static final TextStyle displayLarge = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 1.1,
  );

  static final TextStyle displayMedium = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.1,
  );

  static final TextStyle displaySmall = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  // Body / UI - DM Sans
  static final TextStyle headlineLarge = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // Monospaced amounts - Roboto Mono
  static final TextStyle amountLarge = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.1,
  );

  static final TextStyle amountMedium = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final TextStyle amountSmall = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.2,
  );

  // Helper to apply Google Fonts (used in Theme)
  static TextStyle getGoogleFont(TextStyle style) {
    switch (style.fontFamily) {
      case 'DMSerifDisplay':
        return GoogleFonts.dmSerifDisplay(
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          height: style.height,
          color: style.color,
        );
      case 'DMSans':
        return GoogleFonts.dmSans(
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          height: style.height,
          color: style.color,
        );
      case 'RobotoMono':
        return GoogleFonts.robotoMono(
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          height: style.height,
          color: style.color,
        );
      default:
        return style;
    }
  }
}