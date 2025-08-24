import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/module.dart';
import 'package:flutter/foundation.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';


final kModules = [
  Module(
    id: 'dashboard',
    title: 'Dashboard',
    icon: PhosphorIcons.house(),
    route: '/home',
  ),
  Module(
    id: 'contab',
    title: 'Contabilidad General',
    icon: PhosphorIcons.calculator(),
    route: '/contab',
  ),
  Module(
    id: 'sales',
    title: 'Compras y Ventas',
    icon: PhosphorIcons.shoppingCart(),
    route: '/sales',
  ),
  Module(
    id: 'payroll',
    title: 'Nómina y Finiquitos',
    icon: PhosphorIcons.users(),
    route: '/payroll',
  ),
  Module(
    id: 'treasury',
    title: 'Tesorería y Pagos',
    icon: PhosphorIcons.bank(),
    route: '/treasury',
  ),
  Module(
    id: 'taxes',
    title: 'Impuestos y Declaraciones',
    icon: PhosphorIcons.fileText(),
    route: '/taxes',
  ),
  Module(
    id: 'clients',
    title: 'Gestión de Clientes',
    icon: PhosphorIcons.buildings(),
    route: '/clients',
  ),
  Module(
    id: 'tasks',
    title: 'Tareas y Alertas',
    icon: PhosphorIcons.checkSquare(),
    route: '/tasks',
  ),
  Module(
    id: 'ai',
    title: 'Inteligencia Artificial',
    icon: PhosphorIcons.robot(),
    route: '/ai',
  ),
  Module(
    id: 'settings',
    title: 'Configuración',
    icon: PhosphorIcons.gear(),
    route: '/settings',
  ),
];





String assetPath(String name) {
  return kIsWeb ? name : 'assets/$name';
}

Widget textoRequisitos(
    String texto
  ) {

  return Text(
    texto,
    style: TextStyle(
      fontSize:  15,
      color:  AppColors.navy,
    ),
    textAlign:  TextAlign.left,
  );
}

const String IsUrl = "https://192.168.0.11/";
const String IsToken = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc3VhcmlvIjp7ImlkIjoiNjhhMGYwNWFjYWUxNDMzMDI5ZDJiODk5IiwiY2VkdWxhIjoiMSIsIm5vbWJyZSI6IkFkbWluaXN0cmFkb3IiLCJ1c3VhcmlvIjoicGFuZWwiLCJjb3JyZW8iOiJjb2RlLmVwaWMudGVjaG5vbG9naWVzQGdtYWlsLmNvbSIsImNhcmdvIjoiQWRtaW5pc3RyYWRvciBDb3JlIiwiZGlyZWNjaW9uIjoiUHJpbmNpcGFsIiwic2lzdGVtYSI6ImNvcmUuc2FuZHJhLnNlcnZlciIsInN1Y3Vyc2FsIjoiVG9kYXMiLCJ0ZWxlZm9ubyI6Iis1ODQxMjk5NjcwOTYiLCJmZWNoYWNyZWFjaW9uIjoiMDAwMS0wMS0wMVQwMDowMDowMFoiLCJQZXJmaWwiOnsiZGVzY3JpcGNpb24iOiJBZG1pbmlzdHJhZG9yIENvcmUifSwiRmlybWFEaWdpdGFsIjp7InRpZW1wbyI6IjAwMDEtMDEtMDFUMDA6MDA6MDBaIn0sIkFwbGljYWNpb24iOlt7ImlkIjoiSUQtMDAxIiwibm9tYnJlIjoiQ29yZSBTYW5kcmEgU2VydmVyIiwidXJsIjoiaHR0cDovL2xvY2FsaG9zdC9jb25zb2xhIiwib3JpZ2VuIjoiIiwiY29tZW50YXJpbyI6IlVzdWFyaW8gQ29yZSIsInZlcnNpb24iOiIyLjAuMCIsImF1dG9yIjoiQ29kZS1FcGljIFRlY2hub2xvZ2llcyIsIlJvbCI6e319XX0sImV4cCI6MTc1NjA3MDgzOSwiaXNzIjoiQ29kZSBFcGljIFRlY2hub2xvZ2llcyJ9.nVw2gsllaU0y2qOKnMOZuCir1uu7eMxv1NTiwmhltZwR7gQiUyl9Arc1PS7L3Z65JY4SQUt9WVuqxUE-n1vIUJeiYZjJrT1g4xjNMUMNA5jcDWb_d7_4y4e0Eizk4M_7K1XH5sTbMtGpM2zvH-6cQ2q0nm0aFRGWA9x3yINTvw3lFvD7Cde3ktKxo4y0wgoT68HlCoC5Gwxrf5y6XGjbBJqFWJ_JyEL50sK_TM8NlHg6-nHM3EVxNJpFqNN8_RrASztxMhJhQOJiGQp0EIVo89mvHi-o3nIEj_AKjiWeF6dpz3DUVX9knvnxyayOiwLZJp60KaOUNrh49tVWYa2-v0qaVhGlZoysM-uWWlvfI4QkIx93-N1hqbHuIflOqV-zCGuDgrhyJ-crTv0TwfQRYzqiJWAd3kzSf6Kg4Nmf4eyxjXx9AUvJsWLHtEA3kXzcdV0kMahXOvg4wuhAbU-Sd8UD47QJaCkO5bUi3uiFuO9KRHSZa3vo78vQGAuci7c_OuxxgzqnvIBws49IaFvxJ9zmW5Aek8spHo3qawWZgMMlkm9QcY3X3I85Ia13Yem6XNrCkrb3H4UxR8zXYJfVknvhed0HrYhnhpGR0sfUtDbptRbI5GvM9O5PEqRDb0CtaaDPPYBPxzvrgEDvPBfePHmyNpfLzYc6_mXCdWK1Xts';