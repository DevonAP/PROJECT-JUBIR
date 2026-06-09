import 'package:hive_flutter/hive_flutter.dart';

class PredictionRepository {
  static const String boxName = 'ngram_box';

  // 1. Inisialisasi Database Hive (Dipanggil sekali saat aplikasi dibuka)
  static Future<void> initDatabase() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
    
    // Masukkan data dummy jika database masih kosong
    final box = Hive.box(boxName);
    if (box.isEmpty) {
      await _seedDummyData(box);
    }
  }

  // 2. Fungsi untuk memanggil 5 prediksi kata berdasarkan kata terakhir
  List<String> getPredictions(String lastWord) {
    final box = Hive.box(boxName);
    final String key = lastWord.toLowerCase().trim();
    
    // Ambil prediksi dari database. Jika kata tidak ada, kembalikan kata dasar umum.
    final predictions = box.get(key, defaultValue: ["aku", "kamu", "mau", "itu", "ini"]);
    
    return List<String>.from(predictions);
  }

  // --- DUMMY DATA UNTUK MVP ---
  // Di versi final, data ini akan berisi ribuan kata hasil pembobotan N-Gram
  static Future<void> _seedDummyData(Box box) async {
    Map<String, List<String>> bigramData = {
      "saya": ["mau", "suka", "lapar", "sakit", "tolong"],
      "mau": ["makan", "minum", "pulang", "ke toilet", "istirahat"],
      "makan": ["nasi", "roti", "ayam", "sate", "soto"],
      "minum": ["air", "teh", "kopi", "susu", "obat"],
      "tolong": ["bantu", "ambilkan", "saya", "panggilkan", "buka"],
      "sakit": ["kepala", "perut", "gigi", "sekali", "dada"],
    };

    // Menyimpan semua kamus Bigram ke dalam database lokal Hive (Zero Latency)
    for (var entry in bigramData.entries) {
      await box.put(entry.key, entry.value);
    }
  }
}