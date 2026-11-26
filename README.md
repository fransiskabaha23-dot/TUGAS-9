# Flutter To-Do (Provider)

Aplikasi mobile To-Do List sederhana yang memakai **Provider** (`ChangeNotifier`) sebagai state management.

## Fitur
- Login & Register lokal (simulasi) dengan `AuthProvider`, sesi tersimpan di perangkat (`shared_preferences`)
- Validasi form (email, password minimal 6 karakter, konfirmasi password)
- Logout dari bar atas
- Tambah, centang selesai, dan hapus tugas (geser ke kiri)
- Filter: Semua / Aktif / Selesai
- Hapus semua tugas yang selesai
- Penghitung tugas real-time

## Struktur
- `lib/models/task.dart` – model data
- `lib/providers/auth_provider.dart` – state login/register/logout
- `lib/providers/task_provider.dart` – state & logika (ChangeNotifier)
- `lib/screens/login_screen.dart`, `register_screen.dart` – layar autentikasi
- `lib/screens/home_screen.dart` – UI (`context.watch` / `context.read`)
- `lib/main.dart` – `MultiProvider` + `AuthGate` di root

## Menjalankan
```bash
flutter create .      # membuat folder android/ios (sekali saja)
flutter pub get
flutter run
```
