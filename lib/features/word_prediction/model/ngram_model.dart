// file: lib/features/word_prediction/model/ngram_model.dart

class NgramRelation {
  final String previousWord; // Konteks (Kata sebelumnya)
  final String nextWord;     // Prediksi (Kata selanjutnya)
  final int frequency;       // Bobot Probabilitas (Semakin sering = semakin diprioritaskan)

  NgramRelation({
    required this.previousWord,
    required this.nextWord,
    required this.frequency,
  });

  // Konversi dari Hive Map ke Objek
  factory NgramRelation.fromMap(Map<dynamic, dynamic> map) {
    return NgramRelation(
      previousWord: map['previousWord'] as String? ?? '',
      nextWord: map['nextWord'] as String? ?? '',
      frequency: map['frequency'] as int? ?? 0,
    );
  }

  // Konversi dari Objek ke Hive Map
  Map<String, dynamic> toMap() {
    return {
      'previousWord': previousWord,
      'nextWord': nextWord,
      'frequency': frequency,
    };
  }
}