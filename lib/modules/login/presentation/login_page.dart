import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import 'package:sandra_contab_erp/modules/security/auth_service.dart';
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
  bool _isLoading = true; // Iniciar en true para mostrar el indicador de carga
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isAuthenticatedWithToken = false; // Nuevo estado para verificar si hay un token

  @override
  void initState() {
    super.initState();
    _checkInitialState();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Nuevo método que agrupa las verificaciones iniciales
  Future<void> _checkInitialState() async {
    final hasToken = await _authService.hasToken();
    final canCheckBiometrics = await _localAuth.canCheckBiometrics;

    setState(() {
      _isAuthenticatedWithToken = hasToken;
      _canCheckBiometrics = canCheckBiometrics;
      _isLoading = false;
    });

  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final token = await _authService.authenticateWithBiometrics();

      if (token != null) {
        context.go('/home');
      }
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
      setState(() {
        _isAuthenticatedWithToken = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _authService.login(
          _emailController.text,
          _passwordController.text,
        );
        context.go('/home');
      } catch (e) {
        _showSnackBar(e.toString(), isError: true);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
              AppColors.tealPop,
              AppColors.softGrey,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
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
                        image: AssetImage(assetPath('job.png')),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(1),
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
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Muestra el widget de carga si está verificando el estado inicial
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                  // Lógica condicional para mostrar el formulario o solo el botón biométrico
                    if (_isAuthenticatedWithToken && _canCheckBiometrics)
                      Column(
                        children: [
                          const SizedBox(height: 16.0),
                          _buildBiometricLoginButton(),
                        ],
                      )
                    else
                      _buildTraditionalLoginForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBiometricLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _authenticateWithBiometrics,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tealPop.withOpacity(0.1),
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
      ),
    );
  }

  Widget _buildTraditionalLoginForm() {
    return Form(
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
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
              ),
              prefixIcon: const Icon(Icons.email, color: AppColors.lightSlate),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              labelStyle: const TextStyle(color: Colors.blueGrey),
              hintStyle: const TextStyle(color: Colors.white60),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Por favor, ingresa tu correo electrónico.';
              // }
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
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.lightBlue, width: 2.0),
              ),
              prefixIcon: const Icon(Icons.key, color: AppColors.lightSlate),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              labelStyle: const TextStyle(color: Colors.blueGrey),
              hintStyle: const TextStyle(color: Colors.white60),
            ),
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Por favor, ingresa tu contraseña.';
              // }
              return null;
            },
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealPop.withOpacity(0.2),
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
    );
  }
}