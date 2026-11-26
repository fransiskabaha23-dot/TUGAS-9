import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Login lokal (simulasi): akun disimpan di perangkat via SharedPreferences.
/// Catatan: password disimpan apa adanya hanya untuk keperluan simulasi/belajar.
class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'users';
  static const _sessionKey = 'session_email';

  late SharedPreferences _prefs;
  Map<String, Map<String, String>> _users = {};
  String? _currentEmail;
  bool _isLoading = false;

  bool get isLoggedIn => _currentEmail != null;
  bool get isLoading => _isLoading;
  String get userName =>
      _currentEmail == null ? '' : (_users[_currentEmail]?['name'] ?? '');

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs.getString(_usersKey);
    if (raw != null) {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      _users = decoded.map(
        (k, v) => MapEntry(k, Map<String, String>.from(v as Map)),
      );
    }
    final session = _prefs.getString(_sessionKey);
    if (session != null && _users.containsKey(session)) {
      _currentEmail = session;
    }
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  Future<String?> register(String name, String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));
    final key = email.trim().toLowerCase();
    if (_users.containsKey(key)) {
      _setLoading(false);
      return 'Email sudah terdaftar';
    }
    _users[key] = {'name': name.trim(), 'password': password};
    await _prefs.setString(_usersKey, jsonEncode(_users));
    await _prefs.setString(_sessionKey, key);
    _currentEmail = key;
    _setLoading(false);
    return null;
  }

  /// Mengembalikan pesan error, atau null jika berhasil.
  Future<String?> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 600));
    final key = email.trim().toLowerCase();
    final user = _users[key];
    if (user == null || user['password'] != password) {
      _setLoading(false);
      return 'Email atau password salah';
    }
    await _prefs.setString(_sessionKey, key);
    _currentEmail = key;
    _setLoading(false);
    return null;
  }

  Future<void> logout() async {
    await _prefs.remove(_sessionKey);
    _currentEmail = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
