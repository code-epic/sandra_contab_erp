import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'package:sandra_contab_erp/core/models/upload_service.dart';

class ScannedDocument {
  final String originalPath;
  // final String processedPath;
  final String thumbnailPath;

  ScannedDocument({
    required this.originalPath,
    // required this.processedPath,
    required this.thumbnailPath,
  });
}


class ScanProvider extends ChangeNotifier {

  final UploadService _uploadService = UploadService();
  File? _currentImage;
  File? get currentImage => _currentImage;

  final List<ScannedDocument> _scannedDocuments = [];
  List<ScannedDocument> get scannedDocuments => _scannedDocuments;

  img.Image binarizeImageWithOtsu(img.Image originalImage) {
    img.Image grayscaleImage = img.grayscale(originalImage);

    // 2. Calcular el umbral de Otsu
    int getOtsuThreshold(img.Image image) {
      var histogram = List<int>.filled(256, 0);
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          int pixelValue = image.getPixel(x, y).r.toInt();
          histogram[pixelValue]++;
        }
      }

      // Algoritmo de Otsu para encontrar el mejor umbral
      double total = image.width * image.height.toDouble();
      double sum = 0;
      for (int i = 0; i < 256; i++) {
        sum += i * histogram[i];
      }

      double sumB = 0;
      double wB = 0;
      double wF = 0;
      double varMax = 0;
      int threshold = 0;

      for (int i = 0; i < 256; i++) {
        wB += histogram[i];
        if (wB == 0) continue;
        wF = total - wB;
        if (wF == 0) break;

        sumB += i * histogram[i];
        double mB = sumB / wB;
        double mF = (sum - sumB) / wF;

        double varBetween = wB * wF * (mB - mF) * (mB - mF);
        if (varBetween > varMax) {
          varMax = varBetween;
          threshold = i;
        }
      }
      return threshold;
    }

    int otsuThreshold = getOtsuThreshold(grayscaleImage);

    // 3. Aplicar el umbral de Otsu a la imagen
    for (int y = 0; y < grayscaleImage.height; y++) {
      for (int x = 0; x < grayscaleImage.width; x++) {
        int pixelValue = grayscaleImage.getPixel(x, y).r.toInt();
        if (pixelValue < otsuThreshold) {
          grayscaleImage.setPixelRgb(x, y, 0, 0, 0); // Negro
        } else {
          grayscaleImage.setPixelRgb(x, y, 255, 255, 255); // Blanco
        }
      }
    }

    return grayscaleImage;
  }

  void setImage(File image) {
    _currentImage = image;
    notifyListeners();
  }


  // Nuevo método para agregar un documento procesado
  Future<void> addProcessedDocument(File document, String code) async {
    final String baseName = 'FAC-$code-${DateTime.now().millisecondsSinceEpoch}';
    // final processedFile = await processDocument(document, '${baseName}_bw.png');
    final thumbnailFile = await generateThumbnail(document, '${baseName}_min.png');
    final tempDir = await getTemporaryDirectory();
    final originalFile = await document.copy('${tempDir.path}/${baseName}_color.png');
    final newScannedDoc = ScannedDocument(
      originalPath: originalFile.path,
      // processedPath: processedFile.path,
      thumbnailPath: thumbnailFile.path,
    );
    _scannedDocuments.add(newScannedDoc);
    _currentImage = null;
    notifyListeners();
  }


  Future<File> processDocument(File originalFile, String fileName) async {
    // 1. Leer los bytes del archivo y decodificar la imagen
    final bytes = await originalFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('No se pudo decodificar la imagen');
    }

    // 2. Convertir la imagen a escala de grises
    img.Image grayscaleImage = img.grayscale(originalImage);

    // 3. Calcular el umbral de Otsu para binarización
    int getOtsuThreshold(img.Image image) {
      var histogram = List<int>.filled(256, 0);
      for (int y = 0; y < image.height; y++) {
        for (int x = 0; x < image.width; x++) {
          int pixelValue = image.getPixel(x, y).r.toInt();
          histogram[pixelValue]++;
        }
      }

      double total = image.width * image.height.toDouble();
      double sum = 0;
      for (int i = 0; i < 256; i++) {
        sum += i * histogram[i];
      }

      double sumB = 0;
      double wB = 0;
      double wF = 0;
      double varMax = 0;
      int threshold = 0;

      for (int i = 0; i < 256; i++) {
        wB += histogram[i];
        if (wB == 0) continue;
        wF = total - wB;
        if (wF == 0) break;

        sumB += i * histogram[i];
        double mB = sumB / wB;
        double mF = (sum - sumB) / wF;

        double varBetween = wB * wF * (mB - mF) * (mB - mF);
        if (varBetween > varMax) {
          varMax = varBetween;
          threshold = i;
        }
      }
      return threshold;
    }

    int otsuThreshold = getOtsuThreshold(grayscaleImage);

    // 4. Binarizar la imagen usando el umbral de Otsu
    for (int y = 0; y < grayscaleImage.height; y++) {
      for (int x = 0; x < grayscaleImage.width; x++) {
        int pixelValue = grayscaleImage.getPixel(x, y).r.toInt();
        if (pixelValue < otsuThreshold) {
          grayscaleImage.setPixelRgb(x, y, 0, 0, 0); // Negro
        } else {
          grayscaleImage.setPixelRgb(x, y, 255, 255, 255); // Blanco
        }
      }
    }

    // 5. Guardar la imagen procesada en un archivo temporal
    final tempDir = await getTemporaryDirectory();
    final newFilePath = '${tempDir.path}/$fileName';
    final processedFile = File(newFilePath);
    await processedFile.writeAsBytes(img.encodePng(grayscaleImage));

    return processedFile;
  }


  // Nuevo método para crear una miniatura
  Future<File> generateThumbnail(File originalFile, String fileName) async {
    final bytes = await originalFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);

    if (originalImage == null) {
      throw Exception('No se pudo decodificar la imagen');
    }

    img.Image thumbnailImage = img.copyResize(originalImage, width: 200);

    final tempDir = await getTemporaryDirectory();
    final thumbnailPath = '${tempDir.path}/$fileName';
    final thumbnailFile = File(thumbnailPath);
    await thumbnailFile.writeAsBytes(img.encodePng(thumbnailImage));

    return thumbnailFile;
  }


// Modificar otros métodos para que funcionen con la nueva clase
  void removeDocument(ScannedDocument document) {
    _scannedDocuments.removeWhere((doc) => doc.originalPath == document.originalPath);
    // Eliminar los archivos del disco
    File(document.originalPath).deleteSync();
    // File(document.processedPath).deleteSync();
    File(document.thumbnailPath).deleteSync();
    notifyListeners();
  }




  void clearCurrentScan() {
    _currentImage = null;
    notifyListeners();
  }

  void clearAllScans() {
    _scannedDocuments.clear();
    _currentImage = null;
    notifyListeners();
  }


  // Lógica para enviar documentos
  Future<void> uploadDocuments() async {
    if (scannedDocuments.isEmpty) {
      return;
    }

    try {
      final filesToUpload = scannedDocuments.map((doc) => File(doc.originalPath!) ).toList();
      print(filesToUpload);

      // Calcula el tamaño total en bytes
      final totalBytes = filesToUpload.fold<int>(
        0,
            (previousValue, file) => previousValue + file.lengthSync(),
      );

      // Convierte a KB, MB o GB para una mejor lectura
      final totalKB = totalBytes / 1024;
      final totalMB = totalKB / 1024;
      final totalGB = totalMB / 1024;

      print('Archivos a subir: $filesToUpload');
      print('Tamaño total en bytes: $totalBytes bytes');
      print('Tamaño total en MB: ${totalMB.toStringAsFixed(2)} MB');

      final files = <String, List<File>>{
        "archivos": filesToUpload,
      };

      final fields = {
        "identificador": "FAC-17522251-DIA",
      };

      print(files);

      final stream = _uploadService.uploadFiles(files, fields);
      stream.listen(
        (event) async {
          print("Progreso: ${(event.progress * 100).toStringAsFixed(2)}%");
          if (event.state == "DONE") {
            print("Archivos subidos correctamente.");
          }
        },
        onError: (e) {
          print("Error al subir archivos: $e");
        },
        onDone: () {
          // La subida del stream ha terminado

        }
      );
    } catch (e) {
      print("Error al subir archivos: $e");

    }
    clearAllScans();
  }
}