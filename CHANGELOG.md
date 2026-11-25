# Belajar Mandarin (HSK 1–4) — Catatan Perubahan

App: satu file `index.html` + `manifest.webmanifest` + `sw.js` (PWA).
Patch dijalankan lewat `patch.js` (Node) atau `patch.ps1` (PowerShell) pada `C:\Users\User\Downloads\mandarin\index.html`.

> Status berdasarkan pengecekan `index.html` yang diunggah (172 KB): semua patch P1–P10 terdeteksi sudah masuk (mis. `setGoal`, `xpgoal`, `checkStreakMilestone`, set nada baru `飞肥废废`, `ETY.filter`).

---

## Status 10 Fitur

| # | Fitur | Status | Bukti di kode |
|---|-------|--------|---------------|
| 1 | Latihan menulis hanzi (animasi goresan + kanvas) | ✅ Ada | `HanziWriter`, `canvas`, fungsi `wr` |
| 2 | Latihan nada (dengar → tebak 1–4) | ✅ Ada + **diperluas** | menu "Latihan Nada", `tnA`, `tnr`, array `TN` |
| 3 | Latihan ngomong (Web Speech API) | ✅ Ada | `SpeechRecognition`, menu "Latihan Bicara", "Ucapkan" |
| 4 | Toggle pinyin/hanzi | ✅ Ada | fungsi `pin` |
| 5 | Tes penempatan level (10 soal) | ✅ Ada | "Tes Penempatan" |
| 6 | Pengingat harian + target XP | ✅ Ada + **ditingkatkan** | `Notification`, "Pengingat", `xpgoal`, `setGoal` |
| 7 | Mnemonik & etimologi hanzi | ✅ Ada + **diperluas** | array `ETY`, fungsi `lety` |
| 8 | Mode offline (PWA) | ✅ Ada | `sw.js`, `manifest.webmanifest`, `serviceWorker`, `beforeinstallprompt`, "Mode Offline" |
| 9 | Simulasi HSK (waktu + skor) | ✅ Ada | "Simulasi HSK" |
| 10 | Bagikan progres (kartu) | ✅ Ada + **didesain ulang** | `cdraw`, `shr` |

---

## Daftar Perubahan Detail (patch.js)

### P1 — Tampilan streak & progres XP harian (`path()`)
- Streak ditampilkan besar dengan ikon api: 🔥 untuk streak ≥ 3, 🔥🔥 untuk ≥ 7.
- Menampilkan pangkat (`rk(st.xp)`) di sebelah kanan.
- Progress bar memakai target XP yang bisa diatur (`st.xpgoal`, default 30).
- Teks `Harian: x/target XP` dan pesan "🎉 Tercapai!" saat target terpenuhi.

### P2 — Pengaturan Target XP harian (UI)
- Tombol pilihan: **10, 20, 30, 50, 100 XP**, ditaruh sebelum pengaturan "Kecepatan audio".
- Pilihan aktif ditandai (`chip on`), default 30.

### P3 — Fungsi `setGoal(v)`
- Menyimpan `st.xpgoal`, memanggil `sv()` (simpan) lalu `draw()` (render ulang).

### P4 — Latihan nada diperluas
- Set `TN` bertambah dari 5 jadi **14** set (ditambah: fēi, xī, gāo, duō, kāi, hē, zhōng, gāng, tā).
- Catatan: beberapa set punya karakter ganda (mis. `飞肥废废`, `他踏塔踏`) dan `开皑凯铠` kurang tepat untuk nada 1–4. Disarankan diperiksa ulang bila ingin akurat 100%.

### P5 — Mnemonik/etimologi (`ETY`) diperluas
- Sekarang **30 entri** dwibahasa (ID + EN): 好 明 休 森 安 家 看 男 想 爱 妈 鸣 字 学 心 水 山 日 月 木 火 大 小 口 人 力 手 目 耳 土.
- Tiap entri: komponen + pinyin + penjelasan makna.

### P6 — `lety()` dengan kategori & layout baru
- Tab filter: **HSK 1 Dasar (20)**, **HSK 2–3 (10)**, **Semua (30)**.
- Kartu besar: hanzi 3.5rem di kiri, penjelasan di kanan; ketuk kartu untuk mendengar pelafalan (`say`).
- Mengikuti bahasa (`st.lang`: ID/EN).

### P7 — Kartu bagikan progres (`cdraw()`) didesain ulang
- Latar gelap `#15130E`, garis aksen merah di atas, hanzi 学 transparan sebagai watermark.
- Label "BELAJAR MANDARIN · HSK 1–4", judul "Progres Mandarin-ku" / "My Mandarin Progress".
- Lencana api + pangkat.
- Tiga statistik: streak, XP, jumlah kata hafal (level ≥ 3).
- Footer: `#BelajarMandarin` + tanggal (format id-ID).

### P8 — `checkStreakMilestone()`
- Notifikasi toast pada streak **3, 7, 14, 30, 60, 100** hari:
  - ≥ 30: 🏆 "Luar biasa!"
  - ≥ 7: 🔥 "Terus semangat!"
  - lainnya: ⭐ "Bagus!"

### P9 — Pemicu milestone di `gain()`
- Dipanggil saat hari berganti (`st.last!==t`) dan `st.streak>1`, sebelum `sv()`.

### P10 — i18n (EN)
- Tambah terjemahan: "Target XP harian" → "Daily XP Goal", "Harian:" → "Daily:".

---

## File PWA

### `sw.js` (cache `mandarin-v1`)
- `install` → `skipWaiting`, `activate` → `clients.claim`.
- Strategi **network-first**: fetch dulu, simpan salinan ke cache, jika offline pakai cache.
- Hanya menangani request GET.

### `manifest.webmanifest`
- Nama "Belajar Mandarin" (short: "Mandarin"), `display: standalone`, theme `#C4301A`, background `#F1EFE8`.
- Ikon SVG inline (hanzi 学 putih di kotak merah).

---

## Catatan / Saran Lanjutan
1. Jalankan `patch.js` hanya **sekali** (menjalankan ulang akan menampilkan "NOT FOUND" pada patch string-replace; P5–P7 memakai indeks dan bisa menimpa ulang).
2. Perbaiki set nada yang karakternya dobel atau tidak sesuai nada (lihat P4).
3. Ikon SVG data-URI kurang ideal untuk install di beberapa browser; sebaiknya tambah PNG 192×192 dan 512×512.
4. Naikkan versi cache (`mandarin-v2`) setiap rilis agar update sampai ke pengguna.
5. Notifikasi pengingat di web hanya andal saat app terbuka/terpasang; push sungguhan butuh server.

---

## Lanjutan (perbaikan dari bagian "Catatan / Saran")

File hasil ada di folder `mandarin/` (`index.html`, `sw.js`, `manifest.webmanifest`).

- **Set nada `TN` diperbaiki** (14 set, semua kini nada 1–4 yang valid): mā/má/mǎ/mà, bā/bá/bǎ/bà, shū/shú/shǔ/shù, yī/yí/yǐ/yì, tōng/tóng/tǒng/tòng, fēi/féi/fěi/fèi (飞肥匪废), xī/xí/xǐ/xì, chī/chí/chǐ/chì (吃迟尺赤), duō/duó/duǒ/duò, tāng/táng/tǎng/tàng (汤糖躺烫), chū/chú/chǔ/chù (出除楚处), fū/fú/fǔ/fù (夫扶府父), jī/jí/jǐ/jì (鸡集几记), xiān/xián/xiǎn/xiàn (先闲显现). Set bermasalah (`开皑凯铠`, `刚钢港杠`, `他踏塔踏`, `中虫肿众`, `喝河赫贺`, `高巢搞告`) dibuang.
- **Service worker**: cache dinaikkan ke `mandarin-v2`, dan saat `activate` cache lama otomatis dihapus.
- Pengecekan sintaks JavaScript di `index.html`: lolos tanpa error.

### Belum dikerjakan
- Ikon PNG 192×192 dan 512×512 untuk manifest (butuh font hanzi/gambar; ikon SVG yang ada tetap berfungsi).
- Pengujian langsung di browser (mikrofon, notifikasi, instal PWA).

---

## Revisi UI & Menulis Hanzi

### Emoji dihapus, diganti ikon garis sesuai tema
- Kartu "Alat Bantu" memakai ikon SVG garis (nada, pena, mikrofon, kompas, dokumen, bohlam, bagikan, ponsel) lewat CSS mask, warnanya mengikuti `currentColor` sehingga cocok dengan mode terang/gelap.
- Emoji di tombol (🔊 🎤 🔔 📲 📤 ✍️) diganti ikon garis; emoji teks (🔥 🏆 ⭐ 🎉 ⏱ 🔒 ▶) dihapus, termasuk di kartu bagikan (canvas) dan notifikasi milestone.
- Kunci terjemahan EN ikut disesuaikan agar versi Inggris tetap jalan.

### Menulis Hanzi dibuat ulang
- Penyebab sebelumnya: latihan hanya lewat HanziWriter dari CDN, jadi tanpa internet tidak ada kanvas sama sekali.
- Sekarang ada dua mode:
  - **Latihan**: kanvas gambar sendiri (mouse/sentuh/stylus), kotak dengan garis bantu, hanzi panduan samar. Tombol Hapus, Panduan (on/off), Selesai (+3 XP), Dengar, Lanjut. Berfungsi offline.
  - **Animasi**: urutan goresan dan kuis goresan lewat HanziWriter (butuh internet saat pertama dibuka; ada pesan jika gagal).
- Diuji di browser headless: menggambar menghasilkan goresan dan penghitung "Goresan: n" bertambah, tanpa error JavaScript.

### Koreksi
- Pengecekan sebelumnya menyatakan semua patch sudah masuk. Ternyata array `ETY` di `index.html` masih 12 entri lama, sehingga tab kategori Asal-usul Hanzi kosong sebagian. Sudah diganti dengan 30 entri dari `patch.js`; halaman kini menampilkan kartu (tab HSK 1 Dasar: 20).
