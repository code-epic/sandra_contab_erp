// lib/shared/widgets/app_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';


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
    context.go(kModules[index].route);
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
      drawer: isDesktop ? null : _buildDrawer(),
    );
  }

  Widget _buildRail() {
    return NavigationRail(

      selectedIndex: _currentIndex,
      onDestinationSelected: _onTap,
      destinations: kModules
          .map((m) => NavigationRailDestination(
        icon: Icon(m.icon),
        label: Text(m.title),
      ))
          .toList(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: kModules
            .asMap()
            .entries
            .map((e) => ListTile(
          leading: Icon(e.value.icon),
          title: Text(e.value.title),
          selected: e.key == _currentIndex,
          onTap: () {
            _onTap(e.key);
            Navigator.of(context).pop();
          },
        ))
            .toList(),
      ),
    );
  }
}