import 'package:flutter/material.dart';
import 'dart:io';

class ScanProvider extends ChangeNotifier {
  File? _currentImage;
  final List<File> _scannedDocuments = [];

  File? get currentImage => _currentImage;
  List<File> get scannedDocuments => _scannedDocuments;

  void setImage(File image) {
    _currentImage = image;
    notifyListeners();
  }

  void addScannedDocument(File document) {
    _scannedDocuments.add(document);
    _currentImage = null; // Limpiar la imagen actual después de añadir
    notifyListeners();
  }


  void cropImage(Rect cropRect) {
    // Lógica para recortar la imagen usando una librería como 'image'
    // _currentImage = processedImage;
    notifyListeners();
  }

  void enhanceImage() {
    // _currentImage = enhancedImage;
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
    // Lógica para iterar sobre _scannedDocuments y subirlos
    // Usar el paquete 'http' como se mostró anteriormente
    print('Subiendo ${_scannedDocuments.length} documentos...');
    for (var doc in _scannedDocuments) {
      // await uploadImage(doc, 'your_upload_url_here');
    }
    clearAllScans(); // Limpiar después de subir
  }
}