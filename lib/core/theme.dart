import 'package:flutter/material.dart';
import 'constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Latar belakang utama aplikasi
      scaffoldBackgroundColor: AppColors.background,
      
      // Palet warna bawaan
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),

      // Pengaturan Font & Teks
      // (Bisa diganti dengan GoogleFonts jika sudah ditambahkan di pubspec.yaml)
      textTheme: const TextTheme(
        // Teks untuk kalimat yang sedang diketik pengguna (Besar & Jelas)
        displaySmall: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          height: 1.2,
        ),
        // Teks untuk tulisan di dalam kotak prediksi
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary, // Menggunakan teks gelap (Perbaikan IMK)
        ),
      ),

      // Gaya bawaan untuk Tombol FAB (Speaker Oranye)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white, // Ikon speaker warna putih
        elevation: 4, // Drop shadow elegan
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
        ),
      ),

      // Gaya bawaan untuk tombol prediksi kata
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.predictionBackground,
          foregroundColor: AppColors.textPrimary,
          elevation: 0, // Flat design
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.p12, 
            horizontal: AppSizes.p16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
      ),

      // Menghilangkan efek gelombang (ripple) yang berlebihan untuk mengurangi gangguan visual
      splashColor: Colors.black.withOpacity(0.05),
      highlightColor: Colors.transparent,
    );
  }
}