// file: lib/features/word_prediction/repository/prediction_repository.dart

import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class PredictionRepository {
  static const String _ngramBox = 'ngram_relations_box';
  static const String _dictBox = 'dictionary_box';

  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    final ngramBox = await Hive.openBox(_ngramBox);
    final dictBox = await Hive.openBox(_dictBox);

    // 1. Kamus Filter Typo[cite: 1]
    if (dictBox.isEmpty) {
      try {
        final String jsonString = await rootBundle.loadString('assets/sibi_dictionary.json');
        final Map<String, dynamic> decodedData = jsonDecode(jsonString);
        final List<dynamic> kataDasarList = decodedData['katadasar'] ?? [];
        
        for (var word in kataDasarList) {
          if (word is String && word.isNotEmpty) {
            dictBox.put(word.toLowerCase(), true); 
          }
        }
      } catch (e) {
        // Abaikan error saat build awal
      }
    }

    // 2. Pre-Trained Knowledge (O(1) Data Structure)
    if (ngramBox.isEmpty) {
      await _injectPreTrainedNgram(ngramBox);
    }
  }

  static Future<void> _injectPreTrainedNgram(Box box) async {
    try {
      // 1. Baca file JSON asli dari folder assets
      final String jsonString = await rootBundle.loadString('assets/pretrained_ngram.json');
      
      // 2. Decode JSON tersebut menjadi Map (Kamus)
      final Map<String, dynamic> baseKnowledge = jsonDecode(jsonString);

      // 3. Masukkan datanya ke dalam Hive Database secara instan
      for (var entry in baseKnowledge.entries) {
        // Kita masukkan key (misal: "saya_mau") dan valuenya (list prediksinya)
        await box.put(entry.key, entry.value);
      }
      
      print("SUKSES: Dataset N-Gram berhasil disuntikkan! Jumlah konteks: ${baseKnowledge.length}");
    } catch (e) {
      print("GAGAL memuat dataset N-Gram: $e");
    }
  }

  /// FUNGSI AI BELAJAR (MENDUKUNG TRIGRAM & BIGRAM)
  Future<void> learnRelationContext(List<String> words) async {
    if (words.length < 2) return;

    final dictBox = Hive.box(_dictBox);
    String target = words.last.toLowerCase();
    String prev1 = words[words.length - 2].toLowerCase();

    // Validasi Typo: Pastikan kata ada di kamus
    if (!dictBox.containsKey(target) || !dictBox.containsKey(prev1)) return;

    // 1. Simpan Bigram (1 Kata -> Target)
    await _saveNgram(prev1, target);

    // 2. Simpan Trigram (2 Kata -> Target)
    if (words.length >= 3) {
      String prev2 = words[words.length - 3].toLowerCase();
      if (dictBox.containsKey(prev2)) {
        await _saveNgram("${prev2}_$prev1", target);
      }
    }
  }

  /// CORE LOGIC O(1) SAVING 
  Future<void> _saveNgram(String contextKey, String targetWord) async {
    final box = Hive.box(_ngramBox);
    
    // Ambil list prediksi yang sudah ada untuk konteks ini (O(1) Lookup)
    List<dynamic> rawList = box.get(contextKey, defaultValue: []);
    
    // Konversi ke format yang bisa diedit
    List<Map<String, dynamic>> predictions = rawList.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    bool found = false;
    for (int i = 0; i < predictions.length; i++) {
      if (predictions[i]['word'] == targetWord) {
        predictions[i]['freq'] = (predictions[i]['freq'] as int) + 1; // Naikkan frekuensi
        found = true;
        break;
      }
    }

    if (!found) {
      // Jika kata baru, tambahkan ke list
      predictions.add({'word': targetWord, 'freq': 1});
    }

    // Trik Mahadewa: Urutkan list SAAT DISIMPAN, bukan saat dibaca.
    // Ini membuat proses membaca (Prediksi) menjadi 0.000 milidetik!
    predictions.sort((a, b) => (b['freq'] as int).compareTo(a['freq'] as int));

    // Simpan kembali ke Hive
    await box.put(contextKey, predictions);
  }

  /// FUNGSI PREDIKSI KATZ'S BACKOFF (O(1) RETRIEVAL)
  List<String> getNextWordPrediction(List<String> words) {
    if (words.isEmpty) return [];

    final box = Hive.box(_ngramBox);
    String prev1 = words.last.toLowerCase();
    
    Set<String> finalPredictions = {}; // Set agar tidak ada kata duplikat

    // 1. Cek Trigram (Instan O(1))
    if (words.length >= 2) {
      String prev2 = words[words.length - 2].toLowerCase();
      String trigramContext = "${prev2}_$prev1";
      
      List<dynamic> trigramData = box.get(trigramContext, defaultValue: []);
      for (var item in trigramData) {
        finalPredictions.add(item['word'] as String);
      }
    }

    // 2. Cek Bigram (Instan O(1)) - Backoff jika Trigram tidak cukup
    if (finalPredictions.length < 6) {
      List<dynamic> bigramData = box.get(prev1, defaultValue: []);
      for (var item in bigramData) {
        finalPredictions.add(item['word'] as String);
        if (finalPredictions.length >= 6) break; // Berhenti jika sudah dapat 6 kata
      }
    }

    return finalPredictions.toList();
  }
}