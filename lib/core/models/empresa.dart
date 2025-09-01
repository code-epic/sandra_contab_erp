// Archivo: empresa.dart

import 'package:json_annotation/json_annotation.dart';

part 'empresa.g.dart';

@JsonSerializable()
class Empresa {
  final String? id;
  @JsonKey(name: 'nombre_comercial')
  final String nombreComercial;
  @JsonKey(name: 'razon_social')
  final String? razonSocial;
  @JsonKey(name: 'rif')
  final String rif;
  @JsonKey(name: 'actividad_economica')
  final String? actividadEconomica;
  @JsonKey(name: 'rubro_economico')
  final List<String> rubroEconomico;
  @JsonKey(name: 'direccion_fiscal')
  final String? direccionFiscal;
  @JsonKey(name: 'telefono')
  final String? telefono;
  @JsonKey(name: 'correo_electronico')
  final String? correoElectronico;
  @JsonKey(name: 'tipo_sociedad')
  final String? tipoSociedad;
  @JsonKey(name: 'estatus_seniat')
  final String? estatusSeniat;
  @JsonKey(name: 'documentos_digitales')
  final List<String> documentosDigitales;
  @JsonKey(name: 'contador_id')
  final String? contadorId;
  @JsonKey(name: 'perfil_vector')
  final List<double>? perfilVector;
  @JsonKey(name: 'fecha_creacion')
  final DateTime? fechaCreacion;
  @JsonKey(name: 'ultima_actualizacion')
  final DateTime? ultimaActualizacion;
  @JsonKey(name: 'logo_url')
  final String? logoUrl;


  Empresa({
    this.id,
    required this.nombreComercial,
    this.razonSocial,
    required this.rif,
    this.actividadEconomica,
    required this.rubroEconomico,
    this.direccionFiscal,
    this.telefono,
    this.correoElectronico,
    this.tipoSociedad,
    this.estatusSeniat,
    required this.documentosDigitales,
    this.contadorId,
    this.perfilVector,
    this.fechaCreacion,
    this.ultimaActualizacion,
    this.logoUrl,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) =>
      _$EmpresaFromJson(json);
  
  Map<String, dynamic> toJson() => _$EmpresaToJson(this);
}