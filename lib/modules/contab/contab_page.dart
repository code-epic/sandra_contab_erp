import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_acciones.dart';
import 'package:go_router/go_router.dart';

class ContabPage extends StatefulWidget {
  const ContabPage({super.key});
  @override
  State<ContabPage> createState() => _ContabPage();
}

class _ContabPage extends State<ContabPage> {

  final  List<ActionItem> misAcciones = [
    ActionItem(
      icon:  PhosphorIcons.graph(),
      label: 'Plan de cuentas',
      detail: 'Catálogo jerárquico de cuentas contables que permite clasificar y registrar toda operación...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/cplan'),
    ),
    ActionItem(
      icon:  PhosphorIcons.files(),
      label: 'Facturas',
      detail: 'Documento mercantil que refleja la información de una operación de compraventa y respaldo fiscal...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/cfacturas'),
    ),
    ActionItem(
      icon:  PhosphorIcons.strategy(),
      label: 'Comprobantes',
      detail: 'Evidencia contable de cada asiento: ingresos, egresos, diarios, ajustes y traslados...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/ccomprobante'),
    ),
    ActionItem(
      icon: PhosphorIcons.arrowsInLineHorizontal(),
      label: 'Cierre contable',
      detail: 'Proceso de cierre de período: regularización, amortización, depreciación y determinación de resultados...',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push( '/ccierre'),
    ),
    ActionItem(
      icon: PhosphorIcons.flowArrow(),
      label: 'Dinámica contable',
      detail: 'Análisis en tiempo real de indicadores financieros, flujo de caja y proyecciones...',
      color: AppColors.purpleSoftmax,
      onTap:(context) => context.push('/cdinamica'),
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
            const Text('Contabilidad'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [
              IconButton(
                tooltip: 'Reportes Financieros',
                icon: Icon(PhosphorIcons.scales()),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Reportes financieros')),
                  );
                },
              ),
              IconButton(
                tooltip: 'Configuración',
                icon: Icon(PhosphorIcons.gear()),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Configuración')),
                  );
                },
              ),
            ],
          ),
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

