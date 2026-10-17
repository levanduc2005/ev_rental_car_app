import 'package:flutter/material.dart';
import 'package:rental_car/core/theme/app_colors.dart';

/// Central Material 3 theme definition.
///
/// Both light and dark themes are derived from a single [seedColor] so the
/// palette stays consistent. Tweak [seedColor] to re-brand the whole app.
abstract final class AppTheme {
  static const Color seedColor = AppColors.primary;

  static ThemeData light() => _base(Brightness.light);
  static ThemeData dark() => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
      surface: isDark ? const Color(0xFF0F172A) : AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F172A)
          : AppColors.background,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF1E293B) : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : AppColors.border,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : AppColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF334155) : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderFocused,
            width: 1.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          foregroundColor: isDark ? Colors.white : AppColors.textPrimary,
          side: BorderSide(
            color: isDark ? const Color(0xFF334155) : AppColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDark ? const Color(0xFF94A3B8) : AppColors.textSecondary,
          height: 1.5,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 16,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        dragHandleColor: isDark ? const Color(0xFF475569) : AppColors.border,
        dragHandleSize: const Size(40, 4),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        backgroundColor: isDark
            ? const Color(0xFF334155)
            : AppColors.textPrimary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: AppColors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark
            ? const Color(0xFF94A3B8)
            : AppColors.textSecondary,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: isDark ? const Color(0xFF334155) : AppColors.border,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? const Color(0xFF1E293B)
            : AppColors.background,
        selectedColor: AppColors.primary.withValues(alpha: 0.12),
        labelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        side: BorderSide(
          color: isDark ? const Color(0xFF334155) : AppColors.border,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primary.withValues(alpha: 0.12),
        circularTrackColor: AppColors.primary.withValues(alpha: 0.12),
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? const Color(0xFF334155) : AppColors.border,
        thickness: 1,
        space: 1,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 64,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textMuted, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
              letterSpacing: -0.2,
            );
          }
          return const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
            letterSpacing: -0.2,
          );
        }),
      ),
    );
  }
}
