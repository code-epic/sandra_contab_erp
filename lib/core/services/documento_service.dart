import 'package:sandra_contab_erp/core/models/documento.dart';
import 'package:sandra_contab_erp/core/theme/publicaciones_card.dart';

class DocumentoService {
  Future<List<Documento>> buscarDocumentos(String query) async {
    // Simulamos una llamada a una API
    await Future.delayed(const Duration(milliseconds: 500));

    // Datos de ejemplo
    final List<Documento> documentosDeEjemplo = [
      Documento(titulo: 'Factura 1', estatus: 'REVISION', fecha: '28JUN25', peso: '2mb', conciliacion: 'Automatica'),
      Documento(titulo: 'Factura 2', estatus: 'PENDIENTE', fecha: '28JUN25', peso: '2mb', conciliacion: 'Automatica'),
      Documento(titulo: 'Factura 3', estatus: 'ANALIZADO', fecha: '28JUN25', peso: '2mb', conciliacion: 'Automatica'),
      Documento(titulo: 'Factura 4', estatus: 'REVISION', fecha: '27JUN25', peso: '3mb', conciliacion: 'Automatica'),
      Documento(titulo: 'Factura 5', estatus: 'PENDIENTE', fecha: '27JUN25', peso: '1mb', conciliacion: 'Automatica'),
      Documento(titulo: 'Factura 6', estatus: 'ANALIZADO', fecha: '26JUN25', peso: '2mb', conciliacion: 'Manual'),
      Documento(titulo: 'Factura 7', estatus: 'REVISION', fecha: '26JUN25', peso: '4mb', conciliacion: 'Manual'),
      Documento(titulo: 'Factura 8', estatus: 'PENDIENTE', fecha: '25JUN25', peso: '2mb', conciliacion: 'Manual'),
      Documento(titulo: 'Factura 9', estatus: 'ANALIZADO', fecha: '25JUN25', peso: '2mb', conciliacion: 'Automatica'),
      Documento(titulo: 'Factura 10', estatus: 'REVISION', fecha: '25JUN25', peso: '2mb', conciliacion: 'Automatica'),
    ];

    // Simular el filtro de búsqueda
    if (query.isEmpty) {
      return documentosDeEjemplo;
    } else {
      return documentosDeEjemplo.where(
            (doc) => doc.titulo.toLowerCase().contains(query.toLowerCase()) ||
            doc.estatus.toLowerCase().contains(query.toLowerCase()),
      ).toList();
    }
  }

  Future<List<DailyData>> getDailyData() async {
    // Simulamos una llamada a la API para obtener los datos del gráfico
    await Future.delayed(const Duration(milliseconds: 200));

    return [
      DailyData(day: 'LUN', count: 5),
      DailyData(day: 'MAR', count: 3),
      DailyData(day: 'MIÉ', count: 2),
      DailyData(day: 'JUE', count: 5),
      DailyData(day: 'VIE', count: 1),
      DailyData(day: 'SÁB', count: 6),
      DailyData(day: 'DOM', count: 4),
    ];
  }
}
