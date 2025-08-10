import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:path/path.dart' as p;

class CventasPage extends StatefulWidget {
  const CventasPage({super.key});
  @override
  State<CventasPage> createState() => _CventasPage();
}

class _CventasPage extends State<CventasPage> {

  bool _lote = false;

  /* ----- INDIVIDUAL ----- */
  final _formKeyInd = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _numCtrl = TextEditingController();
  DateTime _fecha = DateTime.now();
  File? _imgIndividual;

  /* ----- LOTE ----- */
  final List<File> _loteFiles = [];
  final maxFiles = 6;
  final maxBytes = 10 * 1024 * 1024; // 10 MB

  /* ----- HELPERS ----- */
  Future<void> _pickIndividual() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img == null) return;
    final file = File(img.path);
    if (file.lengthSync() > maxBytes) {
      _msg('Imagen > 10 MB');
      return;
    }
    setState(() => _imgIndividual = file);
  }

  Future<void> _pickLote() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'zip'],
    );
    if (result == null) return;

    final valid = result.files
        .where((f) => f.size <= maxBytes)
        .take(maxFiles - _loteFiles.length)
        .map((f) => File(f.path!))
        .toList();

    if (valid.length + _loteFiles.length > maxFiles) {
      _msg('Máximo $maxFiles archivos');
    }
    setState(() => _loteFiles.addAll(valid));
  }

  void _removeLote(int i) => setState(() => _loteFiles.removeAt(i));

  void _msg(String txt) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));

  @override
  void dispose() {
    _montoCtrl.dispose();
    _numCtrl.dispose();
    super.dispose();
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
              // quita padding extra
              constraints: const BoxConstraints(),
              // quita tamaño mínimo
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Facturas de Ventas'),
          ],
        ),

      ),
      backgroundColor: Colors.white.withOpacity(.98),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle modo
            SwitchListTile(
              title: const Text('Carga en lote'),
              value: _lote,
              onChanged: (v) => setState(() => _lote = v),
            ),
            const SizedBox(height: 16),
            _lote ? _buildLote() : _buildIndividual(),
          ],
        ),
      ),

    );
  }
  /* ----- BUILD ----- */
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Cargar facturas')),
  //
  //   );
  // }

  /* ---------- INDIVIDUAL ---------- */
  Widget _buildIndividual() {
    return Form(
      key: _formKeyInd,
      child: Column(
        children: [
          // Imagen
          GestureDetector(
            onTap: _pickIndividual,
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                image: _imgIndividual != null
                    ? DecorationImage(
                    image: FileImage(_imgIndividual!), fit: BoxFit.cover)
                    : null,
              ),
              child: _imgIndividual == null
                  ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          // Fecha
          ListTile(
            title: const Text('Fecha'),
            subtitle: Text(_fecha.toLocal().toString().substring(0, 10)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _fecha,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (d != null) setState(() => _fecha = d);
            },
          ),
          // Monto
          TextFormField(
            controller: _montoCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monto \$'),
            validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          // Número
          TextFormField(
            controller: _numCtrl,
            decoration: const InputDecoration(labelText: 'Nº Factura'),
            validator: (v) => v!.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKeyInd.currentState!.validate() && _imgIndividual != null) {
                // Procesar factura individual
                _msg('Factura individual guardada');
              } else {
                _msg('Completa todos los campos y sube imagen');
              }
            },
            child: const Text('Guardar factura'),
          ),
        ],
      ),
    );
  }

  /* ---------- LOTE ---------- */
  Widget _buildLote() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.upload_file),
          label: const Text('Seleccionar PDF / ZIP'),
          onPressed: _loteFiles.length >= maxFiles ? null : _pickLote,
        ),
        const SizedBox(height: 8),
        Text('Máx. $maxFiles archivos de 2 MB',
            style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        // Previews
        _loteFiles.isEmpty
            ? const Text('Sin archivos')
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: _loteFiles.length,
          itemBuilder: (_, i) {
            final ext = p.extension(_loteFiles[i].path).toLowerCase();
            return Stack(
              fit: StackFit.expand,
              children: [
                ext == '.pdf'
                    ? const Icon(Icons.picture_as_pdf,
                    size: 40, color: Colors.red)
                    : ext == '.zip'
                    ? const Icon(Icons.archive,
                    size: 40, color: Colors.blue)
                    : Image.file(_loteFiles[i], fit: BoxFit.cover),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _removeLote(i),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loteFiles.isEmpty
              ? null
              : () {
            // Procesar lote
            _msg('${ _loteFiles.length } facturas en lote procesadas');
          },
          child: const Text('Procesar lote'),
        ),
      ],
    );
  }

}