# Galeri Pengukuran Performa (Screenshots)

Folder ini disiapkan untuk menampung bukti otentik (screenshot DevTools/Performance Overlay) dari pengujian aplikasi pada kondisi **Before** dan **After**.

> **PENTING UNTUK DEVELOPER:**
> Agen asisten AI (saya) tidak dapat menjalankan aplikasi Flutter di emulator dan membuka web browser DevTools secara fisik untuk mengambil screenshot. Oleh karena itu, pengisian screenshot di bawah ini **WAJIB** dilakukan secara manual oleh Anda (pemilik repo) demi menjaga keaslian data. **Jangan pernah memalsukan gambar.**

## Instruksi Pengisian Manual

Silakan jalankan aplikasi dengan `flutter run --profile`, hubungkan ke DevTools, lakukan pengujian di setiap layar, lalu ambil screenshot dari tab Performance/Memory di DevTools.
Simpan gambar-gambar tersebut tepat di folder ini (menimpa file yang mungkin ada, atau cukup tambahkan jika belum ada) dengan penamaan yang ketat berikut:

### 1. Kasus Excessive Rebuilds
- `case-1-rebuild-before.png`: Tampilkan frame render merah di UI atau Timeline DevTools saat menekan tombol increment.
- `case-1-rebuild-after.png`: Tampilkan frame render yang mulus/hijau saat menekan tombol increment versi builder.

### 2. Kasus Expensive ListView
- `case-2-listview-before.png`: Screenshot UI "Initial Build Time" yang sangat tinggi.
- `case-2-listview-after.png`: Screenshot UI "Initial Build Time" yang rendah.

### 3. Kasus Unoptimized Images
- `case-3-image-before.png`: Screenshot tab *Memory* di DevTools yang menunjukkan lonjakan heap size tinggi.
- `case-3-image-after.png`: Screenshot tab *Memory* di DevTools yang menunjukkan penggunaan RAM landai/stabil.

### 4. Kasus Heavy Build Method
- `case-4-build-before.png`: Screenshot UI "Time spent in build" berwarna merah.
- `case-4-build-after.png`: Screenshot UI "Time spent in build" berwarna hijau (0 ms).

### 5. Kasus Expensive Widgets
- `case-5-widgets-before.png`: Screenshot "Raster time" yang tebal/melebihi budget akibat `saveLayer`.
- `case-5-widgets-after.png`: Screenshot "Raster time" yang hijau dan tipis.

### 6. Kasus Missing Debounce
- `case-6-debounce-before.png`: Screenshot UI "Total API Calls" berwarna merah (>10) setelah mengetik panjang.
- `case-6-debounce-after.png`: Screenshot UI "Total API Calls" berwarna hijau (1) untuk kalimat yang sama.

### 7. Kasus Animation Jank
- `case-7-animation-before.png`: Screenshot Timeline DevTools berdarah/jank selama animasi berputar.
- `case-7-animation-after.png`: Screenshot Timeline DevTools mulus selama animasi berputar.

---
**Catatan:** Anda tidak harus mengisi semuanya sekaligus saat ini. Anda dapat membuat PR baru di masa depan (misal branch `wahyu/measurement-results`) khusus untuk meng-upload file-file gambar ini.
