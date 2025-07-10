import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  // Color palette for vintage theme
  static const Color primaryBrown = Color(0xFF8D6E63);
  static const Color lightBrown = Color(0xFFBCAAA4);
  static const Color darkBrown = Color(0xFF5D4037);
  static const Color paperWhite = Color(0xFFFAF7F0);
  static const Color paperBeige = Color(0xFFF5F1E8);
  static const Color inkBlack = Color(0xFF2E2E2E);
  static const Color sepia = Color(0xFF704214);
  static const Color goldAccent = Color(0xFFFFB300);
  static const Color redAccent = Color(0xFFD32F2F);

  // Text styles with Bengali fonts
  static TextTheme _buildTextTheme(String fontFamily, bool isDark) {
    final Color textColor = isDark ? paperWhite : inkBlack;
    final Color secondaryTextColor = isDark ? paperBeige : sepia;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      headlineSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: secondaryTextColor,
        height: 1.6,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: secondaryTextColor,
        height: 1.4,
      ),
    );
  }

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(primaryBrown),
      primaryColor: primaryBrown,
      scaffoldBackgroundColor: paperWhite,
      cardColor: paperBeige,
      dividerColor: lightBrown.withOpacity(0.3),
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: primaryBrown,
        primaryContainer: lightBrown,
        secondary: goldAccent,
        secondaryContainer: Color(0xFFFFE082),
        surface: paperBeige,
        background: paperWhite,
        error: redAccent,
        onPrimary: paperWhite,
        onPrimaryContainer: inkBlack,
        onSecondary: inkBlack,
        onSecondaryContainer: inkBlack,
        onSurface: inkBlack,
        onBackground: inkBlack,
        onError: paperWhite,
        outline: lightBrown,
        shadow: darkBrown.withOpacity(0.2),
      ),

      // Text theme
      textTheme: _buildTextTheme('SolaimanLipi', false),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryBrown,
        foregroundColor: paperWhite,
        elevation: 4,
        shadowColor: darkBrown.withOpacity(0.3),
        titleTextStyle: _buildTextTheme('SolaimanLipi', true).headlineMedium,
        toolbarTextStyle: _buildTextTheme('SolaimanLipi', true).bodyMedium,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: paperBeige,
        shadowColor: darkBrown.withOpacity(0.2),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: lightBrown.withOpacity(0.3), width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBrown,
          foregroundColor: paperWhite,
          elevation: 3,
          shadowColor: darkBrown.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: _buildTextTheme('SolaimanLipi', true).labelLarge,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paperWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBrown, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBrown, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBrown, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: redAccent, width: 1.5),
        ),
        labelStyle: _buildTextTheme('SolaimanLipi', false).bodyMedium,
        hintStyle: _buildTextTheme('SolaimanLipi', false).bodyMedium?.copyWith(
          color: sepia.withOpacity(0.6),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: goldAccent,
        foregroundColor: inkBlack,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: paperBeige,
        selectedItemColor: primaryBrown,
        unselectedItemColor: sepia.withOpacity(0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: _buildTextTheme('SolaimanLipi', false).labelSmall,
        unselectedLabelStyle: _buildTextTheme('SolaimanLipi', false).labelSmall,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: primaryBrown,
        size: 24,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: lightBrown.withOpacity(0.3),
        thickness: 1,
        space: 16,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(lightBrown),
      primaryColor: lightBrown,
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      cardColor: const Color(0xFF2D2D2D),
      dividerColor: lightBrown.withOpacity(0.3),
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: lightBrown,
        primaryContainer: primaryBrown,
        secondary: goldAccent,
        secondaryContainer: Color(0xFFFF8F00),
        surface: Color(0xFF2D2D2D),
        background: Color(0xFF1A1A1A),
        error: Color(0xFFEF5350),
        onPrimary: inkBlack,
        onPrimaryContainer: paperWhite,
        onSecondary: inkBlack,
        onSecondaryContainer: paperWhite,
        onSurface: paperWhite,
        onBackground: paperWhite,
        onError: paperWhite,
        outline: lightBrown,
        shadow: Colors.black.withOpacity(0.3),
      ),

      // Text theme
      textTheme: _buildTextTheme('SolaimanLipi', true),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF2D2D2D),
        foregroundColor: paperWhite,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        titleTextStyle: _buildTextTheme('SolaimanLipi', true).headlineMedium,
        toolbarTextStyle: _buildTextTheme('SolaimanLipi', true).bodyMedium,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: const Color(0xFF2D2D2D),
        shadowColor: Colors.black.withOpacity(0.3),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: lightBrown.withOpacity(0.3), width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightBrown,
          foregroundColor: inkBlack,
          elevation: 3,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: _buildTextTheme('SolaimanLipi', false).labelLarge,
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF3D3D3D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBrown, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: lightBrown, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: goldAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFEF5350), width: 1.5),
        ),
        labelStyle: _buildTextTheme('SolaimanLipi', true).bodyMedium,
        hintStyle: _buildTextTheme('SolaimanLipi', true).bodyMedium?.copyWith(
          color: paperWhite.withOpacity(0.6),
        ),
      ),

      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: goldAccent,
        foregroundColor: inkBlack,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF2D2D2D),
        selectedItemColor: goldAccent,
        unselectedItemColor: paperWhite.withOpacity(0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: _buildTextTheme('SolaimanLipi', true).labelSmall,
        unselectedLabelStyle: _buildTextTheme('SolaimanLipi', true).labelSmall,
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: lightBrown,
        size: 24,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: lightBrown.withOpacity(0.3),
        thickness: 1,
        space: 16,
      ),
    );
  }

  // Helper method to create MaterialColor
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // Custom decorations for vintage feel
  static BoxDecoration get paperBackground => const BoxDecoration(
    color: paperWhite,
    image: DecorationImage(
      image: AssetImage('assets/images/paper_texture.png'),
      fit: BoxFit.cover,
      opacity: 0.1,
    ),
  );

  static BoxDecoration get darkPaperBackground => const BoxDecoration(
    color: Color(0xFF1A1A1A),
    image: DecorationImage(
      image: AssetImage('assets/images/paper_texture.png'),
      fit: BoxFit.cover,
      opacity: 0.05,
    ),
  );

  static BoxDecoration memoryCardDecoration(bool isDark) => BoxDecoration(
    color: isDark ? const Color(0xFF2D2D2D) : paperBeige,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: isDark ? lightBrown.withOpacity(0.3) : lightBrown.withOpacity(0.5),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: isDark ? Colors.black.withOpacity(0.3) : darkBrown.withOpacity(0.2),
        blurRadius: 6,
        offset: const Offset(2, 3),
      ),
    ],
  );

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Spacing constants
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  // Border radius constants
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
}

