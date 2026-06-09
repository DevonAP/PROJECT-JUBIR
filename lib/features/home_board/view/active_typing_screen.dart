import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants.dart';
import '../../word_prediction/controller/prediction_controller.dart';
import '../../../features/tts_voice/controller/tts_controller.dart';

// Ubah menjadi ConsumerStatefulWidget agar bisa membaca Riverpod
class ActiveTypingScreen extends ConsumerStatefulWidget {
  final String? initialText;
  const ActiveTypingScreen({super.key, this.initialText});

  @override
  ConsumerState<ActiveTypingScreen> createState() => _ActiveTypingScreenState();
}

class _ActiveTypingScreenState extends ConsumerState<ActiveTypingScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    
    // 1. Ambil teks awal, jika tidak kosong dan belum ada spasi di ujungnya, tambahkan spasi secara otomatis
    String initialText = widget.initialText ?? "";
    if (initialText.isNotEmpty && !initialText.endsWith(" ")) {
      initialText = "$initialText ";
    }

    // 2. Masukkan teks yang sudah siap (ber-spasi) ke controller
    _textController = TextEditingController(text: initialText);

    // 3. Laporkan ke Riverpod sejak frame pertama agar prediksi langsung muncul
    if (initialText.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(inputTextProvider.notifier).updateText(initialText);
      });
    }

    // Listener keyboard bawaan untuk ketikan manual
    _textController.addListener(() {
      ref.read(inputTextProvider.notifier).updateText(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Fungsi saat tombol prediksi ditekan
  void _addWordToInput(String word) {
    final currentText = _textController.text;
    // Tambahkan kata baru dan beri spasi
    final newText = currentText.isEmpty ? "$word " : "$currentText$word ";
    
    _textController.text = newText;
    // Pindahkan kursor ke ujung kanan
    _textController.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));
  }

  @override
  Widget build(BuildContext context) {
    // Pantau daftar prediksi dari database secara live!
    final predictions = ref.watch(predictionListProvider);

    final inputText = ref.watch(inputTextProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ruang Bicara', style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. AREA TEKS UTAMA (Bukan TextField, hanya Tampilan)
            // ==========================================
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(AppSizes.p16),
                padding: const EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      // Teksnya sekarang membaca dari Riverpod, bukan teks statis lagi!
                      child: Text(
                        inputText.isEmpty 
                            ? "Ketik sesuatu..." 
                            : inputText,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: inputText.isEmpty 
                              ? AppColors.textSecondary // Abu-abu kalau kosong
                              : AppColors.textPrimary, // Gelap kalau ada isinya
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primary, // Sesuaikan warna tema kamu
                        onPressed: () {
                          // Ambil teks yang ada di Riverpod saat ini
                          final textToSpeak = ref.read(inputTextProvider);

                          // Panggil fitur suara AI untuk membacakannya
                          ref.read(ttsVoiceProvider).speak(textToSpeak);

                          _textController.clear();
                        },
                        child: const Icon(Icons.volume_up, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 2. GRID 6 TOMBOL PREDIKSI 
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p8),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: AppSizes.p8,
                crossAxisSpacing: AppSizes.p8,
                childAspectRatio: 2.5,
                children: [
                  // Loop 5 kata dari database (Data dummy Riverpod)
                  ...predictions.take(5).map((word) => _buildPredictionButton(word)),
                  // Tombol ke-6 khusus Backspace
                  _buildBackspaceButton(),
                ],
              ),
            ),

            // ==========================================
            // 3. AREA KEYBOARD (Input Fisik)
            // ==========================================
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: TextField(
                controller: _textController,
                autofocus: true, // Otomatis buka keyboard
                decoration: const InputDecoration(
                  hintText: "Ketik via keyboard...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN UNTUK TOMBOL ---

  Widget _buildPredictionButton(String word) {
    return ElevatedButton(
      onPressed: () => _addWordToInput(word),
      child: Text(word, overflow: TextOverflow.ellipsis), // ellipsis agar tidak luber
    );
  }

  Widget _buildBackspaceButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.backspaceBackground),
      onPressed: () {
        if (_textController.text.isNotEmpty) {
          // Bersihkan spasi di paling kanan terlebih dahulu untuk mendeteksi kata terakhir
          final currentText = _textController.text.trimRight();
          
          // Cari posisi spasi terakhir sebelum kata paling ujung
          final lastSpaceIndex = currentText.lastIndexOf(' ');
          
          if (lastSpaceIndex == -1) {
            // Jika tidak ada spasi sama sekali (artinya hanya tersisa 1 kata), langsung kosongkan
            _textController.clear();
          } else {
            // Potong kalimat sampai spasi terakhir tersebut, lalu beri spasi penutup lagi 
            // supaya fitur prediksi kata berikutnya langsung aktif kembali
            _textController.text = "${currentText.substring(0, lastSpaceIndex)} ";
          }
          
          // Selalu pastikan posisi kursor teks berada di paling kanan
          _textController.selection = TextSelection.fromPosition(
            TextPosition(offset: _textController.text.length),
          );
        }
      },
      child: const Icon(Icons.backspace_outlined, color: AppColors.textPrimary),
    );
  }
}