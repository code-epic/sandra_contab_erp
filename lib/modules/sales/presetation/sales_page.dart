import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_acciones.dart';
import 'package:go_router/go_router.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});
  @override
  State<SalesPage> createState() => _SalesPage();
}

class _SalesPage extends State<SalesPage> {


  final List<ActionItem> misAcciones = [
    ActionItem(
      icon: Icons.receipt_long,
      label: 'Facturas de compras',
      detail: 'Registro de facturas emitidas por proveedores, retención de IVA y control de créditos fiscales.',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/ccompras'),
    ),
    ActionItem(
      icon: Icons.point_of_sale,
      label: 'Facturas de ventas',
      detail: 'Registro de facturas emitidas a clientes, cálculo de IVA y retenciones aplicadas.',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/cventas'),
    ),
    ActionItem(
      icon: Icons.menu_book,
      label: 'Libro de Compras',
      detail: 'Generación automática del libro obligatorio ante SENIAT con todas las facturas de compras.',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clibrocompras'),
    ),
    ActionItem(
      icon: Icons.menu_book_outlined,
      label: 'Libro de Ventas',
      detail: 'Generación automática del libro obligatorio ante SENIAT con todas las facturas de ventas.',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/clibroventas'),
    ),
    ActionItem(
      icon: Icons.inventory_2,
      label: 'Gestión de inventarios',
      detail: 'Control de existencias, kardex valorizado y ajustes de inventario (opcional según necesidad).',
      color: AppColors.vividNavy,
      onTap: (context) => context.push('/cinventarios'),
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
              padding: EdgeInsets.zero,
              // quita padding extra
              constraints: const BoxConstraints(),
              // quita tamaño mínimo
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Compras y ventas'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [
              IconButton(
                tooltip: 'Reportes',
                icon: const Icon(Icons.bar_chart_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Navegando a: Reportes clientes')),
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