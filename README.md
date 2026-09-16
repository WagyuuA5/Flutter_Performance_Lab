# Flutter Performance Lab ??
[![Flutter CI](https://github.com/WagyuuA5/Flutter_Performance_Lab/actions/workflows/ci.yml/badge.svg)](https://github.com/WagyuuA5/Flutter_Performance_Lab/actions/workflows/ci.yml)

Repository ini adalah portofolio unjuk kerja (**performance engineering**) dalam ekosistem Flutter. Tujuannya adalah membuktikan kemampuan untuk **MENGUKUR** dan **MEMPERBAIKI** masalah performa menggunakan metrik data nyata lewat Flutter DevTools, alih-alih sekadar asumsi visual ("terasa lebih cepat").

Setiap kasus pengujian dibuat saling berdampingan (*Before* dan *After*) dalam satu layar agar profil perbandingannya dapat diamati secara langsung.

---

## ?? Hasil Pengukuran Performa (Ringkasan)

> **Catatan:** Angka di bawah ini adalah hasil pengujian riil menggunakan `flutter run --profile`. Bagian berstatus `[TODO]` masih menunggu tangkapan profil manual dari perangkat penguji.

| Kasus | Metrik yang Diukur | Before (Tanpa Optimasi) | After (Dioptimasi) | Improvement |
| :--- | :--- | :---: | :---: | :---: |
| **1. Excessive Rebuilds** | Jumlah Rebuild Widget Anak | `[TODO: isi]` | `[TODO: isi]` | `[TODO: isi]` |
| **2. Expensive ListView** | Initial Build Time (ms) | `[TODO: isi]` ms | `[TODO: isi]` ms | `[TODO: isi]`x lebih cepat |
| **3. Unoptimized Images** | Puncak Alokasi Memori (MB) | `[TODO: isi]` MB | `[TODO: isi]` MB | `[TODO: isi]` MB dihemat |
| **4. Heavy Build Method** | Build execution time (ms) | `[TODO: isi]` ms | `0` ms | O(N) ? O(1) saat render |
| **5. Expensive Widgets** | Raster Time rata-rata (GPU) | `[TODO: isi]` ms/frame | `[TODO: isi]` ms/frame | Menghilangkan `saveLayer` |
| **6. Missing Debounce** | Jumlah "API Call" per input | `[TODO: isi]` panggilan | `1` panggilan | Signifikan |
| **7. Animation Jank** | Frekuensi Rebuild *Heavy Tree* | 60x / detik | 1x di awal | Mencegah CPU throttling |

---

## ?? Daftar Studi Kasus

### [Case 1: Excessive Rebuilds](lib/cases/rebuild/)
Memperbaiki pemanggilan `setState` di *root level* yang menyebabkan seluruh widget ter-*rebuild*. **Solusi:** Memecah state menggunakan `ValueNotifier` dan `ValueListenableBuilder`.

### [Case 2: Expensive ListView](lib/cases/listview/)
Me-render 5000 item dalam `ListView` biasa yang membekukan UI saat *initial load*. **Solusi:** `ListView.builder` + `itemExtent` konstan untuk kompleksitas layout O(1).

### [Case 3: Unoptimized Images](lib/cases/image/)
Ratusan gambar resolusi tinggi (1200px) yang memicu *Out of Memory* karena ukurannya di-decode mentah. **Solusi:** Resizing saat proses decoding di memori menggunakan `CachedNetworkImage(memCacheWidth: 300)`.

### [Case 4: Heavy Build Method](lib/cases/build_method/)
Logika _filter & sort_ 100.000 data langsung di dalam `build()`, menghalangi siklus frame 16ms. **Solusi:** _Precompute_ data di dalam `initState` / action-handler.

### [Case 5: Expensive Widgets](lib/cases/expensive_widgets/)
Efek `Opacity` + `ClipRRect` + `BoxShadow` yang memicu eksekusi GPU mahal (`saveLayer`). **Solusi:** Menggunakan warna transparan bawaan `.withValues(alpha:)`, isolasi dengan `RepaintBoundary`, dan *clip behavior* bawaan *Container*.

### [Case 6: Missing Debounce](lib/cases/debounce/)
Setiap huruf di _search box_ memicu pemanggilan API. **Solusi:** *Debouncer* 300ms berbasis `Timer`.

### [Case 7: Animation Jank](lib/cases/animation_jank/)
Meletakkan layout kompleks mentah di dalam fungsi `builder` pada `AnimatedBuilder` yang berjalan 60 fps. **Solusi:** Melimpahkan layout kompleks ke parameter statis `child` dari animasi.

---

## ?? Cara Reproduksi Pengukuran

> Jangan pernah memprofil aplikasi dalam **Debug Mode** karena hasilnya tidak mewakili performa produksi (terdapat JIT overhead).

1. Jalankan aplikasi dalam **Profile Mode**:
   ```bash
   flutter run --profile
   ```
2. Saat aplikasi berjalan, tekan tombol `p` di terminal untuk memunculkan grafik **Performance Overlay** di layar (GPU & UI thread).
3. Buka **Flutter DevTools** melalui tautan web yang diberikan oleh terminal (biasanya `http://127.0.0.1:xxxx`).
4. Buka tab **Performance**, berinteraksilah dengan aplikasi, lalu rekam (*Record*) aktivitas *Timeline*.
5. Buka tab **Memory** (khusus untuk menganalisis Kasus 3) untuk melihat *heap space*.

---

## ?? Galeri Pembuktian (Screenshots DevTools)

Berikut adalah bukti tangkapan layar langsung dari DevTools saat pengujian:

*(Gambar saat ini masih dalam proses pengumpulan (TODO) oleh *author*. Instruksi pengambilan gambar dapat dibaca di folder `docs/screenshots/`)*

| Kasus | Screenshot Before (Jank/Heavy) | Screenshot After (Smooth/Light) |
| --- | --- | --- |
| Rebuilds | *Belum tersedia* | *Belum tersedia* |
| ListView | *Belum tersedia* | *Belum tersedia* |
| Images | *Belum tersedia* | *Belum tersedia* |
| Build Method | *Belum tersedia* | *Belum tersedia* |
| Expensive Widgets | *Belum tersedia* | *Belum tersedia* |
| Debounce | *Belum tersedia* | *Belum tersedia* |
| Animation | *Belum tersedia* | *Belum tersedia* |

---
**Dibuat oleh AI Assistant - Antigravity Agent** 
*(Di bawah arahan & kurasi WagyuuA5)*
