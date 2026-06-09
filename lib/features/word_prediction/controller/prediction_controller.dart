import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repository/prediction_repository.dart';

// Bagian ini WAJIB ada di Riverpod Generator. 
// Nama file harus sama dengan nama file aslinya, lalu ditambah '.g.dart'
part 'prediction_controller.g.dart';

// 1. Pengganti predictionRepoProvider yang lama
@riverpod
PredictionRepository predictionRepo(Ref ref) {
  return PredictionRepository();
}

// 2. Pengganti inputTextProvider (StateProvider) yang lama
// Di Riverpod modern, StateProvider diubah menjadi class Notifier
@riverpod
class InputText extends _$InputText {
  @override
  String build() {
    return ""; // Nilai awal (initial state)
  }

  // Method untuk mengubah isi teksnya nanti di UI
  void updateText(String newText) {
    state = newText;
  }
}

// 3. Pengganti predictionListProvider yang lama (Provider Pintar)
@riverpod
List<String> predictionList(Ref ref) {
  // Menonton repo dan text menggunakan nama fungsi/class yang digenerate otomatis
  final repo = ref.watch(predictionRepoProvider);
  final text = ref.watch(inputTextProvider);

  if (text.isEmpty) {
    // Jika belum ngetik apa-apa, munculkan kata dasar ini
    return ["saya", "kamu", "mau", "tolong", "sakit"]; 
  }

  // Ambil kata terakhir yang baru saja diketik
  final words = text.trim().split(' ');
  final lastWord = words.isNotEmpty ? words.last : "";

  // Minta prediksi ke database Hive berdasarkan kata terakhir
  return repo.getPredictions(lastWord);
}