// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empresa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Empresa _$EmpresaFromJson(Map<String, dynamic> json) => Empresa(
  id: json['id'] as String?,
  nombreComercial: json['nombre_comercial'] as String,
  razonSocial: json['razon_social'] as String?,
  rif: json['rif'] as String,
  actividadEconomica: json['actividad_economica'] as String?,
  rubroEconomico: (json['rubro_economico'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  direccionFiscal: json['direccion_fiscal'] as String?,
  telefono: json['telefono'] as String?,
  correoElectronico: json['correo_electronico'] as String?,
  tipoSociedad: json['tipo_sociedad'] as String?,
  estatusSeniat: json['estatus_seniat'] as String?,
  documentosDigitales: (json['documentos_digitales'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  contadorId: json['contador_id'] as String?,
  perfilVector: (json['perfil_vector'] as List<dynamic>?)
      ?.map((e) => (e as num).toDouble())
      .toList(),
  fechaCreacion: json['fecha_creacion'] == null
      ? null
      : DateTime.parse(json['fecha_creacion'] as String),
  ultimaActualizacion: json['ultima_actualizacion'] == null
      ? null
      : DateTime.parse(json['ultima_actualizacion'] as String),
  logoUrl: json['logo_url'] as String?,
);

Map<String, dynamic> _$EmpresaToJson(Empresa instance) => <String, dynamic>{
  'id': instance.id,
  'nombre_comercial': instance.nombreComercial,
  'razon_social': instance.razonSocial,
  'rif': instance.rif,
  'actividad_economica': instance.actividadEconomica,
  'rubro_economico': instance.rubroEconomico,
  'direccion_fiscal': instance.direccionFiscal,
  'telefono': instance.telefono,
  'correo_electronico': instance.correoElectronico,
  'tipo_sociedad': instance.tipoSociedad,
  'estatus_seniat': instance.estatusSeniat,
  'documentos_digitales': instance.documentosDigitales,
  'contador_id': instance.contadorId,
  'perfil_vector': instance.perfilVector,
  'fecha_creacion': instance.fechaCreacion?.toIso8601String(),
  'ultima_actualizacion': instance.ultimaActualizacion?.toIso8601String(),
  'logo_url': instance.logoUrl,
};
