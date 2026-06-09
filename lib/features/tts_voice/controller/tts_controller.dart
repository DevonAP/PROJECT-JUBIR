// file: lib/features/tts_voice/controller/tts_controller.dart

import 'package:flutter/material.dart';
import '../service/tts_service.dart';

class TtsController extends ChangeNotifier {
  final TtsService _ttsService = TtsService();

  // Fungsi yang akan dipanggil oleh tombol FAB di UI
  Future<void> speak(String text) async {
    await _ttsService.speak(text);
    
    // Jika ke depannya Anda butuh animasi "sedang bicara", 
    // Anda bisa menambahkan variabel boolean dan memanggil notifyListeners() di sini.
  }
}