class WordModel {
  final String word;
  final int frequency;
  final bool isSignLanguage;

  WordModel({
    required this.word,
    required this.frequency,
    this.isSignLanguage = false,
  });

  // Konstruktor untuk mengubah data Map dari Hive menjadi Objek WordModel
  factory WordModel.fromMap(Map<dynamic, dynamic> map) {
    return WordModel(
      word: map['word'] as String? ?? '',
      frequency: map['frequency'] as int? ?? 0,
      isSignLanguage: map['isSignLanguage'] as bool? ?? false,
    );
  }

  // Fungsi untuk mengubah Objek WordModel menjadi Map saat mau disimpan ke Hive
  Map<String, dynamic> toMap() {
    return {
      'word': word,
      'frequency': frequency,
      'isSignLanguage': isSignLanguage,
    };
  }
}