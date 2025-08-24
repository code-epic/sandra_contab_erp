import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sandra_contab_erp/screen/gallery_screen.dart';
import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

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


  Future<void> _scanDocument(BuildContext context) async {
    DocumentScannerOptions documentOptions = DocumentScannerOptions(
      documentFormat: DocumentFormat.jpeg,
      mode: ScannerMode.filter,
      pageLimit: 5,
      isGalleryImport: true,
    );

    try {
      final documentScanner = DocumentScanner(options: documentOptions);
      DocumentScanningResult result = await documentScanner.scanDocument();
      // final pdf = result.pdf;
      final images = result.images;
      if (result.images.isNotEmpty) {
        final scanProvider = Provider.of<ScanProvider>(context, listen: false);
        for (var path in result.images) {
          final tmpFile = File(path);
          scanProvider.setImage(tmpFile);
          print("cargando imagen del proceo ${path}");
          String documentCode = '17522251';
          await scanProvider.addProcessedDocument(tmpFile, documentCode);
        }
      }


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
            const Text('Escanear de facturas'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              // Botón para subir archivos
              IconButton(
                tooltip: 'Subir archivos',
                icon: const Icon(Icons.upload_file),
                onPressed: scanProvider.scannedDocuments.isNotEmpty
                    ? () {
                  scanProvider.uploadDocuments();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Subiendo archivos...'),
                    ),
                  );
                }
                    : null,
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

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Muestra un menú de opciones cuando se presiona el FAB
          showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.document_scanner),
                      title: const Text('Escanear documento'),
                      onTap: () {
                        Navigator.pop(context);
                        _scanDocument(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.camera_alt),
                      title: const Text('Tomar foto'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(context, ImageSource.camera);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Seleccionar de Galería'),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(context, ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: AppColors.vividNavy,
        tooltip: 'Opciones de Escaneo',
        child: const Icon(Icons.add_a_photo, color: AppColors.paleBlue),
      ),
    );
  }
}