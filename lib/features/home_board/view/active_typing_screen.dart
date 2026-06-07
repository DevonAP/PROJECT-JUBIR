import 'package:flutter/material.dart';
import '../../../core/constants.dart'; // Sesuaikan lokasi folder Anda

class ActiveTypingScreen extends StatelessWidget {
  const ActiveTypingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ruang Bicara',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Mengubah warna tombol back (panah kembali) menjadi gelap agar kontras
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      // SafeArea agar UI tidak tertutup poni (notch) HP
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. AREA TEKS UTAMA & TOMBOL SUARAKAN (FAB)
            // ==========================================
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(AppSizes.p16),
                padding: const EdgeInsets.all(AppSizes.p24),
                decoration: BoxDecoration(
                  color: AppColors.surface, // Warna putih bersih
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), // Bayangan lembut ala Dribbble
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teks Dummy (Nanti akan diganti dengan state Riverpod)
                    Expanded(
                      child: Text(
                        "Saya mau makan",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    // Tombol Speaker (FAB) diposisikan di kanan bawah area putih
                    // Dengan cara ini, FAB tidak akan pernah menutupi tulisan
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {
                          // TODO: Logika TTS (Suara AI) nanti di sini
                        },
                        child: const Icon(Icons.volume_up, size: AppSizes.iconLarge),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // 2. GRID 6 TOMBOL PREDIKSI (5 Kata + 1 Hapus)
            // ==========================================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.p16, 
                vertical: AppSizes.p8,
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Mematikan scroll karena statis
                crossAxisCount: 3, // 3 kolom
                mainAxisSpacing: AppSizes.p8,
                crossAxisSpacing: AppSizes.p8,
                childAspectRatio: 2.5, // Rasio lebar:tinggi tombol agar proporsional
                children: [
                  _buildPredictionButton("Nasi", context),
                  _buildPredictionButton("Sate", context),
                  _buildPredictionButton("Soto", context),
                  _buildPredictionButton("Goreng", context),
                  _buildPredictionButton("Ayam", context),
                  _buildBackspaceButton(), // Slot ke-6 khusus hapus
                ],
              ),
            ),

            // ==========================================
            // 3. AREA KEYBOARD (Input Teks Fisik)
            // ==========================================
            // Ini memancing keyboard HP standar untuk muncul
            Container(
              color: AppColors.surface,
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Ketik di sini...",
                  border: InputBorder.none, // Dibuat polos agar menyatu dengan layar
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BANTUAN UNTUK TOMBOL ---

  // Tombol untuk kata prediksi
  Widget _buildPredictionButton(String word, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO: Logika tambah kata ke kalimat utama
      },
      child: Text(word), // Teks akan otomatis mengikuti warna gelap di theme.dart
    );
  }

  // Tombol abu-abu khusus untuk Backspace
  Widget _buildBackspaceButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.backspaceBackground, // Warna abu-abu netral
      ),
      onPressed: () {
        // TODO: Logika hapus kata
      },
      child: const Icon(
        Icons.backspace_outlined, 
        color: AppColors.textPrimary, // Ikon warna gelap agar kontras
      ),
    );
  }
}