import 'package:intl/intl.dart';

class Factura {
  final int? id;
  final String razon;
  final String codigo;
  final DateTime fecha;
  final String? estatus;
  final String? tipo;

  Factura({
    this.id,
    required this.razon,
    required this.codigo,
    required this.fecha,
    this.estatus,
    this.tipo,
  });

  // Constructor de fábrica para crear un objeto Factura a partir de un Map (fromJson)
  factory Factura.fromJson(Map<String, dynamic> json) {
    // Asumiendo que el JSON de la API viene en formato yyyy-MM-dd
    return Factura(
      id: json['id'],
      razon: json['razon'],
      codigo: json['codigo'],
      fecha: DateTime.parse(json['fecha']),
      estatus: json['estatus'],
      tipo: json['tipo'],
    );
  }

  // Método para convertir un objeto Factura a un Map (toJson)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'razon': razon,
      'codigo': codigo,
      'fecha': DateFormat('yyyy-MM-dd').format(fecha), // Formatear la fecha aquí
      'estatus': estatus,
      'tipo': tipo,
    };
  }

  // Método estático para un objeto de prueba
  static Factura get mockFactura => Factura(
    razon: 'Ejemplo S.A.',
    codigo: 'INV-001',
    fecha: DateTime.now(),
    estatus: 'Pendiente',
    tipo: 'Compra',
  );
}