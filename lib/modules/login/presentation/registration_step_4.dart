import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandra_contab_erp/core/models/api_service.dart';
import 'dart:io';

import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/modal_show.dart';
import 'package:sandra_contab_erp/modules/login/presentation/onboarding_page.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistrationStep4Page extends StatefulWidget {
  final String cedula;

  const RegistrationStep4Page({Key? key, required this.cedula}) : super(key: key);

  @override
  _RegistrationStep4PageState createState() => _RegistrationStep4PageState();
}

class _RegistrationStep4PageState extends State<RegistrationStep4Page> {
  final ApiService _apiService = ApiService();
  TextEditingController _correoController = TextEditingController();
  TextEditingController _claveController = TextEditingController();
  TextEditingController _repetirClaveController = TextEditingController();

  FocusNode _correoFocusNode = FocusNode();
  FocusNode _claveFocusNode = FocusNode();
  FocusNode _repetirClaveFocusNode = FocusNode();

  File? _profileImage;

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  bool _doPasswordsMatch() {
    return _claveController.text == _repetirClaveController.text;
  }

  void _moveToNextFocus(FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  bool get _isFormValid {
    return _correoController.text.isNotEmpty &&
        _claveController.text.length >= 8 &&
        _doPasswordsMatch() &&
        _repetirClaveController.text.isNotEmpty &&
        _profileImage != null;
  }

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {});
    }
  }

  Future<void> _takeProfilePicture() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front, // Usamos la cámara frontal
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _Registrar() async {

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = '';
    String deviceName = '';
    String deviceDescription = '';
    String macAddress = '';
    String deviceBrand = '';
    String deviceManufacturer = '';
    String osVersion = '';

    // Obtener el ID del dispositivo y detalles del dispositivo
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.id;
      deviceName = androidInfo.model;
      deviceDescription = androidInfo.device;
      deviceBrand = androidInfo.brand;
      deviceManufacturer = androidInfo.manufacturer;
      osVersion = androidInfo.version.release;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? '';
      deviceName = iosInfo.utsname.machine ?? '';
      deviceDescription = iosInfo.systemName ?? '';
      deviceBrand = 'Apple';
      deviceManufacturer = 'Apple';
      osVersion = iosInfo.systemVersion;
    }

    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      String hashedPassword = _apiService.ConvertToSHA256(_claveController.text);

      Map<String, dynamic> registrationData = {
        'cedula': widget.cedula,
        'correo': _correoController.text,
        'clave': hashedPassword,
        'latitud': position.latitude,
        'longitud': position.longitude,
        'device_id': deviceId,
        'device_name': deviceName,
        'device_description': deviceDescription,
        'device_brand': deviceBrand,
        'device_manufacturer': deviceManufacturer,
        'os_version': osVersion,
      };

      String jsonData = json.encode(registrationData);
      print(jsonData);
    } else {
      AlertService.ShowAlert(context, "Error con los permisos para crear una cuenta ", type: 1);
    }



  }

  Future<bool> _onWillPop() async {
    // Mostrar un diálogo de confirmación
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('¿Estás seguro?'),
        content: Text('Si vas atrás, perderás los datos no guardados.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Cerrar el diálogo sin salir
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirmar salida
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => OnboardingPage()), // Cambia al OnboardingPage
              );
            },
            child: Text('Sí, salir'),
          ),
        ],
      ),
    ) ??
        false; // Si el diálogo se cierra sin elegir, no se hace nada
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop, // Interceptar el botón de retroceso
        child: Scaffold(

      backgroundColor: AppColors.softGrey,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),

                    // Instrucciones claras antes de tomar la foto
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Por favor, toma una foto de tu rostro con la cámara frontal.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Botón circular para tomar foto (cámara frontal)
                    Center(
                      child: GestureDetector(
                        onTap: _takeProfilePicture,
                        child: CircleAvatar(
                          radius: 75, // Tamaño del círculo
                          backgroundColor: AppColors.vividNavy,
                          child: _profileImage == null
                              ? Container(
                            child: Icon(Icons.camera_alt, size: 50, color: Colors.white), // Icono de la cámara
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(75.0), // Ajuste redondeado de la imagen
                            child: Container(
                              child: Image.file(
                                _profileImage!,
                                fit: BoxFit.cover, // Asegura que la imagen ocupe todo el espacio disponible
                                width: 150, // Tamaño de la imagen
                                height: 150, // Tamaño de la imagen
                              ),
                            ),
                          ),
                        ),
                      ),



                    ),
                    SizedBox(height: 16),

                    // Mostrar cédula debajo de la foto
                    Center(
                      child: Text(
                        "Cédula: ${widget.cedula}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.steelBlue,
                        ),
                      ),
                    ),
                    SizedBox(height: 32),

                    // Formulario con validaciones
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Correo
                          TextFormField(
                            controller: _correoController,
                            focusNode: _correoFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Correo",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email, color: AppColors.steelBlue),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "El correo es requerido";
                              } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(value)) {
                                return "Por favor ingrese un correo válido";
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              _moveToNextFocus(_correoFocusNode, _claveFocusNode);
                            },
                            onChanged: (_) => _validateForm(),
                          ),
                          SizedBox(height: 16),

                          // Clave
                          TextFormField(
                            controller: _claveController,
                            focusNode: _claveFocusNode,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Clave",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock, color: AppColors.steelBlue),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: AppColors.steelBlue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "La clave es requerida";
                              } else if (value.length < 8) {
                                return "La clave debe tener al menos 8 caracteres";
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              _validateForm();
                              _moveToNextFocus(_claveFocusNode, _repetirClaveFocusNode);
                            },
                            onChanged: (_) => _validateForm(),
                          ),
                          SizedBox(height: 16),

                          // Repetir clave (se asegura de ser visible)
                          TextFormField(
                            controller: _repetirClaveController,
                            focusNode: _repetirClaveFocusNode,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: "Repetir Clave",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock, color: AppColors.steelBlue),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                  color: AppColors.steelBlue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "La repetición de clave es requerida";
                              } else if (!_doPasswordsMatch()) {
                                return "Las claves no coinciden";
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              _validateForm();
                            },
                            onChanged: (_) => _validateForm(),
                          ),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Spacer para empujar el botón al fondo


            // Botón Registrar al final
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton.icon(
                  onPressed: _isFormValid ? _Registrar : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid ? AppColors.steelBlue : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    minimumSize: Size(150, 50),
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
                      : const Icon(Icons.check, size: 16),
                  label: Text(
                    _isLoading ? 'Registrando...' : 'Registrar',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );

  }
}
