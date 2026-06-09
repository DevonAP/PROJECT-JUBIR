import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. Ganti flutter_riverpod menjadi provider
import 'core/theme.dart';
import 'features/home_board/view/welcome_screen.dart';
import 'features/word_prediction/repository/prediction_repository.dart';
import 'features/word_prediction/controller/prediction_controller.dart'; // 2. Tambahkan import controller prediksi
import 'features/tts_voice/controller/tts_controller.dart'; // 3. Tambahkan import controller suara/TTS

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Menyalakan database lokal Hive AI sebelum UI digambar
  await PredictionRepository.initDatabase();

  // 4. Bungkus aplikasi dengan MultiProvider agar data prediksi bisa diakses di semua halaman
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PredictionController(),
        ),
        ChangeNotifierProvider(
          create: (_) => TtsController(), // Menyesuaikan controller suara Anda
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Menghilangkan bendera "DEBUG" di pojok kanan atas agar UI terlihat bersih
      debugShowCheckedModeBanner: false,
      
      title: 'JUBIR - Aplikasi Komunikasi Inklusif',
      
      // Menggunakan tema kustom asli Anda yang ramah standar aksesibilitas IMK
      theme: AppTheme.lightTheme,
      
      // Halaman pertama yang muncul saat aplikasi dibuka (Layar Sapaan Minimalis Anda)
      home: const WelcomeScreen(),
    );
  }
}