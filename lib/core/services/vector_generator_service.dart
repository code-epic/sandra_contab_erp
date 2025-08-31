// Archivo: lib/services/vector_generator_service.dart

import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class VectorGeneratorService {
  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  late final Map<String, int> _vocab;
  static const int _sequenceLength = 128;

  VectorGeneratorService();

  Future<void> loadModel() async {
    // CORRECCIÓN: Si el modelo ya está cargado, salimos del método inmediatamente.
    if (_isModelLoaded) {
      print('Modelo TFLite y vocabulario ya están cargados.');
      return;
    }

    try {
      final vocabString = await rootBundle.loadString('assets/models/vocab.txt');
      _vocab = _loadVocab(vocabString);

      final options = InterpreterOptions();
      _interpreter = await Interpreter.fromAsset('assets/models/all-MiniLM-L6-v2.tflite', options: options);

      _isModelLoaded = true;
      print('Modelo TFLite y vocabulario cargados exitosamente.');
    } catch (e) {
      print('Error al cargar el modelo o el vocabulario: $e');
      rethrow;
    }
  }

  Future<List<double>> generateVector(String text) async {
    await loadModel();

    // **CORRECCIÓN CLAVE:** El tokenizador mejorado se encarga de la lógica.
    final tokenIds = _tokenize(text, _vocab);

    final input = [Int32List.fromList(tokenIds)];

    final outputTensor = _interpreter!.getOutputTensor(0);
    final outputShape = outputTensor.shape;
    final output = List.filled(outputShape[1], 0.0).reshape([1, outputShape[1]]);

    _interpreter!.run(input, output);

    return output[0].cast<double>();
  }

  void dispose() {
    if (_isModelLoaded) {
      _interpreter?.close();
      _isModelLoaded = false;
    }
  }

  Map<String, int> _loadVocab(String vocabString) {
    final vocab = <String, int>{};
    final lines = vocabString.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty) {
        vocab[line] = i;
      }
    }
    return vocab;
  }

  List<int> _tokenize(String text, Map<String, int> vocab) {
    final tokens = <String>[];
    // Dividimos el texto en palabras.
    final words = text.toLowerCase().split(RegExp(r'\s+|[.,!?;]'));

    tokens.add('[CLS]');

    for (var word in words) {
      if (word.isEmpty) continue;

      String remaining = word;
      while (remaining.isNotEmpty) {
        String subword = '';
        int i = remaining.length;
        while (i > 0) {
          String candidate = i == remaining.length ? remaining : '##' + remaining.substring(remaining.length - i);
          if (vocab.containsKey(candidate)) {
            subword = candidate;
            break;
          }
          i--;
        }

        if (subword.isEmpty) {
          // Si no encontramos un token, usamos el token de desconocido.
          tokens.add('[UNK]');
          break;
        }

        tokens.add(subword);
        remaining = remaining.substring(0, remaining.length - i);
      }
    }

    tokens.add('[SEP]');

    final tokenIds = tokens.map((token) => vocab[token] ?? vocab['[UNK]'] ?? 100).toList();

    while (tokenIds.length < _sequenceLength) {
      tokenIds.add(vocab['[PAD]'] ?? 0);
    }

    return tokenIds.sublist(0, _sequenceLength);
  }

}