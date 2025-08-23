import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Almacenamiento seguro + preferencias locales
/// Uso:
///   await Storage.init();  // una sola vez
///   Storage.instance.setSandraDone(true);
class StorageJob {
  StorageJob._();
  static final instance = StorageJob._();

  static const _kOnboardingDone = 'sandra_done';

  late final SharedPreferences _prefs;
  late final FlutterSecureStorage _secure;

  /// Inicializa ambos almacenes de forma segura
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _secure = const FlutterSecureStorage();
    } catch (e) {
      // Aquí puedes loggear o lanzar un error controlado
      rethrow;
    }
  }

  // ---------- SharedPreferences ----------
  bool get onboardingDone => _prefs.getBool(_kOnboardingDone) ?? false;
  Future<bool> setOnboardingDone(bool value) =>
      _prefs.setBool(_kOnboardingDone, value);

  String? getString(String key) => _prefs.getString(key);
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  // ---------- Secure Storage ----------
  Future<void> saveJWT(String key, String token) =>
      _secure.write(key: key, value: token);

  Future<String?> getJWT(String key) => _secure.read(key: key);

  Future<void> deleteJWT(String key) => _secure.delete(key: key);
}