import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'package:crop_image/crop_image.dart';
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
  bool _isLoading = false; // Variable de estado para controlar el indicador de carga

  Future<void> _saveCroppedImage() async {
    // Activa el estado de carga
    setState(() {
      _isLoading = true;
    });

    final scanProvider = Provider.of<ScanProvider>(context, listen: false);
    final ui.Image? croppedUiImage = await _cropController.croppedBitmap(
      quality: FilterQuality.high,
    );

    if (croppedUiImage != null) {
      final imageBytes = await croppedUiImage.toByteData(format: ui.ImageByteFormat.png);

      if (imageBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final String fileName = 'FACT_${DateTime.now().millisecondsSinceEpoch}.png';
        final tempFile = File('${tempDir.path}/$fileName');

        await tempFile.writeAsBytes(imageBytes.buffer.asUint8List());
        scanProvider.setImage(tempFile);

        // All asynchronous operations must be awaited before proceeding
        String documentCode = '17522251';
        await scanProvider.addProcessedDocument(tempFile, documentCode);

        // Deactivate loading state after all async tasks are done
        setState(() {
          _isLoading = false;
        });

        // Pop the screen only after all async operations and state updates are complete
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } else {
      // If no image is cropped, deactivate loading state and pop
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }

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
            foregroundColor: AppColors.softGrey,
            backgroundColor: AppColors.vividNavy,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: AppColors.paleBlue,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                ),
                const Text('Escaner de facturas'),
              ],
            ),
            actions: <Widget>[
              _isLoading
                  ? const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  ),
                ),
              )
                  : IconButton(
                tooltip: 'Guardar y salir',
                icon: const Icon(Icons.check),
                onPressed: _saveCroppedImage,
              ),
            ],
          ),
            body: Stack(
              children: [
                Center(
                  child: CropImage(
                    controller: _cropController,
                    image: Image.file(scanProvider.currentImage!),
                    alwaysShowThirdLines: true,
                    paddingSize: 25.0,
                    alwaysMove: true,
                  ),
                ),
                // Loading overlay
                if (_isLoading)
                  const Positioned.fill(
                    child: AbsorbPointer(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            ),
          bottomNavigationBar: _buildButtons(),
        );
      },
    );
  }

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