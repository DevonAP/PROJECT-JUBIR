import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants.dart';
import '../../word_prediction/controller/prediction_controller.dart';
import '../../../features/tts_voice/controller/tts_controller.dart';

class ActiveTypingScreen extends StatefulWidget {
  final String? initialText;
  const ActiveTypingScreen({super.key, this.initialText});

  @override
  State<ActiveTypingScreen> createState() => _ActiveTypingScreenState();
}

class _ActiveTypingScreenState extends State<ActiveTypingScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    
    String initialText = widget.initialText ?? "";
    if (initialText.isNotEmpty && !initialText.endsWith(" ")) {
      initialText = "$initialText ";
    }

    _textController = TextEditingController(text: initialText);

    if (initialText.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<PredictionController>().updateText(initialText);
      });
    }

    _textController.addListener(() {
      context.read<PredictionController>().updateText(_textController.text);
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addWordToInput(String word) {
    final currentText = _textController.text;
    final newText = currentText.isEmpty ? "$word " : "$currentText$word ";
    
    _textController.text = newText;
    _textController.selection = TextSelection.fromPosition(TextPosition(offset: newText.length));

    final words = newText.trim().split(' ');
    if (words.length >= 2) {
      final prevWord = words[words.length - 2]; 
      final currentWord = words[words.length - 1]; 
      
      context.read<PredictionController>().learnUserHabit(prevWord, currentWord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final predictionCtrl = context.watch<PredictionController>();
    final predictions = predictionCtrl.predictions;
    final inputText = predictionCtrl.inputText;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'JUBIR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. AREA TEKS UTAMA 
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
                      child: Text(
                        inputText.isEmpty 
                            ? "Ketik sesuatu..." 
                            : inputText,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: inputText.isEmpty 
                              ? AppColors.textSecondary 
                              : AppColors.textPrimary, 
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: AppColors.primary, 
                        onPressed: () {
                          final textToSpeak = context.read<PredictionController>().inputText;
                          context.read<TtsController>().speak(textToSpeak);
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
            // 2. GRID 6 TOMBOL PREDIKSI (HANYA KATA)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: AppSizes.p8,
                crossAxisSpacing: AppSizes.p8,
                childAspectRatio: 2.5,
                children: [
                  // Sekarang AI bisa memunculkan 6 kata sekaligus!
                  ...predictions.take(6).map((word) => _buildPredictionButton(word)),
                ],
              ),
            ),

            // ==========================================
            // 3. TOMBOL HAPUS KATA (STATIS DI BAWAH GRID)
            // ==========================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(AppSizes.p16, AppSizes.p8, AppSizes.p16, AppSizes.p8),
              child: _buildBackspaceButton(),
            ),

            // ==========================================
            // 4. AREA KEYBOARD
            // ==========================================
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: TextField(
                controller: _textController,
                autofocus: true, 
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
      child: Text(word, overflow: TextOverflow.ellipsis),
    );
  }

  Widget _buildBackspaceButton() {
    return SizedBox(
      height: 48, // Membuat tombol cukup besar untuk ditekan
      child: ElevatedButton.icon(
        // Sesuaikan warnanya dengan tema Anda (bisa abu-abu halus atau merah pudar)
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 255, 85, 85),
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
          ),
        ),
        onPressed: () {
          if (_textController.text.isNotEmpty) {
            final currentText = _textController.text.trimRight();
            final lastSpaceIndex = currentText.lastIndexOf(' ');
            
            if (lastSpaceIndex == -1) {
              _textController.clear();
            } else {
              _textController.text = "${currentText.substring(0, lastSpaceIndex)} ";
            }
            
            _textController.selection = TextSelection.fromPosition(
              TextPosition(offset: _textController.text.length),
            );
          }
        },
        icon: const Icon(Icons.backspace_outlined),
        label: const Text("Hapus Kata"),
      ),
    );
  }
}