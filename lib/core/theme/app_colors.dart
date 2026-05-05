import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color darkNavy = Color(0xFF0D1B2A);
  static const Color teal = Color(0xFF1B3B4A);
  static const Color lightMint = Color(0xFF00FF94);
  static const Color warmCoral = Color(0xFFF25067);

  // Secondary Colors
  static const Color lightGray = Color(0xFFF7F8FC);
  static const Color mediumGray = Color(0xFFE5ECFB);
  static const Color borderGray = Color(0xFFE2E8F0);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGray = Color(0xFF64748B);
  static const Color textLight = Color(0xFFF8FAFC);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color completed = Color(0xFF8B5CF6);

  // Gradients
  static const LinearGradient pageBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightGray, mediumGray],
  );

  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [darkNavy, teal],
  );
}
