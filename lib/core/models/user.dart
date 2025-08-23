class User {
  final String? id;
  final String cedula;
  final String nombre;
  final String apellido;
  final String correo;
  final int estatus;
  final bool titular;
  final DigitalSignature? firmadigital;

  User({
    this.id,
    required this.cedula,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.estatus,
    required this.titular,
    this.firmadigital,
  });

  // Constructor para crear un objeto User a partir de un Map (fromJson)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      cedula: json['cedula'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      correo: json['correo'],
      estatus: json['estatus'],
      titular: json['titular'],
      firmadigital: json['firmadigital'] != null
          ? DigitalSignature.fromJson(json['firmadigital'])
          : null,
    );
  }

  // Método para convertir un objeto User a un Map (toJson)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cedula': cedula,
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'estatus': estatus,
      'titular': titular,
      'firmadigital': firmadigital?.toJson(),
    };
  }
}

class DigitalSignature {
  final String direccionmac;
  final String direccionip;

  DigitalSignature({
    required this.direccionmac,
    required this.direccionip,
  });

  // Constructor para crear un objeto DigitalSignature a partir de un Map
  factory DigitalSignature.fromJson(Map<String, dynamic> json) {
    return DigitalSignature(
      direccionmac: json['direccionmac'],
      direccionip: json['direccionip'],
    );
  }

  // Método para convertir un objeto DigitalSignature a un Map
  Map<String, dynamic> toJson() {
    return {
      'direccionmac': direccionmac,
      'direccionip': direccionip,
    };
  }
}