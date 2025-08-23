import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'package:sandra_contab_erp/screen/camera_screen.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sandra_contab_erp/screen/gallery_screen.dart';
import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';

class CinventariosPage extends StatefulWidget {
  const CinventariosPage({super.key});
  @override
  State<CinventariosPage> createState() => _CinventariosPage();
}

class _CinventariosPage extends State<CinventariosPage> {


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
    // Obtenemos la instancia del ScanProvider para llamar a sus métodos
    final scanProvider = Provider.of<ScanProvider>(context, listen: false);

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
            const Text('Escaner de facturas'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Consumer para escuchar los cambios en la lista de documentos
              Consumer<ScanProvider>(
                builder: (context, provider, child) {
                  return Text(
                    'Documentos escaneados: ${provider.scannedDocuments.length}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraScreen()),
                  );

                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Escanear Documento'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<ScanProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton.icon(
                    onPressed: provider.scannedDocuments.isEmpty
                        ? null // Deshabilitar el botón si no hay documentos
                        : () {
                      // Llama al método del provider para subir los documentos
                      provider.uploadDocuments();
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Subiendo documentos...'))
                      );
                    },
                    icon: const Icon(Icons.upload_file),
                    label: const Text('Subir Documentos'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}