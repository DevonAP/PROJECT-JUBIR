// file: lib/features/word_prediction/controller/prediction_controller.dart

import 'package:flutter/material.dart';
import '../repository/prediction_repository.dart';

class PredictionController extends ChangeNotifier {
  final PredictionRepository _repo = PredictionRepository();

  String _inputText = "";
  String get inputText => _inputText;

  List<String> _predictions = ["saya", "kamu", "mau", "tolong", "sakit"];
  List<String> get predictions => _predictions;

  void updateText(String newText) {
    // Logika Belajar dari Spasi Keyboard (Otomatis mengirim kalimat utuh)
    if (newText.endsWith(" ") && !_inputText.endsWith(" ") && newText.trim().isNotEmpty) {
      final words = newText.trim().split(RegExp(r'\s+'));
      _repo.learnRelationContext(words);
    }

    _inputText = newText;
    _updatePredictions();
    notifyListeners();
  }

  void _updatePredictions() {
    if (_inputText.trim().isEmpty) {
      _predictions = ["saya", "kamu", "mau", "tolong", "sakit"];
      return;
    }

    // Pisahkan teks menjadi array kata
    final words = _inputText.trim().split(RegExp(r'\s+'));
    
    // Minta prediksi dari AI Backoff Model
    final aiPredictions = _repo.getNextWordPrediction(words);
    
    if (aiPredictions.isNotEmpty) {
      _predictions = aiPredictions;
    } else {
      _predictions = []; 
    }
  }

  // Dipanggil oleh tombol prediksi di UI
  Future<void> learnFromButtonPress(String fullText) async {
    final words = fullText.trim().split(RegExp(r'\s+'));
    await _repo.learnRelationContext(words);
  }
}