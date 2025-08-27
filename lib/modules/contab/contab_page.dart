import 'package:flutter/material.dart';
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
      icon: Icons.account_tree_outlined,
      label: 'Plan de cuentas',
      detail: 'Catálogo jerárquico de cuentas contables que permite clasificar y registrar toda operación...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/cplan'),
    ),
    ActionItem(
      icon: Icons.receipt_long,
      label: 'Facturas',
      detail: 'Documento mercantil que refleja la información de una operación de compraventa y respaldo fiscal...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/cfacturas'),
    ),
    ActionItem(
      icon: Icons.edit_note,
      label: 'Comprobantes',
      detail: 'Evidencia contable de cada asiento: ingresos, egresos, diarios, ajustes y traslados...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/ccomprobante'),
    ),
    ActionItem(
      icon: Icons.calculate,
      label: 'Cierre contable',
      detail: 'Proceso de cierre de período: regularización, amortización, depreciación y determinación de resultados...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push( '/ccierre'),
    ),
    ActionItem(
      icon: Icons.print,
      label: 'Reportes',
      detail: 'Generación de balances, estados de resultados, auxiliares y libros legales en PDF o Excel...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push( '/creportes'),
    ),
    ActionItem(
      icon: Icons.auto_graph,
      label: 'Dinámica contable',
      detail: 'Análisis en tiempo real de indicadores financieros, flujo de caja y proyecciones...',
      color: AppColors.vividNavy,
      onTap:(context) => context.push('/cdinamica'),
    ),
    ActionItem(
      icon: Icons.settings,
      label: 'Configuración',
      detail: 'Ajustes de empresa, períodos, tipos de cambio, impuestos y permisos de usuario...',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/cconfiguracion'),
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
                onPressed: () => context.go('/home'),
              ),
              const Text('Contabilidad'),
            ],
          ),
          actions: <Widget>[

            Row(
              children: [
                // Icono 1: Plan de Cuentas
                IconButton(
                  tooltip: 'Plan de Cuentas', // Texto que aparece al pasar el cursor
                  icon: const Icon(Icons.account_tree_outlined), // Icono minimalista
                  onPressed: () {
                    // Muestra un mensaje al hacer clic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navegando a: Plan de Cuentas')),
                    );
                  },
                ),
                // Icono 2: Registro de asientos contables
                // IconButton(
                //   tooltip: 'Registro de Asientos',
                //   icon: const Icon(Icons.edit_note_outlined),
                //   onPressed: () {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Navegando a: Registro de Asientos')),
                //     );
                //   },
                // ),
                // Icono 3: Generación de Mayor y Auxiliares
                // IconButton(
                //   tooltip: 'Generación de Mayor',
                //   icon: const Icon(Icons.menu_book_outlined),
                //   onPressed: () {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Navegando a: Generación de Mayor y Auxiliares')),
                //     );
                //   },
                // ),
                // Icono 4: Cierre contable y ajustes
                // IconButton(
                //   tooltip: 'Cierre y Ajustes',
                //   icon: const Icon(Icons.lock_clock_outlined),
                //   onPressed: () {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text('Navegando a: Cierre contable y ajustes')),
                //     );
                //   },
                // ),
                // Icono 5: Reportes financieros básicos
                IconButton(
                  tooltip: 'Reportes Financieros',
                  icon: const Icon(Icons.bar_chart_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Navegando a: Reportes financieros')),
                    );
                  },
                ),
                // Icono 6: Un icono de ejemplo adicional si lo necesitas, por ejemplo, para configuración
                IconButton(
                  tooltip: 'Configuración',
                  icon: const Icon(Icons.settings_outlined),
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
        backgroundColor: Colors.white.withOpacity(.98),

        body: SingleChildScrollView(
          child: AccionesContablesCard(items: misAcciones),
        ),
    );
  }


}

