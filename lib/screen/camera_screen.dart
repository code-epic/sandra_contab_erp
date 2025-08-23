import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart';
import 'dart:io';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'package:sandra_contab_erp/screen/gallery_screen.dart';
import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      scanProvider.setImage(File(pickedFile.path));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PreviewEditScreen()),
      );
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:

      AppBar(
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
              // quita padding extra
              constraints: const BoxConstraints(),
              // quita tamaño mínimo
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Seccion de Escaner'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [
              // Icono 1: Plan de Cuentas
              IconButton(
                tooltip: 'Tomar foto', // Texto que aparece al pasar el cursor
                icon: const Icon(Icons.camera_alt), // Icono minimalista
                onPressed: () {
                  _pickImage(context, ImageSource.camera);
                },
              ),

              IconButton(
                tooltip: 'Seleccionar de Galería',
                icon: const Icon(Icons.photo_library),
                onPressed: () {
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              // Icono 6: Un icono de ejemplo adicional si lo necesitas, por ejemplo, para configuración
              IconButton(
                tooltip: 'Ver documentos',
                icon: const Icon(Icons.collections),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const GalleryScreen()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(.98),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}