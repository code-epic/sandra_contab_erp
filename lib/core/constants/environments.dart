class Environments {
  Environments._();

  static const String WUSUARIO = 'wusuario';
  static const String IDENTIFICAR_USUARIO = 'CTAB_CIdentificarUsuario';
  static const String ENVIAR_EMAIL_VALIDAR = 'EnviarMailValidar';
  static const String ENVIAR_REPORTE_EMAIL = 'Fnx_EnviarCorreoPDF';
  static const String IMAGEN_BASE64 = 'Fnx_ImgBase64Url';
  static const String DRIVER = 'MGDBA';

  static const funcion = _Funciones();
}

class _Funciones {
  const _Funciones();
  String get WUSUARIO => Environments.WUSUARIO;
  String get IDENTIFICAR_USUARIO => Environments.IDENTIFICAR_USUARIO;
  String get ENVIAR_EMAIL_VALIDAR => Environments.ENVIAR_EMAIL_VALIDAR;
  String get ENVIAR_REPORTE_EMAIL => Environments.ENVIAR_REPORTE_EMAIL;
  String get IMAGEN_BASE64 => Environments.IMAGEN_BASE64;
  String get DRIVER => Environments.DRIVER;
}