import 'package:flutter/material.dart';

class VoiceCommand {
  final String phrase;
  final Function(BuildContext context) action;

  VoiceCommand({
    required this.phrase,
    required this.action,
  });
}

class CommandExecutor {
  final String triggerWord;
  final List<VoiceCommand> commands;

  CommandExecutor({
    required this.triggerWord,
    required this.commands,
  });

  void execute(BuildContext context, String recognizedText) {
    final lowerCaseText = recognizedText.toLowerCase();

    final regex = RegExp(r'^(?:sandra)[,\s]*(.*)$', caseSensitive: false);
    final match = regex.firstMatch(lowerCaseText);

    if (match == null) {
      debugPrint(
          'Comando no activado. No comienza con la palabra clave "Sandra".');
      return;
    }

    final commandPhrase = match.group(1)?.trim() ?? '';

    final bestMatch = _findBestCommandMatch(commandPhrase);

    if (bestMatch != null) {
      bestMatch.action(context);
    }
  }

  VoiceCommand? _findBestCommandMatch(String inputPhrase) {
    VoiceCommand? bestMatch;
    double bestScore = 0;

    for (final command in commands) {
      final score = _calculateSimilarityScore(inputPhrase, command.phrase.toLowerCase());
      if (score > bestScore && score > 0.5) { // Umbral de similitud del 50%
        bestScore = score;
        bestMatch = command;
      }
    }

    return bestMatch;
  }

  double _calculateSimilarityScore(String a, String b) {
    // Implementación simple de similitud de cadenas
    // Puedes mejorar esto con algoritmos más sofisticados como Levenshtein distance
    final aWords = a.split(' ');
    final bWords = b.split(' ');

    int matches = 0;
    for (final aWord in aWords) {
      for (final bWord in bWords) {
        if (aWord.contains(bWord) || bWord.contains(aWord)) {
          matches++;
          break;
        }
      }
    }

    return matches / aWords.length;
  }
}

