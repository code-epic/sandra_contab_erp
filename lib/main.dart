import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/core/theme/app_theme.dart';
import 'package:sandra_contab_erp/shared/router/app_router.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart'; // Importa tu ScanProvider


import 'core/models/storage_job.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageJob.instance.init();

  final bool skipOnboarding = StorageJob.instance.onboardingDone;
  runApp(SandraContabApp(initial: skipOnboarding ? '/login' : '/'));
}

class SandraContabApp extends StatelessWidget {
  final String initial;
  const SandraContabApp({required this.initial, super.key});


  @override
  Widget build(BuildContext context) {
    return
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ScanProvider()), // Agrega tu ScanProvider
            // Puedes agregar más providers aquí
          ],
          child : MaterialApp.router(
                  title: 'Sandra Contabilidad',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light(),
                  routerConfig: GoRouter(
                    initialLocation: initial,
                    routes: appRoutes,
                  ),
                ),
          );
  }
}
