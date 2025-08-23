import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:crypto/crypto.dart';


class ApiService {

  late final String _url_api = IsUrl + 'v1/api/crud:development';
  late final String _url_coleccion = IsUrl + 'v1/api/ccoleccion';
  late final String _url_token = IsUrl + 'v1/api/wusuario/login';


  http.Client createInsecureHttpClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  Future<Map<String, dynamic>> ejecutar({
    Map<String, dynamic>? coleecion,
    String funcion = "",
    Map<String, dynamic>? valores,
    String parametros = "",
    String token = 'jwt_contabapp',
    int type = 1
  }) async {
    Map<String, dynamic> requestBody = {
      "funcion": funcion,
      "parametros": parametros.isNotEmpty ? parametros : null,
    };

    if (valores != null && valores.isNotEmpty) {
      requestBody["valores"] = jsonEncode(valores);
    }


    requestBody.removeWhere((key, value) => value == null || (value is String && value.isEmpty));
    var dir = _url_api;
    if (coleecion != null && coleecion.isNotEmpty) {
      requestBody = coleecion;
      dir = _url_coleccion;
    }else if (type == 2) {
      requestBody = valores!;
      dir = _url_token;
    }

    final url = Uri.parse("${dir}");
    print(url);
    try {
      final client = createInsecureHttpClient();
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };



      final response = await client.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      switch (response.statusCode) {
        case 200:
        // Éxito
          return jsonDecode(response.body);

        case 400:
        // Solicitud incorrecta (Bad Request)
          throw Exception('Error 400: Solicitud incorrecta. ${response.body}');

        case 401:
        // No autorizado (Unauthorized)
          throw Exception('Error 401: No autorizado. ${response.body}');

        case 403:
        // Prohibido (Forbidden)
          return jsonDecode(response.body);

        case 404:
        // No encontrado (Not Found)
          throw Exception('Error 404: No encontrado. ${response.body}');

        case 500:
        // Error interno del servidor (Internal Server Error)
          throw Exception('Error 500: Error interno del servidor. ${response.body}');

        default:
        // Otros errores
          throw Exception('Error desconocido: ${response.statusCode}. ${response.body}');
      }
    } catch (e) {
      throw Exception('Error al ejecutar la solicitud: $e');
    }
  }

  String ConvertToSHA256(String input) {
    var bytes = utf8.encode(input); // Convierte la clave en una lista de bytes
    var digest = sha256.convert(bytes); // Calcula el hash SHA-256
    return digest.toString(); // Retorna el hash como un String
  }
}