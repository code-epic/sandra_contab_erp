

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';



class ClienteEmpresa {
  final String id;
  final String nombre;
  final String rif;
  final String descripcion;
  final String telefono;
  final String correo;
  final String direccion;
  final String? logoUrl;

  ClienteEmpresa({
    required this.id,
    required this.nombre,
    required this.rif,
    required this.descripcion,
    required this.telefono,
    required this.correo,
    required this.direccion,
    this.logoUrl,
  });

  ClienteEmpresa copyWith({
    String? nombre,
    String? rif,
    String? descripcion,
    String? logoUrl,
  }) =>
      ClienteEmpresa(
        id: id,
        nombre: nombre ?? this.nombre,
        rif: rif ?? this.rif,
        descripcion: descripcion ?? this.descripcion,
        logoUrl: logoUrl ?? this.logoUrl,
        telefono: nombre ?? this.telefono,
        correo: nombre ?? this.correo,
        direccion: nombre ?? this.direccion,
      );
}

class FormClienteScreen extends StatefulWidget {
  final ClienteEmpresa? cliente;
  const FormClienteScreen({super.key, this.cliente});

  @override
  State<FormClienteScreen> createState() => _FormClienteScreenState();
}

class _FormClienteScreenState extends State<FormClienteScreen> {
  late final _nombreCtrl = TextEditingController(text: widget.cliente?.nombre);
  late final _rifCtrl   = TextEditingController(text: widget.cliente?.rif);
  late final _descCtrl  = TextEditingController(text: widget.cliente?.descripcion);
  late final _teleCtrl  = TextEditingController(text: widget.cliente?.telefono);
  late final _corrCtrl  = TextEditingController(text: widget.cliente?.correo);
  late final _direCtrl  = TextEditingController(text: widget.cliente?.direccion);

  // Nuevos
  late final _contactoCtrl   = TextEditingController();
  late final _emailCtrl      = TextEditingController();

  File? _logoFile;
  final List<File> _docsFiles = [];

  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _rifCtrl.dispose();
    _descCtrl.dispose();
    _teleCtrl.dispose();
    _corrCtrl.dispose();
    _direCtrl.dispose();
    _contactoCtrl.dispose();
    _emailCtrl.dispose();
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

  void _removeDoc(int idx) => setState(() => _docsFiles.removeAt(idx));

  void _guardar() {
    if (_formKey.currentState!.validate()) {
      final nuevo = ClienteEmpresa(
        id: widget.cliente?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        nombre: _nombreCtrl.text,
        rif: _rifCtrl.text,
        descripcion: _descCtrl.text,
        telefono: _teleCtrl.text,
        correo: _corrCtrl.text,
        direccion: _direCtrl.text,
        // Aquí puedes guardar paths o URLs si subes a servidor
      );
      Navigator.of(context).pop(nuevo);
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
              padding: EdgeInsets.zero,   // quita padding extra
              constraints: const BoxConstraints(), // quita tamaño mínimo
              onPressed: () => Navigator.of(context).pop(),
            ),
            Text(widget.cliente == null ? 'Nueva empresa' : 'Editar empresa')
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _guardar),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body:Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Logo + RIF & Nombre lado a lado
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo rectangular (izquierda)
                GestureDetector(
                  onTap: _pickLogo,
                  child: Container(
                    width: 100,
                    height: 100, // altura total de los dos TextField
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
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
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),
                // Columna con RIF y Nombre (derecha)
                Expanded(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _rifCtrl,
                        decoration: const InputDecoration(labelText: 'RIF (J-XXXXXXXX-X)'),
                        validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: const InputDecoration(labelText: 'Nombre / Razón Social'),
                        validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),


            const SizedBox(height: 6),
            // DIRECCION
            TextFormField(
              controller: _direCtrl,
              decoration: const InputDecoration(labelText: 'Dirección de la empresa'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 6),
            // DESCRIPCION
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Descripción o rubro de la empresa'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 10),
            // Documentos constitutivos
            const Text('Documentos constitutivos', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.attach_file),
              label: const Text('Adjuntar archivos'),
              onPressed: _pickDocs,
            ),
            if (_docsFiles.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(_docsFiles.length, (i) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: _docsFiles[i].path.endsWith('.pdf')
                                ? const AssetImage('assets/pdf_placeholder.png') // placeholder
                                : FileImage(_docsFiles[i]) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _removeDoc(i),
                        child: const Icon(Icons.close, size: 20, color: Colors.red),
                      ),
                    ],
                  );
                }),
              ),
            ],

            const SizedBox(height: 20),

            // Datos de contacto
            TextFormField(
              controller: _contactoCtrl,
              decoration: const InputDecoration(labelText: 'Responsable / Contacto'),
              validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: const InputDecoration(labelText: 'Correo electrónico del responsable'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
              v!.isEmpty ? 'Campo obligatorio' : (!v.contains('@') ? 'Correo inválido' : null),
            ),



          ],
        ),
      ),
    );

  }
}