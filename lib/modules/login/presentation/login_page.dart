import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sandra_contab_erp/modules/security/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';


import '../../../core/theme/app_color.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }


  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _localAuth.canCheckBiometrics;
    } catch (e) {
      print("Error al verificar biometría: $e");
    }
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isLoading = true;
      });
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Inicia sesión con tu huella dactilar',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      print("Error de autenticación biométrica: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (authenticated) {
      // Aquí manejarías el inicio de sesión exitoso. Por ejemplo:
      // await _authService.loginWithBiometrics();
      _showSnackBar('¡Inicio de sesión con huella dactilar exitoso!');
      context.push('/home');
    } else {
      _showSnackBar('Autenticación con huella dactilar fallida.', isError: true);
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String? errorMessage = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (errorMessage == null) {
        _showSnackBar('¡Inicio de sesión exitoso!');
        context.push('/home');
      } else {
        _showSnackBar(errorMessage, isError: true);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    final String? errorMessage = await _authService.signInWithGoogle();
    setState(() {
      _isLoading = false;
    });
    if (errorMessage == null) {
      _showSnackBar('¡Inicio de sesión con Google exitoso!');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackBar(errorMessage, isError: true);
    }
  }

  Future<void> _signInWithGitHub() async {
    setState(() {
      _isLoading = true;
    });
    final String? errorMessage = await _authService.signInWithGitHub();
    setState(() {
      _isLoading = false;
    });
    if (errorMessage == null) {
      _showSnackBar('¡Inicio de sesión con GitHub exitoso!');
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      _showSnackBar(errorMessage, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              AppColors.softGrey,
              AppColors.electric,
            ],
          ),
        ),
          child: Center (
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // Max width for web
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24.0),
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(assetPath('sandra.png')),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(1), // borde delicado
                          width: 2.4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 14,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(
                      'Bienvenido',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Sandra Contab App',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.blueGrey[600],
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Correo Electrónico',
                              hintText: 'tu@ejemplo.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide.none, // Ocultar el borde
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.4)), // Borde más suave
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0), // Borde resaltado al enfocar
                              ),
                              prefixIcon: const Icon(Icons.email, color: AppColors.lightSlate), // Icono más claro
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2), // Fondo semi-transparente
                              labelStyle: const TextStyle(color: Colors.blueGrey),
                              hintStyle: const TextStyle(color: Colors.white60),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu correo electrónico.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Contraseña',
                              hintText: 'Introduce tu contraseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none, // Ocultar el borde
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.4)), // Borde más suave
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0), // Borde resaltado al enfocar
                              ),
                              prefixIcon: const Icon(Icons.key, color: AppColors.lightSlate), // Icono más claro
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2), // Fondo semi-transparente
                              labelStyle: const TextStyle(color: Colors.blueGrey),
                              hintStyle: const TextStyle(color: Colors.white60),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor, ingresa tu contraseña.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32.0),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.vividNavy.withOpacity(0.1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 5,
                              ),
                              child: Text(
                                'Iniciar Sesión',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 52.0),

                    if (_canCheckBiometrics) ...[
                      const SizedBox(height: 24.0),
                      Text(
                        'O usa tu huella dactilar',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _buildBiometricLoginButton(),
                      ),
                    ],

                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }

  Widget _buildSocialLoginButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: OutlinedButton.icon(
          onPressed: _isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: BorderSide(color: AppColors.paleBlue.withOpacity(0.5)),
          ),
          icon: Icon(icon, color:  AppColors.paleBlue),
          label: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.cloud,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricLoginButton() {
    return ElevatedButton.icon(
      onPressed: _isLoading ? null : _authenticateWithBiometrics,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.vividNavy.withOpacity(0.1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
      icon: const Icon(Icons.fingerprint, color: Colors.white),
      label: const Text(
        'Acceder con Huella Dactilar',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}