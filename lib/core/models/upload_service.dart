import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:http/io_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class UploadProgress {
  final int sent;
  final int total;
  final double progress;
  final String state;

  UploadProgress({
    required this.sent,
    required this.total,
    required this.progress,
    required this.state,
  });
}

class UploadService {
  final String baseUrl = IsUrl;
  final _secureStorage = const FlutterSecureStorage();

  http.Client createInsecureHttpClient() {
    final httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }


  Stream<UploadProgress> uploadFiles(Map<String,  List<File>> files, Map<String, String> fields) {
    final controller = StreamController<UploadProgress>();

    () async {
      final client = createInsecureHttpClient();
      try {
        final uri = Uri.parse("${baseUrl}v1/api/subirarchivos");
        final request = http.MultipartRequest("POST", uri);
        final token = await _secureStorage.read(key: 'auth_user');
        request.headers["Authorization"] = "Bearer $token";

        // Campos extras
        request.fields.addAll(fields);

        // Archivos
        for (var entry in files.entries) {
          for (var file in entry.value) {
            request.files.add(
                await http.MultipartFile.fromPath(entry.key, file.path));
          }
        }

        print(files);
        final totalBytes = files.values.expand((f) => f).fold<int>(0, (p, f) => p + f.lengthSync());
        int sentBytes = 0;

        final streamedResponse = await client.send(request);


        streamedResponse.stream.listen((data) {
        sentBytes += data.length;
        final progress = sentBytes / totalBytes;
        controller.add(UploadProgress(
          sent: sentBytes,
          total: totalBytes,
          progress: progress,
          state: progress == 1.0 ? "DONE" : "LOADING",
          ));
        },
       onDone: () {
        if (streamedResponse.statusCode == 200) {
          controller.add(UploadProgress(
            sent: totalBytes,
            total: totalBytes,
            progress: 1.0,
            state: "DONE",
          ));
        } else {
          controller.addError("Error al subir archivos: ${streamedResponse.request}");

        }
        controller.close();
        },onError: (e) {
          controller.addError(e);
          controller.close();
        });
      } catch (e) {
        controller.addError(e);
        await controller.close();
      } finally {
      client.close();
      }
    }();
    return controller.stream;
  }
}
