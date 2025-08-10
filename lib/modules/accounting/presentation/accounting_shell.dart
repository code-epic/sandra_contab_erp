import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/shared/widgets/navbar.dart';

class AccountingShell extends StatelessWidget {
  const AccountingShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Navbar(title: 'Contabilidad'),
      body: const Center(child: Text('Módulo Contabilidad – Pronto más')),
    );
  }
}
