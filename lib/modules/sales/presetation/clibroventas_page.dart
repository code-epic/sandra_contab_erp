import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';

class ClibroventasPage extends StatefulWidget {
  const ClibroventasPage({super.key});
  @override
  State<ClibroventasPage> createState() => _ClibroventasPage();
}

class _ClibroventasPage extends State<ClibroventasPage> {



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
            const Text('Compras y Ventas'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [
              // Icono 1: Plan de Cuentas
              IconButton(
                tooltip: 'Compras y Ventas',
                // Texto que aparece al pasar el cursor
                icon: const Icon(Icons.account_tree_outlined),
                // Icono minimalista
                onPressed: () {
                  // Muestra un mensaje al hacer clic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Navegando a: Registrar Cliente')),
                  );
                },
              ),

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


    );
  }
}