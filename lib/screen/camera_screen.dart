// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:sandra_contab_erp/core/theme/app_color.dart';
// import 'dart:io';
// import 'package:sandra_contab_erp/providers/scan_provider.dart';
// import 'package:sandra_contab_erp/screen/gallery_screen.dart';
// import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';
//
// class CameraScreen extends StatelessWidget {
//   const CameraScreen({super.key});
//
//   Future<void> _pickImage(BuildContext context, ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);
//
//     if (pickedFile != null) {
//       final scanProvider = Provider.of<ScanProvider>(context, listen: false);
//       scanProvider.setImage(File(pickedFile.path));
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const PreviewEditScreen()),
//       );
//     } else {
//       print('No image selected.');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//
//       AppBar(
//         foregroundColor: AppColors.softGrey,
//         backgroundColor: AppColors.vividNavy,
//         automaticallyImplyLeading: false,
//         titleSpacing: 0,
//         title: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back),
//               color: AppColors.paleBlue,
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             const Text('Seccion de Escaner'),
//           ],
//         ),
//         actions: <Widget>[
//
//           Row(
//             children: [
//               IconButton(
//                 tooltip: 'Tomar foto',
//                 icon: const Icon(Icons.camera_alt),
//                 onPressed: () {
//                   _pickImage(context, ImageSource.camera);
//                 },
//               ),
//
//               IconButton(
//                 tooltip: 'Seleccionar de Galería',
//                 icon: const Icon(Icons.photo_library),
//                 onPressed: () {
//                   _pickImage(context, ImageSource.gallery);
//                 },
//               ),
//               IconButton(
//                 tooltip: 'Ver documentos',
//                 icon: const Icon(Icons.collections),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => const GalleryScreen()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white.withOpacity(.98),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//
//             const SizedBox(height: 20),
//
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'dart:io';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'package:sandra_contab_erp/screen/gallery_screen.dart';
import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  /// Función para capturar una imagen con ImagePicker (conservada)
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final scanProvider = Provider.of<ScanProvider>(context, listen: false);
      // Conserva el método original de tu proveedor
      scanProvider.setImage(File(pickedFile.path));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PreviewEditScreen()),
      );
    } else {
      print('No image selected.');
    }
  }

  /// Nueva función para usar el escáner de documentos de ML Kit
  Future<void> _scanDocument(BuildContext context) async {
    DocumentScannerOptions documentOptions = DocumentScannerOptions(
      documentFormat: DocumentFormat.jpeg,
      mode: ScannerMode.filter,
      pageLimit: 1,
      isGalleryImport: true,
    );

    try {
      final documentScanner = DocumentScanner(options: documentOptions);
      DocumentScanningResult result = await documentScanner.scanDocument();
      final pdf = result.pdf; // A PDF object.
      final images = result.images;
      print("Control... ");
      print(images);
      print("Final del proceso... ");
    } catch (e) {
      print('Error al escanear: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al escanear: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Escáner'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                tooltip: 'Escanear',
                icon: const Icon(Icons.scanner),
                onPressed: () {
                  _scanDocument(context);
                },
              ),
              // Botón para la cámara tradicional
              IconButton(
                tooltip: 'Tomar foto',
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  _pickImage(context, ImageSource.camera);
                },
              ),
              // Botón para la galería tradicional
              IconButton(
                tooltip: 'Seleccionar de Galería',
                icon: const Icon(Icons.photo_library),
                onPressed: () {
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              // Nuevo botón para el escáner de ML Kit
              IconButton(
                tooltip: 'Escanear documento',
                icon: const Icon(Icons.document_scanner),
                onPressed: () {
                  _scanDocument(context);
                },
              ),
              // Botón para ver los documentos existentes
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
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Seleccione una opción para escanear o ver documentos.',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
