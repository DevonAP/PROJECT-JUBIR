import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/home_board/view/welcome_screen.dart';

void main() {
  // Memastikan binding Flutter sudah siap sebelum aplikasi berjalan
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Nanti Anggota B akan menambahkan inisialisasi database Hive di sini, contoh:
  // await Hive.initFlutter();
  // await Hive.openBox('prediction_box');

  runApp(const MyApp());
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