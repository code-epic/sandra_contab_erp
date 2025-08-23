import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/models/api_service.dart' show ApiService;
import 'package:sandra_contab_erp/core/models/storage_job.dart';
import 'package:sandra_contab_erp/core/models/upload_service.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'dart:io';
import 'dart:math';

import 'package:sandra_contab_erp/core/theme/modal_show.dart';
import 'package:sandra_contab_erp/modules/login/presentation/registration_step_4.dart';

class RegistrationStep3Page extends StatefulWidget {
  const RegistrationStep3Page({super.key});

  @override
  State<RegistrationStep3Page> createState() => _RegistrationStep3PageState();
}

class _RegistrationStep3PageState extends State<RegistrationStep3Page> {
  final UploadService _uploadService = UploadService();
  final ImagePicker _picker = ImagePicker();
  final ApiService _apiService = ApiService();


  File? _rifImage;
  File? _cedulaFrontImage;
  File? _cedulaBackImage;
  File? _carnetContadorImage;
  bool _isLoading = false;
  TextEditingController _nombreCompletoController = TextEditingController();
  TextEditingController _cedulaController = TextEditingController();



  String cedula = "";
  String nombreCompleto = "";
  String tipoDocumento = "V"; // V de Venezolano


  Future<void> _initToken() async{
    Map<String, dynamic> valores = {
      'nombre': 'loginQR',
      'clave': '1234',
    };

    final result = await _apiService.ejecutar(valores: valores, type: 2 );
    if (result.containsKey('msj') && result['msj'] != null) {
      AlertService.ShowAlert(context, result['msj']);
    }else if (result.containsKey('token') && result['token'] != null) {
      StorageJob.instance.saveJWT('recovery', result['token']);
    }

  }


  @override
  void initState() {
    super.initState();
    _initToken();
  }

  Future<void> _searchID() async {
    setState(() {
      nombreCompleto = "";
      _nombreCompletoController.text = "";
    });
    cedula = _cedulaController.text.trim();

    if (cedula.isEmpty) {
      AlertService.ShowAlert(context, "Por favor ingrese una cédula válida.");
      return;
    }
    String? token = await StorageJob.instance.getJWT('recovery');
    if (token == null) {
      throw Exception('No JWT token found');
    }
    print(token);

    try {
      final result = await _apiService.ejecutar(
        funcion: "MPPD_CCedulaSaime",
        parametros: '${cedula}',
        token: token,
      );

      if (result.containsKey('msj') && result['msj'] != null) {
        AlertService.ShowAlert(context, result['msj']);
      }

      if (result.containsKey('Cuerpo') && result['Cuerpo'] != null) {
        AlertService.ShowAlert(context, "Cargando, por favor espere...", type: 2);
        setState(() {
          for (var item in result['Cuerpo']) {
            nombreCompleto = "${item['apellido1']} ${item['apellido2']} ${item['nombre1']} ${item['nombre2']}";
            _nombreCompletoController.text = nombreCompleto;
          }
          AlertService.HideAlert(context);
        });
      } else {
        print("No se encontró el cuerpo.");
      }
    } catch (e) {
      print("Error en ejecutar: $e");
    }
  }

  Future<void> _captureImage(Function(File) onImageCaptured, String codigo) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    String fileName = '${codigo}${cedula}.jpg';
    File imageFile = File(image.path);
    String newPath = '${imageFile.parent.path}/$fileName';

    await imageFile.rename(newPath);

    if (mounted) {
      onImageCaptured(File(newPath));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _uploadAllFiles() async {
    AlertService.ShowAlert(context, "Subiendo archivos, por favor espere...", type: 2);

    if (!_isFormValid) return;
    setState(() => _isLoading = true);
    try {
      final files = <String, List<File>>{
        "archivos": [
          _rifImage!,
          _cedulaFrontImage!,
          _cedulaBackImage!,
          _carnetContadorImage!,
        ],
      };

      print(files);

      final fields = {
        "identificador": 'REG-${cedula}',
        "usuario": "USUARIO_ID",
      };

      final stream = _uploadService.uploadFiles(files, fields);

      stream.listen((event) async {
        print("Progreso: ${(event.progress * 100).toStringAsFixed(2)}%");
        if (event.state == "DONE") {
          print("Archivos subidos correctamente.");
          AlertService.HideAlert(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RegistrationStep4Page(cedula: cedula, nombreCompleto: nombreCompleto),
            ),
          );
        }
      });
    } catch (e) {
      print("Error al subir archivos: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool get _isFormValid {
    return _rifImage != null &&
        _cedulaFrontImage != null &&
        _cedulaBackImage != null &&
        _carnetContadorImage != null &&
        cedula.isNotEmpty &&
        nombreCompleto.isNotEmpty;
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
                padding: const EdgeInsets.only(left: 24, top: 64, right: 12, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textoRequisitos(
                      'Por favor, todos los campos son requeridos.',
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: DropdownButtonFormField<String>(
                              value: tipoDocumento,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Tipo',
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'V', child: Text('V')),
                                DropdownMenuItem(value: 'E', child: Text('E')),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  tipoDocumento = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: _cedulaController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Número de Cédula",
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    _searchID();
                                  },
                                  icon: const Icon(Icons.search),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              textInputAction: TextInputAction.done,
                              onEditingComplete: () {
                                _searchID();
                              },
                            ),

                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      enabled: false,
                      controller: _nombreCompletoController,
                      decoration: InputDecoration(
                        labelText: "Nombre Completo",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    const SizedBox(height: 32),
                    AnimatedOpacity(
                      opacity: nombreCompleto.isNotEmpty ? 1.0 : 0.0,
                      duration: Duration(seconds: 1),
                      child: Column(
                        children: [
                          _buildDocumentCaptureWidget(
                            context,
                            title: 'RIF',
                            image: _rifImage,
                            onTap: () => _captureImage((file) => setState(() => _rifImage = file), 'RIF-'),
                          ),
                          const SizedBox(height: 24),
                          _buildDocumentCaptureWidget(
                            context,
                            title: 'Cédula (Parte Frontal)',
                            image: _cedulaFrontImage,
                            onTap: () => _captureImage((file) => setState(() => _cedulaFrontImage = file), 'CDF-'),
                          ),
                          const SizedBox(height: 24),
                          _buildDocumentCaptureWidget(
                            context,
                            title: 'Cédula (Parte Posterior)',
                            image: _cedulaBackImage,
                            onTap: () => _captureImage((file) => setState(() => _cedulaBackImage = file), 'CEB-'),
                          ),
                          const SizedBox(height: 24),
                          _buildDocumentCaptureWidget(
                            context,
                            title: "Carnet de Contador",
                            image: _carnetContadorImage,
                            onTap: () => _captureImage((file) => setState(() => _carnetContadorImage = file), 'CAR-'),
                          ),
                        ],
                      ),
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
                      onPressed: _isFormValid ? _uploadAllFiles : null,
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
