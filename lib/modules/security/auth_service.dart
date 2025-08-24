
import 'dart:convert';
import 'package:sandra_contab_erp/core/models/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';



class AuthService {
  static final Map<String, String> _users = {}; // email: password
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();


  // Método para simular el inicio de sesión
  Future<String?> login(String email, String password) async {
    Map<String, dynamic> valores = {
      'nombre': email,
      'clave': password,
    };

    final result = await _apiService.ejecutar(valores: valores, type: 2 );
    if (result.containsKey('msj') && result['msj'] != null) {
      return 'Fallo la conexion ${result['msj']}';
    }else if (result.containsKey('token') && result['token'] != null) {
      final token = result['token'];
      await _secureStorage.write(key: 'auth_token', value: token);
      await _secureStorage.write(key: 'auth_user', value: jsonEncode(valores));

      return token;
    }
  }

  // Método para verificar si el usuario ya tiene un token almacenado
  Future<bool> hasToken() async {
    final token = await _secureStorage.read(key: 'auth_user');
    return token != null;
  }

  // Método para autenticación biométrica y validación del token
  Future<String?> authenticateWithBiometrics() async {
    bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
    if (!canCheckBiometrics) {
      throw Exception("Biometría no disponible en este dispositivo.");

    }

    bool authenticated = false;
    try {
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Inicia sesión con tu huella dactilar para acceder a la aplicación',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      throw Exception('Error en la autenticación biométrica: $e');
    }

    if (authenticated) {
      try {
        final userJson = await _secureStorage.read(key: 'auth_user');
        if (userJson != null) {
          final usr = jsonDecode(userJson);
          final nombre = usr['nombre']?.toString() ?? '';
          final clave = usr['clave']?.toString() ?? '';


          final tk = await login(nombre, clave);
          return tk;
        }else{
          throw Exception("Autenticación biométrica fallida.");
        }

      } catch (e) {
        throw Exception("Autenticación biométrica fallida.");
      }
    } else {

      throw Exception("Autenticación biométrica fallida.");
    }
  }


  // Método para cerrar la sesión
  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}