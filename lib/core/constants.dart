import 'package:flutter/material.dart';

class AppColors {
  // Warna Latar Belakang & Area Utama
  static const Color background = Color(0xFFF0F4F8); // Biru pastel sangat lembut (Calming)
  static const Color surface = Colors.white; // Putih bersih untuk area teks utama
  
  // Warna Aksi & Interaksi (FAB)
  static const Color primary = Color(0xFFFF6B35); // Oranye cerah/kontras tinggi untuk tombol Suarakan
  
  // Warna Tombol Prediksi & Backspace
  static const Color predictionBackground = Color(0xFFE2E8F0); // Biru-abu muda untuk tombol prediksi
  static const Color backspaceBackground = Color(0xFFCBD5E1); // Abu-abu netral untuk tombol backspace
  
  // Warna Teks (SUDAH DIPERBAIKI UNTUK AKSESIBILITAS IMK)
  static const Color textPrimary = Color(0xFF0F172A); // Hitam kebiruan pekat (Bukan putih!) agar kontras
  static const Color textSecondary = Color(0xFF64748B); // Abu-abu gelap untuk teks petunjuk (hint)
}

class AppSizes {
  // Standar Padding & Margin (Berdasarkan grid 8pt)
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;

  // Ukuran Lengkungan Sudut (Border Radius)
  static const double radiusM = 12.0; // Untuk tombol prediksi
  static const double radiusL = 24.0; // Untuk area teks utama

  // Ukuran Ikon
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
}