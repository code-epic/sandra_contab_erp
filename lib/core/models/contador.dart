// Archivo: contador.dart

import 'package:json_annotation/json_annotation.dart';

part 'contador.g.dart';

@JsonSerializable()
class Contador {
  final String? id;
  @JsonKey(name: 'cedula')
  final String cedula;
  @JsonKey(name: 'carnet_fccpv')
  final String carnetFccpv;
  final String nombre;
  final String apellido;
  final String correo;
  @JsonKey(name: 'telefono')
  final String? telefono;
  @JsonKey(name: 'url_foto_perfil')
  final String? urlFotoPerfil;
  @JsonKey(name: 'antiguedad_profesional')
  final int antiguedadProfesional;
  @JsonKey(name: 'areas_experiencia')
  final List<String> areasExperiencia;
  @JsonKey(name: 'formacion_academica')
  final List<Map<String, dynamic>> formacionAcademica;
  @JsonKey(name: 'certificaciones')
  final List<String> certificaciones;
  @JsonKey(name: 'puntuacion_cliente')
  final int puntuacionCliente;
  @JsonKey(name: 'casos_resueltos_app')
  final int casosResueltosApp;
  @JsonKey(name: 'interacciones_foro')
  final int interaccionesForo;
  @JsonKey(name: 'citas_en_publicaciones')
  final int citasEnPublicaciones;
  @JsonKey(name: 'ultima_actualizacion')
  final DateTime? ultimaActualizacion;

  Contador({
    this.id,
    required this.cedula,
    required this.carnetFccpv,
    required this.nombre,
    required this.apellido,
    required this.correo,
    this.telefono,
    this.urlFotoPerfil,
    required this.antiguedadProfesional,
    required this.areasExperiencia,
    required this.formacionAcademica,
    required this.certificaciones,
    required this.puntuacionCliente,
    required this.casosResueltosApp,
    required this.interaccionesForo,
    required this.citasEnPublicaciones,
    this.ultimaActualizacion,
  });

  factory Contador.fromJson(Map<String, dynamic> json) => _$ContadorFromJson(json);
  Map<String, dynamic> toJson() => _$ContadorToJson(this);
}