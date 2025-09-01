import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/modules/accounting/presentation/accountuing_page.dart';
import 'package:sandra_contab_erp/modules/cliente/cliente_page.dart';
import 'package:sandra_contab_erp/modules/cliente/clregistro_page.dart';
import 'package:sandra_contab_erp/modules/cliente/clriesgo_page.dart';
import 'package:sandra_contab_erp/modules/cliente/clsaldos_page.dart';
import 'package:sandra_contab_erp/modules/cliente/clscore_page.dart';
import 'package:sandra_contab_erp/modules/contab/comprobante_page.dart';
import 'package:sandra_contab_erp/modules/contab/configuracion_page.dart';
import 'package:sandra_contab_erp/modules/contab/contab_page.dart';
import 'package:sandra_contab_erp/modules/sales/presetation/factura_page.dart';
import 'package:sandra_contab_erp/modules/contab/plan_page.dart';
import 'package:sandra_contab_erp/modules/contab/reportes_page.dart';
import 'package:sandra_contab_erp/modules/home/explorador_page.dart';
import 'package:sandra_contab_erp/modules/login/presentation/login_page.dart';
import 'package:sandra_contab_erp/modules/login/presentation/registration_page.dart';
import 'package:sandra_contab_erp/modules/home/home_page.dart';
import 'package:sandra_contab_erp/modules/login/presentation/registration_step_2.dart';

import 'package:sandra_contab_erp/modules/login/presentation/onboarding_page.dart';
import 'package:sandra_contab_erp/modules/login/presentation/registration_step_3.dart';
import 'package:sandra_contab_erp/modules/sales/presetation/clibrocompras_page.dart';
import 'package:sandra_contab_erp/modules/sales/presetation/clibroventas_page.dart';
import 'package:sandra_contab_erp/modules/sales/presetation/sales_page.dart';
import 'package:sandra_contab_erp/shared/widgets/app_shell.dart';

import '../../modules/contab/dinamica_page.dart';



final List<RouteBase> appRoutes = [
    GoRoute(
      path: '/',
      builder: (_, __) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (_, __) => const RegistrationPage(),
    ),
    GoRoute(
      path: '/registration_step_2',
      builder: (_, __) => const RegistrationStep2Page(),
    ),
    GoRoute(
      path: '/registration_step_3',
      builder: (_, __) => const RegistrationStep3Page(),

    ),
    // ShellRoute for pages that should have the common AppShell (with navbar)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(path: '/explorador', builder: (_, __) => const ExploradorPage()),
        GoRoute(path: '/accounting', builder: (_, __) => const AccountingPage()),

        GoRoute(path: '/contab', builder: (_, __) => const ContabPage()),

        GoRoute(path: '/cplan', builder: (_, __) => const PlanPage()),
        GoRoute(path: '/ccomprobante', builder: (_, __) => const ComprobantePage()),
        GoRoute(path: '/creportes', builder: (_, __) => const ReportesPage()),
        GoRoute(path: '/cdinamica', builder: (_, __) => const DinamicaPage()),
        GoRoute(path: '/cconfiguracion', builder: (_, __) => const ConfiguracionPage()),

        GoRoute(path: '/cliente', builder: (_, __) => const ClientePage()),
        GoRoute(path: '/clregistro', builder: (_, __) => const ClregistroPage()),
        GoRoute(path: '/clriesgo', builder: (_, __) => const ClriesgoPage()),
        GoRoute(path: '/clsaldos', builder: (_, __) => const ClsaldosPage()),
        GoRoute(path: '/clscore', builder: (_, __) => const ClscorePage()),

        GoRoute(path: '/sales', builder: (_, __) => const SalesPage()),
        GoRoute(path: '/factura', builder: (_, __) => const FacturaPage()),
        GoRoute(path: '/clibroventas', builder: (_, __) => const ClibroventasPage()),
        GoRoute(path: '/clibrocompras', builder: (_, __) => const ClibrocomprasPage()),
      ],
    ),
  ];

class AppRouter {
  static final router = GoRouter(
    routes: [

    ],
  );
}
