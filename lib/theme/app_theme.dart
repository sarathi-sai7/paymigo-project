import 'package:flutter/material.dart';

class AppColors {
  static const Color accent = Color(0xFFFF5500);
  static const Color accentSecondary = Color(0xFFFF8C00);
  static const Color background = Color(0xFFFAF9F7);
  static const Color surface = Color(0xFFF3F2EE);
  static const Color textPrimary = Color(0xFF0F0F0F);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color border = Color(0xFFE5E5E0);
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
  static const Color white = Color(0xFFFFFFFF);
}

class AppTextStyles {
  static const TextStyle displayBlack = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.05,
    letterSpacing: -1.5,
  );

  static const TextStyle headingBlack = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const TextStyle labelUppercase = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w900,
    color: AppColors.textSecondary,
    letterSpacing: 2.0,
    height: 1.0,
  );
}

class AppDecorations {
  static BoxDecoration glassCard = BoxDecoration(
    color: Colors.white.withOpacity(0.85),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: AppColors.border.withOpacity(0.8)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 40,
        offset: const Offset(0, 10),
      ),
    ],
  );

  static BoxDecoration bentoCard = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration accentButton = BoxDecoration(
    gradient: const LinearGradient(
      colors: [AppColors.accent, AppColors.accentSecondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.accent.withOpacity(0.35),
        blurRadius: 20,
        offset: const Offset(0, 8),
      ),
    ],
  );
}