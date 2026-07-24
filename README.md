# Sapta Mutu — Leads Workspace

Dashboard internal buat tim sales PT Sapta Mutu Utama: nyimpen data lead, follow-up, produk/omzet, sampai monitoring tim. Satu file HTML (`leads-dashboard-prototype.html`) + database Supabase di belakangnya.

## Isi folder ini

**File utama (yang beneran dipakai):**

- `leads-dashboard-prototype.html` — aplikasinya. Buka di browser buat pakai.
- `README.md` — file ini.
- `panduan-alur-kerja-dan-roadmap-supabase.docx` — penjelasan konsep arsitektur (Cowork/GitHub/Vercel/Supabase) dan roadmap menuju launching.
- `catatan-perjalanan-leads-dashboard.docx` — catatan histori pengembangan.
- `alur_navigasi_leads_dashboard.png` / `.svg` — diagram alur navigasi aplikasi.

**File SQL (dijalankan di Supabase SQL Editor):** lihat bagian "Setup Supabase" di bawah.

**File lama, boleh diabaikan/dihapus** (sudah digantikan versi lebih baru, disimpan cuma buat jaga-jaga):

- `leads-dashboard-prototype-v1.html` sampai `-v5.html`
- `supabase-setup-tabel.sql`, `supabase-setup-profiles.sql`, `supabase-setup-rls.sql` (sudah digantikan `supabase-reset-dan-setup-lengkap.sql`)

## Setup Supabase (urutan dari nol)

Kalau harus setup ulang dari database kosong, jalankan file-file ini satu-satu di **SQL Editor** Supabase, sesuai urutan:

1. **Bikin 4 akun dulu** di Authentication → Users (email + password), baru lanjut ke SQL.
2. `supabase-reset-dan-setup-lengkap.sql` — bikin tabel `profiles`, `branches`, `leads`, `activity_log`, aturan keamanan (RLS), dan isi 4 profil (Master Admin, Super Admin, Supervisor, Sales). **Perlu disesuaikan dulu**: ganti UID di file ini sesuai UID akun Authentication yang baru dibikin.
3. `supabase-tambah-chatlog.sql` — nambah kolom "Chat Log" di tabel leads.
4. `supabase-tambah-changed-by.sql` — nambah kolom pencatat siapa yang mengubah tiap log aktivitas.
5. `supabase-tambah-monitoring-user.sql` — nambah kolom buat fitur Monitoring User (siapa aktif/diam/offline).
6. `supabase-tambah-photo-url.sql` — nambah kolom link foto profil.
7. `supabase-migrasi-leads-lama.sql` — isi data 33 lead asli (dari histori Airtable). Jalankan **sekali saja**, jangan diulang (bakal kedobel).
8. `supabase-tambah-akses-lead-milik-sendiri-supervisor.sql` — opsional, cuma perlu kalau Supervisor bikin lead atas nama dirinya sendiri.

Semua file di atas aman dijalankan ulang kapan pun (pakai `if not exists`), **kecuali** nomor 7 (migrasi data) yang bakal bikin data dobel kalau dijalankan dua kali.

## Peran & akses

| Role | Bisa lihat data siapa | Bisa kelola user | Bisa hapus lead |
|---|---|---|---|
| Master Admin | Semua | Semua, termasuk Super Admin | Ya |
| Super Admin | Semua kecuali Master Admin | Supervisor & Sales saja | Tidak |
| Supervisor | Dirinya + anggota tim yang ditugaskan | Tidak | Tidak |
| Sales | Cuma lead miliknya sendiri | Tidak | Tidak |

Login pakai email + password lewat Supabase Auth. Lupa password: hubungi Master Admin buat direset manual lewat Supabase Dashboard (bukan lewat aplikasi).

## Menu yang ada

- **Overview** — ringkasan harian, bisa disusun ulang urutan section-nya.
- **Leads** — daftar lengkap, bisa difilter, dikelompokkan per admin, dan diedit.
- **Follow up** — kalender & daftar rencana follow-up.
- **Log Aktivitas** — riwayat semua perubahan, siapa yang ngubah dan kapan.
- **Struktur Organisasi** — bagan tim, isinya beda-beda tergantung siapa yang login.
- **Perbandingan Kinerja** — sanding-sandingkan angka 2+ orang (Master, Super Admin, Supervisor).
- **Monitoring User** — siapa lagi aktif/diam/offline, khusus Master & Super Admin.
- **Kelola Pengguna** — atur role & tim (masih simulasi lokal, lihat bagian Keterbatasan).
- **Fokus tampilan** — Master Admin bisa mempersempit tampilan ke 1-2 orang tertentu, diinget lewat browser.

## Cara deploy (biar bisa diakses lewat link)

Paling cepat pakai **Vercel Drop**, gak perlu GitHub/command line:

1. Buka `vercel.com/drop`, login (akun gratis).
2. Drag file `leads-dashboard-prototype.html` ke halaman itu.
3. Kasih nama project, klik Deploy.
4. Kalau ditanya halaman utama, pilih file HTML-nya.
5. Dapat link hidup buat dibagiin ke tim.

Catatan: tiap kali file-nya diupdate, perlu di-drop ulang (bikin link baru). Buat update otomatis tiap ada perubahan, perlu disambungin ke GitHub — itu langkah lanjutan yang belum dikerjain.

## Keterbatasan yang masih ada

- **Kelola Pengguna masih simulasi** — nambah/edit user di menu itu belum bikin akun Supabase beneran (butuh Edge Function terpisah buat itu, belum dibangun). Bikin/nonaktifkan akun asli masih manual lewat Supabase Dashboard.
- **Import data JSON** cuma nampilin sementara di layar, belum tersimpan ke server (fitur lama, belum disambungin ke Supabase).
- **Foto profil** cuma nyimpen link (bukan upload file), jadi fotonya harus di-hosting di tempat lain dulu (misal Imgur) sebelum link-nya ditempel.
- Belum ada auto-deploy dari GitHub — tiap update kode masih manual (drag-drop ulang ke Vercel, atau lewat Cowork/Claude Code).
