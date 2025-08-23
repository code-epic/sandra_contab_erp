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
const String IsToken =
    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc3VhcmlvIjp7ImlkIjoiNjhhMGYwNWFjYWUxNDMzMDI5ZDJiODk5IiwiY2VkdWxhIjoiMSIsIm5vbWJyZSI6IkFkbWluaXN0cmFkb3IiLCJ1c3VhcmlvIjoicGFuZWwiLCJjb3JyZW8iOiJjb2RlLmVwaWMudGVjaG5vbG9naWVzQGdtYWlsLmNvbSIsImNhcmdvIjoiQWRtaW5pc3RyYWRvciBDb3JlIiwiZGlyZWNjaW9uIjoiUHJpbmNpcGFsIiwic2lzdGVtYSI6ImNvcmUuc2FuZHJhLnNlcnZlciIsInN1Y3Vyc2FsIjoiVG9kYXMiLCJ0ZWxlZm9ubyI6Iis1ODQxMjk5NjcwOTYiLCJmZWNoYWNyZWFjaW9uIjoiMDAwMS0wMS0wMVQwMDowMDowMFoiLCJQZXJmaWwiOnsiZGVzY3JpcGNpb24iOiJBZG1pbmlzdHJhZG9yIENvcmUifSwiRmlybWFEaWdpdGFsIjp7InRpZW1wbyI6IjAwMDEtMDEtMDFUMDA6MDA6MDBaIn0sIkFwbGljYWNpb24iOlt7ImlkIjoiSUQtMDAxIiwibm9tYnJlIjoiQ29yZSBTYW5kcmEgU2VydmVyIiwidXJsIjoiaHR0cDovL2xvY2FsaG9zdC9jb25zb2xhIiwib3JpZ2VuIjoiIiwiY29tZW50YXJpbyI6IlVzdWFyaW8gQ29yZSIsInZlcnNpb24iOiIyLjAuMCIsImF1dG9yIjoiQ29kZS1FcGljIFRlY2hub2xvZ2llcyIsIlJvbCI6e319XX0sImV4cCI6MTc1NTk5OTQxNiwiaXNzIjoiQ29kZSBFcGljIFRlY2hub2xvZ2llcyJ9.j4tt6T6rD8CPxn5dhAgxshaqV1wo92RZoQhohNB78bMhj_DrEyzkyA8weWuU4JJLwN8T1cIsnAn7YgD3kPiKdlZTTohTEGd2-qdHpEJUAF3GeBQMxpePJK3pMnukPu1QZ4iU47Xdrb7sSk1i5mQooMQVsorVK_T7WcEVQ76Wq2i8gustuefkI1UmlkCq-tq7BT-jVrg7kGKSXfOVPTp8rHfJElKWNIccGq1bX546kWloizVLB9H9irAjR693M381jl-4Dw1_jKfZxgwHEGR_0vX6KT6ENoKtHrAzYULGELivT42VQmI72udIbVGEFLv--amIW7PcBPCksmkmGwGwc1h18DVkjZqXrqgNiV3U-aTN5mIdqc_6gV5AqXDr6_bSFCZ7VjQzyzuNtsaniLVzbFsYe7O9QVPpn1qnWLRuX5qD3-Jn0fpPNpoH0DZ0nTABt8Ucj2ihpgjzc1p54uh1wvANasvjHTjQKkniRpMlsgrBNrYKY8s4SRFVEAL8ciG-wLCtuFh0SGd7B1BjfNRmZUSqvgo1VNYUdHJZb9Mrd_s2HZO2tlr42QQm81gJ1ETw5GL__LaTu8iR1GB402FwIsKOFsxt-7oOZenmQtgZV-6PVHpYimglCo6Xzy-Qdh5vnvWLfEA1jCEv8Y3urp3B2hWJO0yR_YxdIKQ9cgLDBdo';