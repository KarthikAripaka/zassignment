// ─── lib/core/theme/app_text_styles.dart ───
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Display / Headings - DM Serif Display
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 48,
    fontWeight: FontWeight.w400,
    height: 1.1,
    color: Colors.black,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.1,
    color: Colors.black,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 28,
    fontWeight: FontWeight.w400,
    height: 1.2,
    color: Colors.black,
  );

  // Body / UI - DM Sans
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.black,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Colors.black,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: Colors.black,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Colors.black,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: Colors.black87,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Colors.black54,
  );

  // Monospaced amounts - Roboto Mono
  static const TextStyle amountLarge = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.1,
    color: Colors.black,
  );

  static const TextStyle amountMedium = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.black,
  );

  static const TextStyle amountSmall = TextStyle(
    fontFamily: 'RobotoMono',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: Colors.black,
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
