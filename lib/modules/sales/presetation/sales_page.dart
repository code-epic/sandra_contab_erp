import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_acciones.dart';
import 'package:go_router/go_router.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});
  @override
  State<SalesPage> createState() => _SalesPage();
}

class _SalesPage extends State<SalesPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  final List<ActionItem> misAcciones = [
    ActionItem(
      icon: PhosphorIcons.files(),
      label: 'Facturas: Compra / Venta',
      detail: 'Registro de facturas emitidas por proveedores, retención de IVA y control de créditos fiscales.',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/ccompras'),
    ),
    ActionItem(
      icon: PhosphorIcons.bookOpen(),
      label: 'Libro de Compras',
      detail: 'Generación automática del libro obligatorio ante SENIAT con todas las facturas de compras.',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clibrocompras'),
    ),
    ActionItem(
      icon: PhosphorIcons.bookOpenText(),
      label: 'Libro de Ventas',
      detail: 'Generación automática del libro obligatorio ante SENIAT con todas las facturas de ventas.',
      color: AppColors.purpleSoftmax,
      onTap: (context) => context.push('/clibroventas'),
    ),

  ];


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    // Inicia la animación al cargar la página
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


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
            const Text('Compras y ventas'),
          ],
        ),
        actions: <Widget>[


        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: FadeTransition(
        opacity: _animation,
        child: SingleChildScrollView(
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
      ),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }
}