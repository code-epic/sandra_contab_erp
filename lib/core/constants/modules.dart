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
  'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc3VhcmlvIjp7ImlkIjoiNjhhMGYwNWFjYWUxNDMzMDI5ZDJiODk5IiwiY2VkdWxhIjoiMSIsIm5vbWJyZSI6IkFkbWluaXN0cmFkb3IiLCJ1c3VhcmlvIjoicGFuZWwiLCJjb3JyZW8iOiJjb2RlLmVwaWMudGVjaG5vbG9naWVzQGdtYWlsLmNvbSIsImNhcmdvIjoiQWRtaW5pc3RyYWRvciBDb3JlIiwiZGlyZWNjaW9uIjoiUHJpbmNpcGFsIiwic2lzdGVtYSI6ImNvcmUuc2FuZHJhLnNlcnZlciIsInN1Y3Vyc2FsIjoiVG9kYXMiLCJ0ZWxlZm9ubyI6Iis1ODQxMjk5NjcwOTYiLCJmZWNoYWNyZWFjaW9uIjoiMDAwMS0wMS0wMVQwMDowMDowMFoiLCJQZXJmaWwiOnsiZGVzY3JpcGNpb24iOiJBZG1pbmlzdHJhZG9yIENvcmUifSwiRmlybWFEaWdpdGFsIjp7InRpZW1wbyI6IjAwMDEtMDEtMDFUMDA6MDA6MDBaIn0sIkFwbGljYWNpb24iOlt7ImlkIjoiSUQtMDAxIiwibm9tYnJlIjoiQ29yZSBTYW5kcmEgU2VydmVyIiwidXJsIjoiaHR0cDovL2xvY2FsaG9zdC9jb25zb2xhIiwib3JpZ2VuIjoiIiwiY29tZW50YXJpbyI6IlVzdWFyaW8gQ29yZSIsInZlcnNpb24iOiIyLjAuMCIsImF1dG9yIjoiQ29kZS1FcGljIFRlY2hub2xvZ2llcyIsIlJvbCI6e319XX0sImV4cCI6MTc1NTU2OTA2NiwiaXNzIjoiQ29kZSBFcGljIFRlY2hub2xvZ2llcyJ9.dsPpgQswP-dwdi6BHy7UTksO8SFOWq3EMlz6TNanADKN_odFrGtzrPqnvyjZER49j72_p_7BLlYQfleu5QEpXTpA-vDy58tCT5xKD-O9a8Sfjr5nOREx2bxG5iCDnPUgC147ZCdeQibmbLh2sjUkddddS5Cx3gHZUUb5xC5OmdPRVEhq1-HEAvKuRcu4iQ02cn6BMSMZFa9MrXaE2d6QxlMDI_lh5Af0g26_mFU98eE4zOVhwpWINTCHVJR425azKzasKQ3Pqm-1KNUzQyh-bIGiKD4gN0_9jiKtY4cwSDJVsMJFmBKcvbIevpoRlUoerduagulewKoSjw1UPixVxOOZiPQdakVrQqLQ8Z7QQz8OqB5yBKof40P7BNOgFuyydN0lLVULXA3jr7fMrggKQnTk8VUEcn8MoQcipQUTupde3afjGuUe3O_AzhCT40dKKXU6ZDMMLuFYeeEsmFbZOnAJaN67fioySjiiC2HrCdk0SZJ5OrJd0Hv9T-Nj1qRWRf6s6d-xYAT1EMzn2hnMQV9p3BWuhDGCIjsRTtpiB11-WyivMKNQVrH8sctNd4My0SME8EydyHXZ4Msa_CKqEuGhLNY-v3TBcLjdnO-9Ia-8pVD8kpTltXQQXwktSw-DGSP1kx8ryeTCEhm_HjVUSjAg7twLGeKsuE58_rNzVbw';