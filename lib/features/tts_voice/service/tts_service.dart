// file: lib/features/tts_voice/service/tts_service.dart

import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    await _flutterTts.setLanguage("id-ID");
    
    // --- LOGIKA DETEKSI EMOSI ---
    String cleanText = text.trim();
    
    if (cleanText.endsWith("!")) {
      // MODE NGEGAS / MARAH (Bicara cepat, nada agak tinggi)
      await _flutterTts.setSpeechRate(0.7); 
      await _flutterTts.setPitch(1.3);
    } 
    else if (cleanText.endsWith("?")) {
      // MODE BERTANYA (Kecepatan normal, nada sedikit lebih tinggi)
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.1);
    } 
    else if (cleanText.endsWith("...")) {
      // MODE SEDIH / RAGU (Bicara lambat, nada rendah)
      await _flutterTts.setSpeechRate(0.3);
      await _flutterTts.setPitch(0.8);
    } 
    else {
      // MODE NORMAL (Titik biasa)
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);
    }
    // -----------------------------
    
    await _flutterTts.speak(cleanText);
  }
}