import 'package:flutter/material.dart';

class AppTheme {
  // Paleta Base
  static const Color _primary = Color(0xFF10B981); // Emerald Vibrante
  static const Color _secondary = Color(0xFF3B82F6); // Azul

  // Cores Light
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _cardLight = Colors.white;
  static const Color _textMainLight = Color(0xFF0F172A);
  static const Color _textMutedLight = Color(0xFF64748B);

  // Cores Dark
  static const Color _bgDark = Color(0xFF0F172A); // Slate 900
  static const Color _cardDark = Color(0xFF1E293B); // Slate 800
  static const Color _textMainDark = Color(0xFFF8FAFC); // Slate 50
  static const Color _textMutedDark = Color(0xFF94A3B8); // Slate 400

  static ThemeData get light {
    final base = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.light,
      primary: _primary,
      secondary: _secondary,
      surface: _bgLight,
    );

    return _buildTheme(base, _bgLight, _cardLight, _textMainLight,
        _textMutedLight, _textMainLight);
  }

  static ThemeData get dark {
    final base = ColorScheme.fromSeed(
      seedColor: _primary,
      brightness: Brightness.dark,
      primary: _primary,
      secondary: _secondary,
      surface: _bgDark,
    );

    // No tema escuro, os botões e FAB ficam com a cor primária (Verde) para melhor contraste
    return _buildTheme(
        base, _bgDark, _cardDark, _textMainDark, _textMutedDark, _primary);
  }

  // Método auxiliar para não duplicar código na construção de temas
  static ThemeData _buildTheme(ColorScheme base, Color bg, Color card,
      Color textMain, Color textMuted, Color fabColor) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter',
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textMain,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textMain,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: textMain),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: fabColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        extendedPadding: const EdgeInsets.symmetric(horizontal: 24),
        extendedTextStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.2),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
        ),
        labelStyle: TextStyle(color: textMuted),
        hintStyle: TextStyle(color: textMuted.withValues(alpha: 0.6)),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: textMain,
            letterSpacing: -1),
        headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textMain,
            letterSpacing: -0.5),
        headlineSmall: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: textMain),
        bodyLarge: TextStyle(
            fontSize: 16, color: textMain, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14, color: textMuted),
        bodySmall: TextStyle(fontSize: 13, color: textMuted),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: TextStyle(color: textMain, fontWeight: FontWeight.w500),
      ),
    );
  }

  static const List<Color> goalColors = [
    Color(0xFF10B981),
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFFF43F5E),
    Color(0xFFF59E0B),
    Color(0xFF06B6D4),
    Color(0xFF14B8A6),
    Color(0xFFEC4899),
  ];

  static const List<IconData> goalIcons = [
    Icons.savings_rounded,
    Icons.flight_takeoff_rounded,
    Icons.directions_car_rounded,
    Icons.home_work_rounded,
    Icons.school_rounded,
    Icons.favorite_rounded,
    Icons.sports_esports_rounded,
    Icons.shopping_bag_rounded,
    Icons.restaurant_rounded,
    Icons.fitness_center_rounded,
    Icons.beach_access_rounded,
    Icons.laptop_mac_rounded,
    Icons.celebration_rounded,
    Icons.pets_rounded,
    Icons.monitor_heart_rounded,
    Icons.headset_rounded,
  ];
}
