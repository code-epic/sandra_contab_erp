import 'package:flutter/material.dart';

import 'app_color.dart';


class IconModule {
  final IconData icon;
  final String title;
  final Color color;
  final String route;

  IconModule({
    required this.icon,
    required this.title,
    required this.color,
    required this.route,
  });

  static final List<IconModule> _modules = [
    IconModule(
      icon: Icons.account_balance_wallet,
      title: 'Contabilidad',
      color: AppColors.steelBlue,
      route: '/accounting',
    ),
    IconModule(
      icon: Icons.shopping_cart,
      title: 'Compras',
      color: AppColors.lightSlate,
      route: '/purchases',
    ),
    IconModule(
      icon: Icons.attach_money,
      title: 'Nóminas',
      color: AppColors.navy,
      route: '/payroll',
    ),
    IconModule(
      icon: Icons.account_balance,
      title: 'Tesorería',
      color: AppColors.paleBlue,
      route: '/treasury',
    ),
    IconModule(
      icon: Icons.receipt_long,
      title: 'Impuestos',
      color: AppColors.ocean,
      route: '/taxes',
    ),
    IconModule(
      icon: Icons.people,
      title: 'Clientes',
      color: AppColors.orangeBackground,
      route: '/clients',
    ),
    IconModule(
      icon: Icons.lightbulb_outline,
      title: 'Inteligencia',
      color: AppColors.blueHighAlpha,
      route: '/intelligence',
    ),
  ];

  static List<IconModule> get iconModule => _modules;
}


