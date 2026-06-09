import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Tambahkan ini
import 'core/theme.dart';
import 'features/home_board/view/welcome_screen.dart';
import 'features/word_prediction/repository/prediction_repository.dart'; // Tambahkan ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menyalakan database Hive sebelum UI digambar
  await PredictionRepository.initDatabase();

  // Bungkus MyApp dengan ProviderScope agar Riverpod bisa berjalan
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan bendera "DEBUG" di pojok kanan atas agar UI terlihat bersih
      debugShowCheckedModeBanner: false,
      
      title: 'JUBIR - Aplikasi Komunikasi Inklusif',
      
      // Menggunakan tema kustom (Opsi A: Kombinasi Abu/Biru Elegan & FAB Oranye)
      // Yang sudah kita perbaiki kontras teksnya untuk standar aksesibilitas IMK
      theme: AppTheme.lightTheme,
      
      // Halaman pertama yang muncul saat aplikasi dibuka (Layar Sapaan Minimalis)
      home: const WelcomeScreen(),
    );
  }
}