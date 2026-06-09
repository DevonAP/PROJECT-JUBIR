// file: lib/features/word_prediction/controller/prediction_controller.dart

import 'package:flutter/material.dart';
import '../repository/prediction_repository.dart';

class PredictionController extends ChangeNotifier {
  final PredictionRepository _repo = PredictionRepository();

  // Menyimpan teks yang diketik pengguna
  String _inputText = "";
  String get inputText => _inputText;

  // Menyimpan daftar prediksi kata (default saat awal mulai)
  List<String> _predictions = ["saya", "kamu", "mau", "tolong", "sakit"];
  List<String> get predictions => _predictions;

  // Fungsi dipanggil setiap kali pengguna mengetik huruf baru
  void updateText(String newText) {
    // ==========================================
    // LOGIKA BARU: AI BELAJAR DARI KEYBOARD MANUAL
    // ==========================================
    // Kita cek apakah pengguna baru saja menekan 'spasi' (menyelesaikan satu kata)
    if (newText.endsWith(" ") && !_inputText.endsWith(" ") && newText.trim().isNotEmpty) {
      final words = newText.trim().split(' ');
      
      // Jika kalimat sudah terdiri dari minimal 2 kata, pelajari relasinya!
      if (words.length >= 2) {
        final prevWord = words[words.length - 2]; // Kata sebelumnya
        final currentWord = words.last; // Kata yang baru saja diselesaikan
        
        // Simpan diam-diam ke otak AI (Hive)
        learnUserHabit(prevWord, currentWord);
      }
    }

    _inputText = newText;
    _updatePredictions();
    notifyListeners(); // Update UI
  }
  
  // Otak untuk mencari prediksi selanjutnya
  void _updatePredictions() {
    if (_inputText.trim().isEmpty) {
      // Jika kosong, tampilkan saran kata awal
      _predictions = ["saya", "kamu", "mau", "tolong", "sakit"];
      return;
    }

    // Ambil kata terakhir yang diketik
    final words = _inputText.trim().split(' ');
    final lastWord = words.isNotEmpty ? words.last : "";

    // Minta AI (Hive) memprediksi kata selanjutnya berdasarkan kata terakhir
    final aiPredictions = _repo.getNextWordPrediction(lastWord);
    
    if (aiPredictions.isNotEmpty) {
      _predictions = aiPredictions;
    } else {
      _predictions = []; // Kosongkan jika AI belum punya data untuk kata tersebut
    }
  }

  // Fungsi untuk AI Belajar (Bisa Anda panggil di UI ketika user menekan tombol "Spasi")
  Future<void> learnUserHabit(String previousWord, String currentWord) async {
    await _repo.learnRelation(previousWord, currentWord);
  }

  
}