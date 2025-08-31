// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contador.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contador _$ContadorFromJson(Map<String, dynamic> json) => Contador(
  id: json['id'] as String?,
  cedula: json['cedula'] as String,
  carnetFccpv: json['carnet_fccpv'] as String,
  nombre: json['nombre'] as String,
  apellido: json['apellido'] as String,
  correo: json['correo'] as String,
  telefono: json['telefono'] as String?,
  urlFotoPerfil: json['url_foto_perfil'] as String?,
  antiguedadProfesional: (json['antiguedad_profesional'] as num).toInt(),
  areasExperiencia: (json['areas_experiencia'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  formacionAcademica: (json['formacion_academica'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  certificaciones: (json['certificaciones'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  puntuacionCliente: (json['puntuacion_cliente'] as num).toInt(),
  casosResueltosApp: (json['casos_resueltos_app'] as num).toInt(),
  interaccionesForo: (json['interacciones_foro'] as num).toInt(),
  citasEnPublicaciones: (json['citas_en_publicaciones'] as num).toInt(),
  ultimaActualizacion: json['ultima_actualizacion'] == null
      ? null
      : DateTime.parse(json['ultima_actualizacion'] as String),
);

Map<String, dynamic> _$ContadorToJson(Contador instance) => <String, dynamic>{
  'id': instance.id,
  'cedula': instance.cedula,
  'carnet_fccpv': instance.carnetFccpv,
  'nombre': instance.nombre,
  'apellido': instance.apellido,
  'correo': instance.correo,
  'telefono': instance.telefono,
  'url_foto_perfil': instance.urlFotoPerfil,
  'antiguedad_profesional': instance.antiguedadProfesional,
  'areas_experiencia': instance.areasExperiencia,
  'formacion_academica': instance.formacionAcademica,
  'certificaciones': instance.certificaciones,
  'puntuacion_cliente': instance.puntuacionCliente,
  'casos_resueltos_app': instance.casosResueltosApp,
  'interacciones_foro': instance.interaccionesForo,
  'citas_en_publicaciones': instance.citasEnPublicaciones,
  'ultima_actualizacion': instance.ultimaActualizacion?.toIso8601String(),
};
