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

const String IsUrl = "https://192.168.0.10/";
const String IsToken =
'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc3VhcmlvIjp7ImlkIjoiNjhhMGYwNWFjYWUxNDMzMDI5ZDJiODk5IiwiY2VkdWxhIjoiMSIsIm5vbWJyZSI6IkFkbWluaXN0cmFkb3IiLCJ1c3VhcmlvIjoicGFuZWwiLCJjb3JyZW8iOiJjb2RlLmVwaWMudGVjaG5vbG9naWVzQGdtYWlsLmNvbSIsImNhcmdvIjoiQWRtaW5pc3RyYWRvciBDb3JlIiwiZGlyZWNjaW9uIjoiUHJpbmNpcGFsIiwic2lzdGVtYSI6ImNvcmUuc2FuZHJhLnNlcnZlciIsInN1Y3Vyc2FsIjoiVG9kYXMiLCJ0ZWxlZm9ubyI6Iis1ODQxMjk5NjcwOTYiLCJmZWNoYWNyZWFjaW9uIjoiMDAwMS0wMS0wMVQwMDowMDowMFoiLCJQZXJmaWwiOnsiZGVzY3JpcGNpb24iOiJBZG1pbmlzdHJhZG9yIENvcmUifSwiRmlybWFEaWdpdGFsIjp7InRpZW1wbyI6IjAwMDEtMDEtMDFUMDA6MDA6MDBaIn0sIkFwbGljYWNpb24iOlt7ImlkIjoiSUQtMDAxIiwibm9tYnJlIjoiQ29yZSBTYW5kcmEgU2VydmVyIiwidXJsIjoiaHR0cDovL2xvY2FsaG9zdC9jb25zb2xhIiwib3JpZ2VuIjoiIiwiY29tZW50YXJpbyI6IlVzdWFyaW8gQ29yZSIsInZlcnNpb24iOiIyLjAuMCIsImF1dG9yIjoiQ29kZS1FcGljIFRlY2hub2xvZ2llcyIsIlJvbCI6e319XX0sImV4cCI6MTc1NTY0MTkyMSwiaXNzIjoiQ29kZSBFcGljIFRlY2hub2xvZ2llcyJ9.jEF3rUzq8M8HkLEtoLvvw-8G1tS9A9K8eGy0p8P1VDgiHjMap93hNpsWKsXue7aXxjska3daIOtMKSuP0Ep6IIFq9xVWi-kX01-gSa2s5FfC8UViIxWOWVr-NENg-VtvFTtqiD-inxALk5F01uGBLyehTWLQ0IUh0wzObkpjaGJshWrFenJ941FT0z1t5adMfbLmaGNKHuuM_QKe54BYYwAk1HvCgupKoK8vbyokWx-Es36_XS6B5MFneLuCc2QDEQajeXLZNyfant1pu78U2xhlZR5WIa33bJ-Yk3_U5JL3U6k9dQLuZO3z-yJ-28rf69hwzJmqqnLjl5DKIxjV0PdsvC1HpN5EgBW55mxU5fNg7W1E2WhnJoR556LVtLGMLhzGthR_El5WFGMMiPKGOS7RzJ-zYx483JPIqrzQ_v-eDAnK51Tzd4e9S3RFxbqByL6jHK4vtb68kg8f8W1jGxR4p_J4TnrPppyjJ2HPZDfPSSBQP-CyexfL4nEi2qXmtJtBz3VXgUQBCNkb4O1AwFPSthnpJ00FsF4gFiudmAo1TaoYAFzAIiZMT63_PWD4XtOfp9wVzhedHv4yjIsQCV-rTxw8D1oybGUEElEQ2RYz7vqB9IyCN4cxKoaCB6JYWFBBCU9A4QDKerJJ-Xq3Ch7Uxhfub8AsOzs4D-Z7UJQ';