import 'package:flutter/material.dart';

class MeasurementGuideScreen extends StatelessWidget {
  const MeasurementGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cara Reproduksi Pengukuran')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          Text(
            'Langkah Mengukur Performa Flutter',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _StepTile(
            title: '1. Gunakan Profile Mode',
            description: 
              'Selalu jalankan aplikasi dalam mode profile (bukan debug) untuk pengukuran riil:\n'
              '`flutter run --profile`\n\n'
              'Debug mode lambat karena JIT compiler, sedangkan Profile menggunakan AOT namun tetap mempertahankan metrik profil.',
          ),
          _StepTile(
            title: '2. Aktifkan Performance Overlay',
            description: 
              'Tekan tombol "p" (huruf kecil) di terminal `flutter run` untuk memunculkan grafik GPU dan UI di layar. '
              'Atau aktifkan dari Flutter DevTools.',
          ),
          _StepTile(
            title: '3. Gunakan Flutter DevTools',
            description: 
              'Buka link DevTools yang muncul di terminal (contoh: http://127.0.0.1:9100). '
              'Buka tab "Performance" -> centang "Enhance Tracing" -> klik tombol "Record".\n'
              'Berinteraksilah dengan aplikasi, lalu klik "Stop" untuk melihat frame mana yang melebihi batas 16ms (60fps).',
          ),
          _StepTile(
            title: '4. Memory Profiling (Untuk Kasus Image)',
            description: 
              'Gunakan tab "Memory" di DevTools untuk melihat total alokasi heap dari aplikasi sebelum dan sesudah optimasi gambar.',
          ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  final String title;
  final String description;

  const _StepTile({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(description, style: const TextStyle(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
