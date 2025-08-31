import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
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
      icon: PhosphorIcons.userPlus(),
      label: 'Registrar cliente',
      detail: 'Alta maestra de empresas con datos fiscales, contacto, líneas de crédito y documentación legal...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clregistro'),
    ),
    ActionItem(
      icon: PhosphorIcons.folderUser(),
      label: 'Saldos clientes',
      detail: 'Estado de cuenta consolidado: facturas pendientes, pagos recibidos, notas de crédito y antigüedad de saldos...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clsaldos'),
    ),
    ActionItem(
      icon: PhosphorIcons.userGear(),
      label: 'Configurar cuentas',
      detail: 'Asignación de cuentas contables por cliente, términos de pago, impuestos y parámetros de facturación...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clconfiguracion'),
    ),
    ActionItem(
      icon: PhosphorIcons.binary(),
      label: 'Score de clientes',
      detail: 'Evaluación crediticia automatizada basada en historial de pago, antigüedad y comportamiento financiero...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clscore'),
    ),
    ActionItem(
      icon: PhosphorIcons.radioactive(),
      label: 'Clientes en riesgo',
      detail: 'Alertas tempranas de morosidad, análisis de tendencias y acciones preventivas para recuperación de cartera...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clriesgo'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: AppColors.vividNavy,
        backgroundColor: AppColors.softGrey,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.house()),
              color: AppColors.vividNavy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => context.go('/home'),
            ),
            const Text('Clientes'),
          ],
        ),
        actions: <Widget>[


        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 150.0, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AccionesContablesCard(items: misAcciones),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const FloatingNavBar(),
    );
  }


}

