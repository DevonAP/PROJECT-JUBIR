import 'package:flutter/material.dart';
import '../../../core/constants.dart';
import 'active_typing_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Controller untuk membaca atau membersihkan teks di inputan
  final TextEditingController _chatController = TextEditingController();

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  void _navigateToActiveScreen() {
    // Ambil teks yang sempat diketik user di depan
    final startingText = _chatController.text;
    Navigator.push(
      context,
      PageRouteBuilder(
        // KIRIMKAN teksnya ke parameter initialText di ActiveTypingScreen
        pageBuilder: (context, animation, secondaryAnimation) => ActiveTypingScreen(
          initialText: startingText,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ).then((_) {
      // BONUS UX: Saat user kembali ke WelcomeScreen nanti, kolom input di depan otomatis bersih
      _chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Latar biru pastel yang tenang
      appBar: AppBar(
        title: const Text(
          'JUBIR',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true, // Nama aplikasi di tengah agar simetris
        backgroundColor: Colors.transparent, // Transparan agar menyatu dengan background
        elevation: 0, // Menghilangkan garis bayangan kaku bawaan Flutter
      ),      
      body: SafeArea(
        child: Center(
          // SingleChildScrollView agar layout aman saat keyboard HP muncul menutupi layar
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ==========================================
                // 1. TEKS SAPAAN RAMAH
                // ==========================================
                Icon(
                  Icons.waving_hand_rounded,
                  size: 64,
                  color: AppColors.primary.withOpacity(0.8),
                ),
                const SizedBox(height: AppSizes.p24),
                Text(
                  "Halo,",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSizes.p8),
                Text(
                  "Ada yang ingin kamu sampaikan hari ini?",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: AppSizes.p32),

                // ==========================================
                // 2. KOLOM CHAT & TOMBOL KIRIM (DI TENGAH)
                // ==========================================
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                  decoration: BoxDecoration(
                    color: AppColors.surface, // Warna putih bersih
                    borderRadius: BorderRadius.circular(AppSizes.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Input teks asli (membuka keyboard saat di-tap)
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: "Ketik di sini...",
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      // Tombol Kirim berlambang panah
                      IconButton(
                        icon: const Icon(Icons.send_rounded),
                        color: AppColors.primary, // Warna oranye kontras tinggi
                        onPressed: () {
                          // Untuk sementara teksnya kita abaikan dulu sesuai request Anda,
                          // yang penting aksinya langsung memicu pindah halaman.
                          _navigateToActiveScreen();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}