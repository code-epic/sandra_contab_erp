

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/api_service.dart';
import 'package:sandra_contab_erp/core/models/empresa.dart';
import 'package:sandra_contab_erp/core/services/vector_generator_service.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';


class FormClienteScreen extends StatefulWidget {
  final Empresa? cliente;
  const FormClienteScreen({super.key, this.cliente});

  @override
  State<FormClienteScreen> createState() => _FormClienteScreenState();
}


class _FormClienteScreenState extends State<FormClienteScreen> {
  // Controladores de texto
  late final _nombreComercialCtrl = TextEditingController(text: widget.cliente?.nombreComercial);
  late final _razonSocialCtrl     = TextEditingController(text: widget.cliente?.razonSocial);
  late final _rifCtrl             = TextEditingController(text: widget.cliente?.rif);
  late final _actividadEconCtrl   = TextEditingController(text: widget.cliente?.actividadEconomica);
  late final _telefonoCtrl        = TextEditingController(text: widget.cliente?.telefono);
  late final _correoCtrl          = TextEditingController(text: widget.cliente?.correoElectronico);
  late final _direccionCtrl       = TextEditingController(text: widget.cliente?.direccionFiscal);
  late final _rubroCtrl           = TextEditingController();



  File? _logoFile;
  final List<File> _docsFiles = [];
  final List<String> _rubros = [];

  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Cargar documentos digitales existentes si se está editando
    if (widget.cliente?.documentosDigitales != null) {
      _docsFiles.addAll(
        widget.cliente!.documentosDigitales.map((path) => File(path)).toList(),
      );
    }
    // Cargar rubros económicos existentes
    if (widget.cliente?.rubroEconomico != null) {
      _rubros.addAll(widget.cliente!.rubroEconomico);
    }
  }

  @override
  void dispose() {
    _nombreComercialCtrl.dispose();
    _razonSocialCtrl.dispose();
    _rifCtrl.dispose();
    _actividadEconCtrl.dispose();
    _telefonoCtrl.dispose();
    _correoCtrl.dispose();
    _direccionCtrl.dispose();
    _rubroCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _logoFile = File(picked.path));
  }

  Future<void> _pickDocs() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() => _docsFiles.addAll(result.paths.map((p) => File(p!))));
    }
  }

  void _addRubro() {
    final text = _rubroCtrl.text.trim();
    if (text.isNotEmpty && !_rubros.contains(text)) {
      setState(() {
        _rubros.add(text);
        _rubroCtrl.clear();
      });
    }
  }

  void _removeRubro(String rubro) {
    setState(() => _rubros.remove(rubro));
  }

  void _removeDoc(int idx) => setState(() => _docsFiles.removeAt(idx));

  void _guardar() async {
    if (_formKey.currentState!.validate()) {
      try {
        final _vectorGeneratorService = VectorGeneratorService();

        // 1. Crear la cadena de texto vectorizable directamente de los controladores
        final textoVectorizable = '${_nombreComercialCtrl.text} ${_razonSocialCtrl.text} ${_rifCtrl.text} ${_actividadEconCtrl.text} ${_rubros.join(' ')}';

        // 2. Generar el vector a partir de la cadena de texto
        final perfilVector = await _vectorGeneratorService.generateVector(textoVectorizable);

        // 3. Crear la única y definitiva instancia de Empresa con el vector ya generado
        final _empresa = Empresa(
          id: widget.cliente?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          nombreComercial: _nombreComercialCtrl.text,
          razonSocial: _razonSocialCtrl.text,
          rif: _rifCtrl.text,
          actividadEconomica: _actividadEconCtrl.text,
          telefono: _telefonoCtrl.text,
          correoElectronico: _correoCtrl.text,
          direccionFiscal: _direccionCtrl.text,
          rubroEconomico: _rubros,
          tipoSociedad: null,
          estatusSeniat: null,
          contadorId: null,
          documentosDigitales: _docsFiles.map((f) => f.path).toList(),
          perfilVector: perfilVector, // Se pasa el vector aquí
          fechaCreacion: DateTime.now(),
          ultimaActualizacion: DateTime.now(),
        );

        print(_empresa.toJson());

        final result = await _apiService.ejecutar(funcion: 'CTAB_IEmpresa', valores: _empresa.toJson());

        if (result.containsKey('msj') && result['msj'] != null) {


        } else if (result.containsKey('Cuerpo')) {
          print(result['Cuerpo']);
        }
        print(result);
        Navigator.of(context).pop(_empresa);
      } catch (e) {
        print('Error al cargar el modelo TFLite: $e');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: AppColors.vividNavy,
        backgroundColor: AppColors.softGrey,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              color: AppColors.vividNavy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(PhosphorIcons.arrowLeft()),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(
              widget.cliente == null ? 'Nueva Empresa' : 'Editar Empresa',
            )
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.floppyDisk(), color: AppColors.vividNavy),
            onPressed: _guardar,
          ),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            // Sección de Información Básica (Nombre, RIF)
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Información Principal', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textVividNavy.withOpacity(0.9),
                    ),),
                    const SizedBox(height: 16),
                    // Logo y campos de texto lado a lado
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLogoPicker(),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            children: [
                              _buildTextField(_nombreComercialCtrl, 'Nombre Comercial', isRequired: true),
                              const SizedBox(height: 12),
                              _buildTextField(_rifCtrl, 'RIF (J-XXXXXXXX-X)', isRequired: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(_razonSocialCtrl, 'Razón Social'),
                    const SizedBox(height: 12),
                    _buildTextField(_actividadEconCtrl, 'Actividad Económica', isRequired: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Sección de Contacto
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datos de Contacto', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textVividNavy.withOpacity(0.9),
                    ),),
                    const SizedBox(height: 16),
                    _buildTextField(_telefonoCtrl, 'Teléfono'),
                    const SizedBox(height: 12),
                    _buildTextField(_correoCtrl, 'Correo Electrónico', keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    _buildTextField(_direccionCtrl, 'Dirección Fiscal', maxLines: 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Sección de Rubros Económicos
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rubros Económicos', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textVividNavy.withOpacity(0.9),
                    ),),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(_rubroCtrl, 'Agregar rubro'),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: Icon(PhosphorIcons.plusCircle(), color: AppColors.purpleSoftmax),
                          onPressed: _addRubro,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _rubros.map((rubro) {
                        return Chip(
                          label: Text(rubro),
                          backgroundColor: AppColors.greenSoft.withOpacity(0.5),
                          deleteIcon: Icon(PhosphorIcons.xCircle(), size: 18),
                          onDeleted: () => _removeRubro(rubro),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Sección de Documentos Digitales
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Documentos Digitales', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textVividNavy.withOpacity(0.9),
                    ),),
                    const SizedBox(height: 16),
                    // Nuevo selector de documentos
                    DocumentSelector(
                      files: _docsFiles,
                      onPickFiles: _pickDocs,
                      onRemoveFile: _removeDoc,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPicker() {
    return GestureDetector(
      onTap: _pickLogo,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.purpleSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.purpleSoftmax.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
          image: _logoFile != null
              ? DecorationImage(
            image: FileImage(_logoFile!),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: _logoFile == null
            ? Icon(PhosphorIcons.camera(), size: 40, color: AppColors.purpleSoftmax)
            : null,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isRequired = false, int? maxLines, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textVividNavy),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.textVividNavy.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.textVividNavy.withOpacity(0.1), width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.purpleSoftmax, width: 2.0),
        ),
      ),
      validator: (v) => isRequired && (v == null || v.isEmpty) ? 'Campo obligatorio' : null,
    );
  }
}

class DocumentSelector extends StatelessWidget {
  final List<File> files;
  final VoidCallback onPickFiles;
  final Function(int) onRemoveFile;

  const DocumentSelector({
    super.key,
    required this.files,
    required this.onPickFiles,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onPickFiles,
          icon: Icon(PhosphorIcons.uploadSimple()),
          label: const Text('Adjuntar documentos'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textVividNavy,
            side: BorderSide(color: AppColors.textVividNavy.withOpacity(0.2)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        if (files.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 150, // Altura fija para la lista de documentos
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DocumentTile(
                    file: file,
                    onRemove: () => onRemoveFile(index),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class DocumentTile extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const DocumentTile({
    super.key,
    required this.file,
    required this.onRemove,
  });

  IconData _getIconForFile(String filePath) {
    if (filePath.endsWith('.pdf')) return PhosphorIcons.filePdf();
    if (filePath.endsWith('.jpg') || filePath.endsWith('.png') || filePath.endsWith('.jpeg')) return PhosphorIcons.fileImage();
    if (filePath.endsWith('.xlsx') || filePath.endsWith('.xls')) return PhosphorIcons.fileXls();
    if (filePath.endsWith('.doc') || filePath.endsWith('.docx')) return PhosphorIcons.fileDoc();
    return PhosphorIcons.file();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: AppColors.softGrey.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.textVividNavy.withOpacity(0.1), width: 1),
      ),
      child: ListTile(
        leading: Icon(_getIconForFile(file.path), color: AppColors.purpleSoftmax),
        title: Text(
          file.path.split('/').last,
          style: TextStyle(fontSize: 14, color: AppColors.textVividNavy),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: Icon(PhosphorIcons.xCircle(), color: AppColors.redSoftmax),
          onPressed: onRemove,
        ),
      ),
    );
  }
}
