import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'dart:io';
import 'dart:math';

// Nueva página para la captura de documentos (RegistrationStep3Page)
class RegistrationStep3Page extends StatefulWidget {
  const RegistrationStep3Page({super.key});

  @override
  State<RegistrationStep3Page> createState() => _RegistrationStep3PageState();
}

class _RegistrationStep3PageState extends State<RegistrationStep3Page> {
  File? _rifImage;
  File? _cedulaFrontImage;
  File? _cedulaBackImage;
  bool _isLoading = false;

  // Usa ImagePicker para seleccionar una imagen (cámara o galería)
  // Nota: Esto es un ejemplo. En un entorno real, necesitarías permisos.
  // final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage(Function(File) onImageCaptured) async {
    // Simula la captura de una imagen.
    // En un entorno real, usarías 'final XFile? image = await _picker.pickImage(source: ImageSource.camera);'
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    // Simula la creación de un archivo para evitar errores de tipo nulo
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/temp_image_${Random().nextInt(1000)}.png');
    // En un caso real, la imagen tendría contenido. Aquí es un placeholder.
    await tempFile.writeAsBytes(List.generate(100, (i) => i));

    if (mounted) {
      onImageCaptured(tempFile);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _uploadFiles() async {
    setState(() {
      _isLoading = true;
    });

    // Simula el envío de los archivos a un servicio.
    // En un entorno real, aquí harías la llamada a la API.
    await Future.delayed(const Duration(seconds: 2));

    // Si el proceso de subida es exitoso, navega al siguiente paso.
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      context.push('/registration_step_4');
    }
  }

  bool get _isFormValid {
    return _rifImage != null && _cedulaFrontImage != null && _cedulaBackImage != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: Container(

        child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only( left: 24, top: 94, right:12, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textoRequisitos(
                    'Por favor, suba una foto de su RIF y de su Cédula de Identidad.'
                  ),
                  const SizedBox(height: 32),
                  _buildDocumentCaptureWidget(
                    context,
                    title: 'RIF',
                    image: _rifImage,
                    onTap: () => _captureImage((file) => setState(() => _rifImage = file)),
                  ),
                  const SizedBox(height: 24),
                  _buildDocumentCaptureWidget(
                    context,
                    title: 'Cédula (Parte Frontal)',
                    image: _cedulaFrontImage,
                    onTap: () => _captureImage((file) => setState(() => _cedulaFrontImage = file)),
                  ),
                  const SizedBox(height: 24),
                  _buildDocumentCaptureWidget(
                    context,
                    title: 'Cédula (Parte Posterior)',
                    image: _cedulaBackImage,
                    onTap: () => _captureImage((file) => setState(() => _cedulaBackImage = file)),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => context.pop('/registration_step_2'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.steelBlue),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.steelBlue),
                    label: const Text(
                      'Ir atrás',
                      style: TextStyle(color: AppColors.steelBlue),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isFormValid ? _uploadFiles : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? AppColors.steelBlue : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    icon: _isLoading
                        ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    label: Text(_isLoading ? 'Subiendo...' : 'Siguiente'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildDocumentCaptureWidget(BuildContext context, {
    required String title,
    required File? image,
    required VoidCallback onTap,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: image == null ? AppColors.paleBlue : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: image == null ? AppColors.steelBlue : AppColors.steelBlue.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: image == null ? null : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: image == null
                ? Center(
              child: Icon(
                Icons.camera_alt,
                color: AppColors.steelBlue.withOpacity(0.7),
                size: 40,
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                // Aquí se simula la carga de la imagen real.
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
      ],
    );
  }
}