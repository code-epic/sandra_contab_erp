import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_theme.dart';
import 'package:sandra_contab_erp/shared/router/app_router.dart';
// import 'package:go_router/go_router.dart'
const String kHasCompletedOnboarding = 'has_completed_onboarding';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SandraContabApp());
}

class SandraContabApp extends StatelessWidget {
  const SandraContabApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sandra Contabilidad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,   // ✅ único punto de entrada
    );
  }

}
