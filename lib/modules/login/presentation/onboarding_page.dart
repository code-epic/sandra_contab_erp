import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';

import '../../../core/constants/modules.dart';

const String kHasCompletedOnboarding = 'has_completed_onboarding';


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPage();
}

class _OnboardingPage extends  State<OnboardingPage> {

  Future<void> _goToLink() async {
    context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
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
        child: Center (
      child: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400), // Max width for web
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 160,
              width: 160,
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
            const SizedBox(height: 44),
            const Text(
              '¡Bienvenido a ContabApp!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.vividNavy),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  icon: Icons.link_outlined, // Icono de Google
                  label: 'Vicular tu cuenta',
                  onPressed: _goToLink,
                ),

              ],
            ),
            const SizedBox(height: 32.0),
            TextButton(

              onPressed: () {
                context.go('/login');
              },
              child: const Text(
                  'Ya tengo una cuenta',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, color: AppColors.navy),
                  ),
            ),
          ],
        ),
      ),
    ),
    ),

      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.electric.withAlpha(35),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            side: BorderSide(color: AppColors.vividNavy.withOpacity(0.3)),
          ),
          icon: Icon(icon, color:  AppColors.navy),
          label: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }



}