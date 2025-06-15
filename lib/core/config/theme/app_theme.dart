import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jameia/core/config/responsive/screen_size.dart';
import 'package:jameia/core/constants/app_strings.dart';
import 'package:jameia/core/constants/colors.dart';

class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final IconData? themeToggleIcon;
  final String? themeToggleText;

  CustomThemeExtension({
    this.themeToggleIcon,
    this.themeToggleText,
  });

  @override
  CustomThemeExtension copyWith({
    IconData? themeToggleIcon,
    String? themeToggleText,
  }) {
    return CustomThemeExtension(
      themeToggleIcon: themeToggleIcon ?? this.themeToggleIcon,
      themeToggleText: themeToggleText ?? this.themeToggleText,
    );
  }

  @override
  CustomThemeExtension lerp(
      ThemeExtension<CustomThemeExtension>? other, double t) {
    if (other is! CustomThemeExtension) {
      return this;
    }
    return CustomThemeExtension(
      themeToggleIcon: t < 0.5 ? themeToggleIcon : other.themeToggleIcon,
      themeToggleText: t < 0.5 ? themeToggleText : other.themeToggleText,
    );
  }
}

class AppTheme {
  static TextTheme _buildTextTheme(
      TextTheme base, Color textColor, Color secondaryTextColor, double scaleFactor) {
    return base
        .copyWith(
          displayLarge: base.displayLarge?.copyWith(
              color: textColor, fontSize: 57 * scaleFactor, fontWeight: FontWeight.bold),
          displayMedium: base.displayMedium?.copyWith(
              color: textColor, fontSize: 45 * scaleFactor, fontWeight: FontWeight.bold),
          displaySmall: base.displaySmall?.copyWith(
              color: textColor, fontSize: 36 * scaleFactor, fontWeight: FontWeight.bold),
          headlineLarge: base.headlineLarge?.copyWith(
              color: textColor, fontSize: 32 * scaleFactor, fontWeight: FontWeight.bold),
          headlineMedium: base.headlineMedium?.copyWith(
              color: textColor, fontSize: 28 * scaleFactor, fontWeight: FontWeight.bold),
          headlineSmall: base.headlineSmall?.copyWith(
              color: textColor, fontSize: 24 * scaleFactor, fontWeight: FontWeight.bold),
          titleLarge:
              base.titleLarge?.copyWith(color: textColor, fontSize: 22 * scaleFactor, fontWeight: FontWeight.w600),
          titleMedium: base.titleMedium
              ?.copyWith(color: secondaryTextColor, fontSize: 16 * scaleFactor),
          titleSmall: base.titleSmall
              ?.copyWith(color: secondaryTextColor, fontSize: 14 * scaleFactor),
          bodyLarge: base.bodyLarge?.copyWith(color: textColor, fontSize: 16 * scaleFactor, height: 1.5),
          bodyMedium:
              base.bodyMedium?.copyWith(color: secondaryTextColor, fontSize: 14 * scaleFactor),
          bodySmall:
              base.bodySmall?.copyWith(color: secondaryTextColor, fontSize: 12 * scaleFactor),
          labelLarge: base.labelLarge?.copyWith(
              color: AppColors.textOnPrimary,
              fontSize: 14 * scaleFactor,
              fontWeight: FontWeight.bold),
          labelMedium: base.labelMedium?.copyWith(color: textColor, fontSize: 12 * scaleFactor),
          labelSmall:
              base.labelSmall?.copyWith(color: textColor, fontSize: 10 * scaleFactor),
        )
        .apply(
          bodyColor: textColor,
          displayColor: textColor,
        );
  }
  
  static ThemeData getTheme(BuildContext context, Brightness brightness) {
    final bool isDarkMode = brightness == Brightness.dark;
    
    double scaleFactor = 1.0;
    if (ScreenSize.isDesktop(context)) {
      scaleFactor = 1.2;
    } else if (ScreenSize.isTablet(context)) {
      scaleFactor = 1.1;
    }

    final Color textColor = isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final Color secondaryTextColor = isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final Color cardColor = isDarkMode ? AppColors.cardDark : AppColors.cardLight;
    final Color backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight;
    final Color dividerColor = isDarkMode ? AppColors.dividerDark : AppColors.dividerLight;
    
    final TextTheme baseTextTheme = GoogleFonts.poppinsTextTheme();
    final TextTheme textTheme = _buildTextTheme(baseTextTheme, textColor, secondaryTextColor, scaleFactor);

    final baseTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    return baseTheme.copyWith(
      brightness: brightness,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: cardColor,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textOnPrimary,
        onSurface: textColor,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        color: isDarkMode ? AppColors.cardDark : AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textOnPrimary),
        actionsIconTheme: IconThemeData(color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textOnPrimary),
        titleTextStyle: textTheme.headlineSmall?.copyWith(color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textOnPrimary)
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textOnPrimary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: textTheme.labelLarge),
      ),
      iconTheme: IconThemeData(color: textColor),
      dividerColor: dividerColor,
      extensions: <ThemeExtension<dynamic>>[
        CustomThemeExtension(
          themeToggleIcon: isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          themeToggleText: isDarkMode ? AppStrings.switchToLightMode : AppStrings.switchToDarkMode,
        ),
      ],
    );
  }
}
