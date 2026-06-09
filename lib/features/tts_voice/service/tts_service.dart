import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    
    // Seting bahasa ke Indonesia (id-ID)
    await _flutterTts.setLanguage("id-ID");
    
    // Kecepatan bicara (0.0 sampai 1.0) -> 0.5 adalah kecepatan normal
    await _flutterTts.setSpeechRate(0.5);
    
    // Tinggi nada suara (0.5 sampai 2.0) -> 1.0 adalah nada normal
    await _flutterTts.setPitch(1.0);
    
    // Mulai bersuara!
    await _flutterTts.speak(text);
  }
}