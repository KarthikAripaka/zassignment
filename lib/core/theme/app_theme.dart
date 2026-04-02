// ─── lib/core/theme/app_theme.dart ───
import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.grey,
      brightness: Brightness.light,
      primary: Colors.black87,
      secondary: AppColors.accent,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
      onBackground: Colors.black,
      error: AppColors.danger,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black12),
      ),
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black26),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black54, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    ),
    textTheme: _textTheme(Brightness.light),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.black87,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      surfaceTintColor: Colors.transparent,
    ),
  );

  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimary,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimary,
      secondary: AppColors.accent,
      surface: AppColors.darkSurface,
      background: AppColors.darkNeutralBg,
      onPrimary: AppColors.surface,
      onSecondary: AppColors.darkTextPrimary,
      onSurface: AppColors.darkTextPrimary,
      onBackground: AppColors.darkTextPrimary,
      error: AppColors.danger,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.darkNeutralBg,
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      surfaceTintColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.all(16),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTextStyles.headlineSmall.copyWith(
        color: AppColors.darkTextPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
    ),
    textTheme: _textTheme(Brightness.dark),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.darkPrimary,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
  );

  static TextTheme _textTheme(Brightness brightness) {
    final base = (brightness == Brightness.light
            ? Typography.material2021().black
            : Typography.material2021().white)
        .apply(
      bodyColor:
          brightness == Brightness.light ? null : AppColors.darkTextPrimary,
      displayColor:
          brightness == Brightness.light ? null : AppColors.darkTextPrimary,
    );

    return base
        .copyWith(
          displayLarge: AppTextStyles.displayLarge,
          displayMedium: AppTextStyles.displayMedium,
          displaySmall: AppTextStyles.displaySmall,
          headlineLarge: AppTextStyles.headlineLarge,
          headlineMedium: AppTextStyles.headlineMedium,
          headlineSmall: AppTextStyles.headlineSmall,
          bodyLarge: AppTextStyles.bodyLarge,
          bodyMedium: AppTextStyles.bodyMedium,
          bodySmall: AppTextStyles.bodySmall,
        )
        .apply(fontFamily: 'DMSans');
  }
}
