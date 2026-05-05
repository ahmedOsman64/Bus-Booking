import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.darkNavy,
        height: 1.3,
      );

  static TextStyle get h2 => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.darkNavy,
        height: 1.3,
      );

  static TextStyle get h3 => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
        height: 1.4,
      );

  static TextStyle get h4 => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColors.textDark,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
        height: 1.5,
      );

  static TextStyle get bodyRegular => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textDark,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textGray,
        height: 1.4,
      );

  static TextStyle get buttonText => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
        height: 1.2,
      );

  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textGray,
        height: 1.4,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: AppColors.textGray,
        height: 1.3,
      );
}
