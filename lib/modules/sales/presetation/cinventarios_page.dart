import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
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
  final PageController _pageController = PageController(viewportFraction: 0.85);
  String _currentTitle = 'Original';

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
  void initState() {
    super.initState();
    // Escuchar los cambios en la página del carrusel para actualizar el título
    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      if (currentPage == 0) {
        setState(() {
          _currentTitle = 'Original';
        });
      } else {
        setState(() {
          _currentTitle = 'Blanco y Negro';
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Nuevo método para mostrar el diálogo de confirmación
  void _confirmDelete(BuildContext context, ScannedDocument document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este documento?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                final scanProvider = Provider.of<ScanProvider>(context, listen: false);
                scanProvider.removeDocument(document);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Documento eliminado')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
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
            const Text('Escaner de facturas'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                tooltip: 'Tomar foto',
                icon: const Icon(Icons.camera_alt),
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
      backgroundColor: AppColors.softGrey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Consumer<ScanProvider>(
                builder: (context, provider, child) {
                  if (provider.scannedDocuments.isEmpty) {
                    return const Center(
                      child: Text('No hay documentos escaneados aún.'),
                    );
                  }

                  final currentDocument = provider.currentImage != null
                      ? provider.scannedDocuments.firstWhere(
                        (doc) => File(doc.originalPath).path == provider.currentImage!.path,
                    orElse: () => provider.scannedDocuments.first,
                  )
                      : provider.scannedDocuments.first;

                  final List<File> carouselImages = [
                    File(currentDocument.originalPath),
                    // File(currentDocument.processedPath),
                  ];

                  return Column(
                    children: [
                      // Título en la parte superior del carrusel
                      Text(
                        _currentTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.vividNavy,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: carouselImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.vividNavy, width: 2.0),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: Image.file(
                                    carouselImages[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Indicadores de círculos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(carouselImages.length, (index) {
                          return Container(
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentTitle == (index == 0 ? 'Original' : 'Blanco y Negro')
                                  ? AppColors.vividNavy
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 1,
              child: Consumer<ScanProvider>(
                builder: (context, provider, child) {
                  return provider.scannedDocuments.isEmpty
                      ? const SizedBox.shrink()
                      : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: provider.scannedDocuments.map((document) {
                        final bool isSelected = provider.currentImage != null &&
                            File(document.originalPath).path == provider.currentImage!.path;

                        return GestureDetector(
                          onTap: () {
                            provider.setImage(File(document.originalPath));
                          },
                          onLongPress: () {
                            _confirmDelete(context, document);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              border: isSelected
                                  ? Border.all(color: AppColors.vividNavy, width: 0.4)
                                  : null,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(4.0),
                                bottom: Radius.circular(8.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    child: ColorFiltered(
                                      colorFilter: isSelected
                                          ? ColorFilter.mode(
                                        Colors.black.withOpacity(0.3),
                                        BlendMode.darken,
                                      )
                                          : const ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.srcATop,
                                      ),
                                      child: Image.file(
                                        File(document.thumbnailPath),
                                        width: 80.0,
                                      ),
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Doc.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Consumer<ScanProvider>(
              builder: (context, provider, child) {
                return ElevatedButton.icon(
                  onPressed: provider.scannedDocuments.isEmpty
                      ? null
                      : () {
                    provider.uploadDocuments();
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subiendo documentos...')));
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Subir Documentos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.vividNavy,
                    foregroundColor: AppColors.softGrey,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}