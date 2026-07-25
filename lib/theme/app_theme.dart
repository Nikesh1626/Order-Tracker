import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Seed color and primary palette
  static const Color primary = Color(0xFF384CD3);
  static const Color primaryContainer = Color(0xFF5366ED);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color inversePrimary = Color(0xFFBCC2FF);

  // Background and surface
  static const Color background = Color(0xFFFBF8FE);
  static const Color onBackground = Color(0xFF1B1B1F);
  static const Color surface = Color(0xFFFBF8FE);
  static const Color onSurface = Color(0xFF1B1B1F);
  static const Color surfaceVariant = Color(0xFFE4E1E7);
  static const Color onSurfaceVariant = Color(0xFF454654);

  // Outline
  static const Color outline = Color(0xFF757686);
  static const Color outlineVariant = Color(0xFFC5C5D7);

  // Semantic Colors
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color success = Color(0xFF198754);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF0DCAF0);

  // Status Chip Colors
  static const Color statusPlaced = Color(0xFFE4E1E7); // surfaceVariant (Grey)
  static const Color statusPacked = Color(0xFF5366ED); // primaryContainer (Blue)
  static const Color statusShipped = Color(0xFF5C5D72); // secondary (Indigo-ish)
  static const Color statusOutForDelivery = Color(0xFF755169); // tertiary (Orange/Pinkish)
  static const Color statusDelivered = Color(0xFF198754); // success (Green)
  static const Color statusCancelled = Color(0xFFBA1A1A); // error (Red)

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: Colors.white,
        secondary: Color(0xFF5C5D72),
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFDBDBF4),
        onSecondaryContainer: Color(0xFF5E5F74),
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        // Wait, background is deprecated in recent flutter but we use it for some versions
      ),
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            height: 1.27,
            letterSpacing: 0,
            color: onSurface,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.5,
            letterSpacing: 0.15,
            color: onSurface,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.625,
            letterSpacing: 0.5,
            color: onSurfaceVariant,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.57,
            letterSpacing: 0.25,
            color: onSurfaceVariant,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.43,
            letterSpacing: 0.1,
            color: onSurface,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.33,
            letterSpacing: 0.5,
            color: onSurfaceVariant,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outline, width: 1),
        ),
        margin: const EdgeInsets.only(bottom: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        labelStyle: const TextStyle(
          color: onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
