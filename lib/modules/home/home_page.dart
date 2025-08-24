import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_carousel.dart';

import '../security/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        foregroundColor: AppColors.softGrey,
        backgroundColor: AppColors.vividNavy,
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu_open),
              color: AppColors.paleBlue,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => {},
            ),
            const Text('ContabApp'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              // Botón para subir archivos
              IconButton(
                tooltip: 'Cerrar Sesión',
                icon: const Icon(Icons.logout),
                onPressed: () {
                  _authService.logout();
                  context.go('/login');
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: Container(
        child: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 15,bottom: 10, left: 8, right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConceptsCarousel(),
                SizedBox(height: 16.0),
                SizedBox(height: 16.0),
                SystemMessagesCard(),
                SizedBox(height: 24.0),
                Text(
                  '   Historial de Transacciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                TransactionsTable(),
                SizedBox(height: 24.0),
              ],
            ),
          )
        ),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.tealPop,
        onPressed: () {
          context.push('/clregistro');
        },
        child: const Icon(Icons.add_business, color:AppColors.softGrey),
      ),
    );
  }
}


// Widget para la tarjeta de mensajes del sistema
class SystemMessagesCard extends StatelessWidget {
  const SystemMessagesCard({super.key});

  final List<String> systemMessages = const [
    'Nómina de Mayo procesada con éxito.',
    'Nuevo cliente agregado: Soluciones Z.',
    'Actualización de seguridad aplicada.',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(.98),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mensajes del Sistema',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...systemMessages.map(
                  (message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('• $message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Nuevo widget para la tabla de transacciones
class TransactionsTable extends StatelessWidget {
  const TransactionsTable({super.key});

  final List<Map<String, String>> transactions = const [
    {'descripcion': 'Pago de proveedor X', 'monto': '-\$500.00'},
    {'descripcion': 'Venta a cliente Y',  'monto': '+\$1,200.00'},
    {'descripcion': 'Compra de insumos',  'monto': '-\$150.00'},
    {'descripcion': 'Venta a cliente Z', 'monto': '+\$750.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(.98),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('DESCRIPCION', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('MONTO', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: transactions.map((transaction) {
            return DataRow(
              cells: [
                DataCell(Text(transaction['descripcion']!)),
                DataCell(Text(transaction['monto']!)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
