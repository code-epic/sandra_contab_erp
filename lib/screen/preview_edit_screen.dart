import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'package:crop_image/crop_image.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

class PreviewEditScreen extends StatefulWidget {
  const PreviewEditScreen({super.key});

  @override
  State<PreviewEditScreen> createState() => _PreviewEditScreenState();
}

class _PreviewEditScreenState extends State<PreviewEditScreen> {
  final _cropController = CropController();

  Future<void> _saveCroppedImage() async {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final ui.Image? croppedUiImage = await _cropController.croppedBitmap(
      quality: FilterQuality.high,
    );

    if (croppedUiImage != null) {
      // Ya que croppedUiImage es un ui.Image, puedes llamar a toByteData
      final imageBytes = await croppedUiImage.toByteData(format: ui.ImageByteFormat.png);

      if (imageBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/cropped_image.png');
        await tempFile.writeAsBytes(imageBytes.buffer.asUint8List());
        scanProvider.setImage(tempFile);
      }
    }
  }


  void _enhanceImage() {
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    scanProvider.enhanceImage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ScanProvider>(
      builder: (context, scanProvider, child) {
        if (scanProvider.currentImage == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('No hay imagen para previsualizar.')),
          );
        }

        return Scaffold(
          appBar: AppBar(

            title: const Text('Previsualizar y Editar'),
            actions: [
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () async {
                  await _saveCroppedImage();
                  scanProvider.addScannedDocument(scanProvider.currentImage!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Center(
            child: CropImage(
              controller: _cropController,
              image: Image.file(scanProvider.currentImage!),
              alwaysShowThirdLines: true,
              paddingSize: 25.0,
              alwaysMove: true,
            ),
          ),
          bottomNavigationBar: _buildButtons(),
        );
      },
    );
  }

  // --- Botones adaptados del demo ---
  Widget _buildButtons() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.crop_free),
            onPressed: () {
              _cropController.aspectRatio = null;
              _cropController.rotation = CropRotation.up;
              _cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
            },
          ),
          IconButton(
            icon: const Icon(Icons.aspect_ratio),
            onPressed: _showAspectRatiosDialog,
          ),
          IconButton(
            icon: const Icon(Icons.rotate_left),
            onPressed: () => _cropController.rotateLeft(),
          ),
          IconButton(
            icon: const Icon(Icons.rotate_right),
            onPressed: () => _cropController.rotateRight(),
          ),
          ElevatedButton(
            onPressed: _enhanceImage,
            child: const Text('Mejorar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showAspectRatiosDialog() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Seleccionar relación de aspecto'),
          children: [
            SimpleDialogOption(onPressed: () => Navigator.pop(context, -1.0), child: const Text('Libre')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 1.0), child: const Text('Cuadrado')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 2.0), child: const Text('2:1')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 1 / 2), child: const Text('1:2')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 4.0 / 3.0), child: const Text('4:3')),
            SimpleDialogOption(onPressed: () => Navigator.pop(context, 16.0 / 9.0), child: const Text('16:9')),
          ],
        );
      },
    );
    if (value != null) {
      _cropController.aspectRatio = value == -1 ? null : value;
      _cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }
}