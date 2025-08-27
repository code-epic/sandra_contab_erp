// lib/shared/widgets/app_shell.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';


class AppShell extends StatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() => _currentIndex = index);
    context.go(KModuloSide[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 800;

    return Scaffold(
      body: Container(
        child: Row(
          children: [
            if (isDesktop) _buildRail(),
            Expanded(child: widget.child),
          ],
        ),
      ),
      // El Drawer solo se muestra en la versión móvil
      drawer: isDesktop ? null : _buildDrawer(),
    );
  }

  Widget _buildRail() {
    return NavigationRail(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onTap,
      destinations: KModuloSide
          .map((m) => NavigationRailDestination(
        icon: Icon(m.icon),
        label: Text(m.title),
      ))
          .toList(),
    );
  }

  // Se ha modificado esta función para un diseño más elegante
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Encabezado del Drawer con título y subtítulo
          // Encabezado del Drawer con título y subtítulo
          Container(
            padding: const EdgeInsets.fromLTRB(
              10, 54, 10, 24,
            ),
            color: AppColors.greenSoft,
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage(kIsWeb ? 'job.png' : 'assets/job.png'),
                      fit: BoxFit.cover,
                    ),
                    border: Border.all(
                      color: AppColors.greenSoft,
                      width: 2.4,
                    ),

                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ContabApp',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.vividNavy,
                        ),
                      ),
                      Text(
                        'Al alcance de tus manos',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.vividNavy,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon( // Icono de configuración al final del encabezado
                  PhosphorIcons.gear(),
                  color: AppColors.vividNavy,
                  size: 20.0,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          // Lista de elementos de navegación
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: KModuloSide
                  .asMap()
                  .entries
                  .map((e) => ListTile(
                leading: Icon(
                  e.value.icon,
                  color: AppColors.purpleSoftmax,
                  size: 22.0,
                ),
                title: Text(
                  e.value.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: AppColors.vividNavy,
                  ),
                ),
                selected: e.key == _currentIndex,
                onTap: () {
                  _onTap(e.key);
                  Navigator.of(context).pop();
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
