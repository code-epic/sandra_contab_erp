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

const String IsUrl = "https://192.168.0.10/v1/api/";
const String IsToken =
    'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc3VhcmlvIjp7ImlkIjoiNjhhMGYwNWFjYWUxNDMzMDI5ZDJiODk5IiwiY2VkdWxhIjoiMSIsIm5vbWJyZSI6IkFkbWluaXN0cmFkb3IiLCJ1c3VhcmlvIjoicGFuZWwiLCJjb3JyZW8iOiJjb2RlLmVwaWMudGVjaG5vbG9naWVzQGdtYWlsLmNvbSIsImNhcmdvIjoiQWRtaW5pc3RyYWRvciBDb3JlIiwiZGlyZWNjaW9uIjoiUHJpbmNpcGFsIiwic2lzdGVtYSI6ImNvcmUuc2FuZHJhLnNlcnZlciIsInN1Y3Vyc2FsIjoiVG9kYXMiLCJ0ZWxlZm9ubyI6Iis1ODQxMjk5NjcwOTYiLCJmZWNoYWNyZWFjaW9uIjoiMDAwMS0wMS0wMVQwMDowMDowMFoiLCJQZXJmaWwiOnsiZGVzY3JpcGNpb24iOiJBZG1pbmlzdHJhZG9yIENvcmUifSwiRmlybWFEaWdpdGFsIjp7InRpZW1wbyI6IjAwMDEtMDEtMDFUMDA6MDA6MDBaIn0sIkFwbGljYWNpb24iOlt7ImlkIjoiSUQtMDAxIiwibm9tYnJlIjoiQ29yZSBTYW5kcmEgU2VydmVyIiwidXJsIjoiaHR0cDovL2xvY2FsaG9zdC9jb25zb2xhIiwib3JpZ2VuIjoiIiwiY29tZW50YXJpbyI6IlVzdWFyaW8gQ29yZSIsInZlcnNpb24iOiIyLjAuMCIsImF1dG9yIjoiQ29kZS1FcGljIFRlY2hub2xvZ2llcyIsIlJvbCI6e319XX0sImV4cCI6MTc1NTQ5MDA4NiwiaXNzIjoiQ29kZSBFcGljIFRlY2hub2xvZ2llcyJ9.i4eLn3sLAP3uBNEkZQo7FQ7Ib3RiuEbOGkjTHTrdM5j2IIh_DXmL-7Q1bes57SIZ6U_TyP8C6rMIK7i5n5dJs0wU4YaQ-BykdFhiWFr0QrXA_buQ_CYCvTtIHW6tq0GNzRoIeQDqG8RIBXIpZj3hj5ZWNU-74ySWRB6cxKDCG_sj2PTRFyW0MbP3DKUK7OOlQqfsYIhC3rLRe1xHmAILjGXEL7_Djgx4UCM5S0uoICwQzqdlU-jWLhJH58mrvlE6jvsuORHxAOqQtl66jpa5LzolJX9JV5zDCTA74ASwn0UpzMqVO180URbY7tvMmoKIR6ymx9w8iY-d3EIvkgMYDTy133wI535_A1NXhaQ04sOh4eFy9ExPkxXcRFQKg7-T-ksTfAlZifSm9rOEl3F_dYLnq4plmZ05EYhjd_HEZKVw-3O8pPA6ZeHnbInfCGBKeO7oN0X7zLlEGYf8PRGoKa3cYtDnBGTfy0lu92-tsZtbrtMThfkP9F6ahWPngzIoKeyo4_UAyFBR5XxhJfkq1w6mN9j11KOoYI1RfcMDDnIb77eWabxpFCZeWxUrOKq_oKommN2fMKTbhYl27Q5mof3r77HPLrJMwDr9STEbmU44oLoUAeMdBN2QKO54WSuv8qPMIXrA-5apo7XiasGt6tS4NsWbOFG69NEeuvNp67k';