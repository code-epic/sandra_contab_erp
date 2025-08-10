
import 'package:email_validator/email_validator.dart';

class AuthService {
  static final Map<String, String> _users = {}; // email: password

  // Método para simular el inicio de sesión
  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula latencia de red

    if (!EmailValidator.validate(email)) {
      return 'Formato de correo electrónico inválido.';
    }

    print(_users.containsKey(email));

    // if (_users.containsKey(email)) {

      if (email == password) {
        return null;
      } else {
        return 'Contraseña incorrecta.';
      }
    // } else {
    //   return 'Usuario no registrado.';
    // }
  }

  // Método para simular el registro
  Future<String?> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Simula latencia de red

    if (!EmailValidator.validate(email)) {
      return 'Formato de correo electrónico inválido.';
    }

    if (password.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres.';
    }

    if (_users.containsKey(email)) {
      return 'Este correo electrónico ya está registrado.';
    }

    // Simulación de guardado de usuario (en memoria)
    _users[email] = password;
    return null; // Registro exitoso
  }

  // Simulación de login con Google
  Future<String?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 2));
    // En una app real, aquí iría la lógica de Firebase/Google Sign-In
    print('Simulando inicio de sesión con Google...');
    return null; // Simula éxito
  }

  // Simulación de login con GitHub
  Future<String?> signInWithGitHub() async {
    await Future.delayed(const Duration(seconds: 2));
    // En una app real, aquí iría la lógica de Firebase/GitHub Sign-In
    print('Simulando inicio de sesión con GitHub...');
    return null; // Simula éxito
  }
}