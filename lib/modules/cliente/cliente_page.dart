import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_acciones.dart';
import 'package:go_router/go_router.dart';

class ClientePage extends StatefulWidget {
  const ClientePage({super.key});
  @override
  State<ClientePage> createState() => _ClientePage();
}

class _ClientePage extends State<ClientePage> {

  final List<ActionItem> misAcciones = [
    ActionItem(
      icon: Icons.person_add_alt_1,
      label: 'Registrar cliente',
      detail: 'Alta maestra de empresas con datos fiscales, contacto, líneas de crédito y documentación legal...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clregistro'),
    ),
    ActionItem(
      icon: Icons.account_balance_wallet,
      label: 'Saldos clientes',
      detail: 'Estado de cuenta consolidado: facturas pendientes, pagos recibidos, notas de crédito y antigüedad de saldos...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clsaldos'),
    ),
    ActionItem(
      icon: Icons.account_tree,
      label: 'Configurar cuentas',
      detail: 'Asignación de cuentas contables por cliente, términos de pago, impuestos y parámetros de facturación...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clconfiguracion'),
    ),
    ActionItem(
      icon: Icons.score,
      label: 'Score de clientes',
      detail: 'Evaluación crediticia automatizada basada en historial de pago, antigüedad y comportamiento financiero...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clscore'),
    ),
    ActionItem(
      icon: Icons.warning_amber,
      label: 'Clientes en riesgo',
      detail: 'Alertas tempranas de morosidad, análisis de tendencias y acciones preventivas para recuperación de cartera...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clriesgo'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.softGrey,
        backgroundColor: AppColors.vividNavy,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppColors.paleBlue,
              padding: EdgeInsets.zero,   // quita padding extra
              constraints: const BoxConstraints(), // quita tamaño mínimo
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Clientes'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [
              // Icono 1: Plan de Cuentas
              IconButton(
                tooltip: 'Clientes', // Texto que aparece al pasar el cursor
                icon: const Icon(Icons.account_tree_outlined), // Icono minimalista
                onPressed: () {
                  // Muestra un mensaje al hacer clic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Registrar Cliente')),
                  );
                },
              ),

              IconButton(
                tooltip: 'Reportes',
                icon: const Icon(Icons.bar_chart_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Reportes clientes')),
                  );
                },
              ),
              // Icono 6: Un icono de ejemplo adicional si lo necesitas, por ejemplo, para configuración
              IconButton(
                tooltip: 'Configuración',
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Configurando')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(.98),

      body: SingleChildScrollView(
        child: AccionesContablesCard(items: misAcciones),
      ),
    );
  }


}

