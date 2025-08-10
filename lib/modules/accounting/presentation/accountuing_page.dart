import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import '../../../core/theme/app_color.dart';

class AccountingPage extends StatelessWidget {
  const AccountingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bienvenido'),
          automaticallyImplyLeading: false, // Oculta la flecha de retroceso
          backgroundColor: AppColors.subtleBlue,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.pop(context, '/login');
              },
            ),
          ],
        ),
        body:

        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.pureWhite,
                AppColors.pureWhite,
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 28.0),
                Text(
                  '¡Has iniciado sesión!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                Text(
                  'La contabilidad en tus manos.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blueGrey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),




        )
    );
  }
}