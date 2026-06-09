// file: lib/features/word_prediction/repository/prediction_repository.dart

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/ngram_model.dart'; 

class PredictionRepository {
  static const String _ngramBox = 'ngram_relations_box';
  static const String _dictBox = 'dictionary_box'; // Box khusus untuk kamus JSON

  /// Inisialisasi Database 
  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    final ngramBox = await Hive.openBox(_ngramBox);
    final dictBox = await Hive.openBox(_dictBox);

    // 1. MASUKKAN JSON SEBAGAI FILTER (SATPAM)
    if (dictBox.isEmpty) {
      try {
        final String jsonString = await rootBundle.loadString('assets/sibi_dictionary.json');
        final Map<String, dynamic> decodedData = jsonDecode(jsonString);
        final List<dynamic> kataDasarList = decodedData['katadasar'] ?? [];
        
        for (var word in kataDasarList) {
          if (word is String && word.isNotEmpty) {
            // Simpan kata ke box kamus (huruf kecil semua agar mudah dicek)
            dictBox.put(word.toLowerCase(), true); 
          }
        }
      } catch (e) {
        print("Error loading JSON: $e");
      }
    }

    // 2. SUNTIKAN DATA PRE-TRAINED N-GRAM
    if (ngramBox.isEmpty) {
      await _injectPreTrainedNgram(ngramBox);
    }
  }

  static Future<void> _injectPreTrainedNgram(Box box) async {
    final List<Map<String, dynamic>> baseKnowledge = [
      {"prev": "saya", "next": "mau", "freq": 100},
      {"prev": "saya", "next": "lapar", "freq": 90},
      {"prev": "saya", "next": "sakit", "freq": 80},
      {"prev": "mau", "next": "makan", "freq": 100},
      {"prev": "mau", "next": "minum", "freq": 90},
      {"prev": "mau", "next": "pulang", "freq": 85},
      {"prev": "mau", "next": "ke", "freq": 80},
      {"prev": "ke", "next": "kamar", "freq": 100},
      {"prev": "kamar", "next": "mandi", "freq": 100},
      {"prev": "kamar", "next": "tidur", "freq": 90},
      {"prev": "tolong", "next": "bantu", "freq": 100},
      {"prev": "terima", "next": "kasih", "freq": 100},
    ];

    for (var data in baseKnowledge) {
      final relationKey = "${data['prev']}_${data['next']}";
      final model = NgramRelation(
        previousWord: data['prev'],
        nextWord: data['next'],
        frequency: data['freq'],
      );
      await box.put(relationKey, model.toMap());
    }
  }

  /// FUNGSI AI BELAJAR RELASI BARU (DENGAN FILTER TYPO)
  Future<void> learnRelation(String previousWord, String currentWord) async {
    if (previousWord.isEmpty || currentWord.isEmpty) return;
    
    // --- LOGIKA SATPAM (FILTER TYPO) ---
    final dictBox = Hive.box(_dictBox);
    
    // Jika salah satu kata tidak ada di kamus JSON SIBI, langsung batalkan! (Abaikan typo)
    if (!dictBox.containsKey(previousWord.toLowerCase()) || 
        !dictBox.containsKey(currentWord.toLowerCase())) {
      return; 
    }
    // -----------------------------------

    // Jika kata valid, baru AI boleh menyimpannya/menaikkan frekuensinya
    final box = Hive.box(_ngramBox);
    final String relationKey = "${previousWord.toLowerCase()}_${currentWord.toLowerCase()}";
    
    final existingData = box.get(relationKey);
    
    if (existingData != null) {
      final model = NgramRelation.fromMap(existingData);
      final updatedModel = NgramRelation(
        previousWord: model.previousWord,
        nextWord: model.nextWord,
        frequency: model.frequency + 1, 
      );
      await box.put(relationKey, updatedModel.toMap());
    } else {
      final newModel = NgramRelation(
        previousWord: previousWord.toLowerCase(),
        nextWord: currentWord.toLowerCase(),
        frequency: 1,
      );
      await box.put(relationKey, newModel.toMap());
    }
  }

  /// FUNGSI AI MENGAMBIL PREDIKSI KATA SELANJUTNYA
  List<String> getNextWordPrediction(String lastWord) {
    if (lastWord.isEmpty) return [];

    final box = Hive.box(_ngramBox);
    List<NgramRelation> candidates = [];

    for (var value in box.values) {
      if (value is Map) {
        final model = NgramRelation.fromMap(value);
        if (model.previousWord == lastWord.toLowerCase()) {
          candidates.add(model);
        }
      }
    }

    candidates.sort((a, b) => b.frequency.compareTo(a.frequency));
    return candidates.map((e) => e.nextWord).take(5).toList();
  }
}