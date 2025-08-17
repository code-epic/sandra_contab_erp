import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';

class ApiService {
  http.Client createInsecureHttpClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }
  Future<Map<String, dynamic>> ejecutar({
    required String funcion,
    Map<String, dynamic>? valores,
    String parametros = "",
  }) async {
    Map<String, dynamic> requestBody = {
      "funcion": funcion,
      "parametros": parametros.isNotEmpty ? parametros : null,
    };
    if (valores != null && valores.isNotEmpty) {
      requestBody["valores"] = jsonEncode(valores);
    }
    requestBody.removeWhere((key, value) => value == null || (value is String && value.isEmpty));
    final url = Uri.parse("${IsUrl}crud:development");
    try {
      final client = createInsecureHttpClient();
      final response = await client.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      // Manejo de errores según el código de estado HTTP
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
}