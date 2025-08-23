import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'dart:io';

import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);

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
            const Text('Previsualizar y Editar'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [
              if (scanProvider.scannedDocuments.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: () {
                    scanProvider.uploadDocuments();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Subiendo documentos...')),
                    );
                    Navigator.pop(context); // Volver a la pantalla principal
                  },
                ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(.98),
      body: scanProvider.scannedDocuments.isEmpty
          ? const Center(
        child: Text('No hay documentos escaneados aún.'),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: scanProvider.scannedDocuments.length,
        itemBuilder: (context, index) {
          final document = scanProvider.scannedDocuments[index];
          return Card(
            elevation: 4.0,
            child: InkWell(
              onTap: () {
                scanProvider.setImage(document);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PreviewEditScreen()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.file(
                      document,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Documento ${index + 1}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}