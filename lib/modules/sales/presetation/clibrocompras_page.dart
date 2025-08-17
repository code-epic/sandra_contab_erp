import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:syncfusion_flutter_xlsio/xlsio.dart'  as xlsio hide Column;

class ClibrocomprasPage extends StatefulWidget {
  const ClibrocomprasPage({super.key});
  @override
  State<ClibrocomprasPage> createState() => _ClibrocomprasPage();
}

class _ClibrocomprasPage extends State<ClibrocomprasPage> {

  String _filter = '';

  /* --- Datos generales --- */
  final _rifCtrl = TextEditingController(text: 'J-310203884');
  final _nombreCtrl = TextEditingController(text: 'Corpovex C.A.');
  final _direccionCtrl = TextEditingController(text: 'Av. Miranda, Caracas');
  DateTime _fecha = DateTime.now();

  /* --- Ejemplo de filas --- */
  final List<Map<String, dynamic>> _filas = List.generate(
    10,
        (i) => {
      'operacion': i + 1,
      'fechaEmision': DateTime.now().subtract(Duration(days: i)),
      'nFactura': 'F-${1000 + i}',
      'nControl': 'CTRL${1000 + i}',
      'nDebito': '',
      'nCredito': '',
      'rifProv': 'J-00000000${i + 1}',
      'nombreProv': 'Proveedor ${i + 1}',
      'total': 1200.00 + i * 100,
      'exento': 0.0,
      'base': 1200.00 + i * 100,
      'alicuota': 16,
      'iva': (1200.00 + i * 100) * 0.16,
      'retenido': 0.0,
    },
  );

  List<Map<String, dynamic>> get _filasFiltradas =>
      _filas.where((e) =>
      e['nFactura'].toString().toLowerCase().contains(_filter.toLowerCase()) ||
          e['nombreProv'].toString().toLowerCase().contains(_filter.toLowerCase()))
          .toList();


  /* --- Totales --- */
  double get _totalImporte =>
      _filas.fold(0, (sum, e) => sum + (e['total'] as double));
  double get _totalIVA =>
      _filas.fold(0, (sum, e) => sum + (e['iva'] as double));

  /* --- Fecha --- */
  Future<void> _selectFecha(BuildContext context) async {
    final d = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (d != null) setState(() => _fecha = d);
  }

  /* --- Exportar PDF --- */
  Future<void> _exportPDF() async {
    final doc = PdfDocument();
    final page = doc.pages.add();
    final g = page.graphics;

    // Cabecera
    g.drawString('Libro de Compras',
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        brush: PdfSolidBrush( PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 30)
    );

    g.drawString('RIF: ${_rifCtrl.text}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds:  Rect.fromLTWH(0, 40, 500, 20));

    g.drawString('Nombre: ${_nombreCtrl.text}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds:  Rect.fromLTWH(0, 60, 500, 20));

    g.drawString('Dirección: ${_direccionCtrl.text}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds:  Rect.fromLTWH(0, 80, 500, 20));

    // Tabla
    final table = PdfGrid();
    table.columns.add(count: 14);
    table.headers.add(1);
    final header = table.headers[0];
    header.cells[0].value = 'Nº Op';
    header.cells[1].value = 'Fecha Emisión';
    header.cells[2].value = 'Nº Factura';
    header.cells[3].value = 'Nº Control';
    header.cells[4].value = 'Nº Débito';
    header.cells[5].value = 'Nº Crédito';
    header.cells[6].value = 'RIF Prov';
    header.cells[7].value = 'Nombre Prov';
    header.cells[8].value = 'Total Bs';
    header.cells[9].value = 'Exento';
    header.cells[10].value = 'Base';
    header.cells[11].value = '%';
    header.cells[12].value = 'IVA Bs';
    header.cells[13].value = 'Retenido';

    for (final f in _filas) {
      final row = table.rows.add();
      row.cells[0].value = f['operacion'].toString();
      row.cells[1].value = DateFormat('dd/MM/yyyy').format(f['fechaEmision']);
      row.cells[2].value = f['nFactura'];
      row.cells[3].value = f['nControl'];
      row.cells[4].value = f['nDebito'];
      row.cells[5].value = f['nCredito'];
      row.cells[6].value = f['rifProv'];
      row.cells[7].value = f['nombreProv'];
      row.cells[8].value = f['total'].toStringAsFixed(2);
      row.cells[9].value = f['exento'].toStringAsFixed(2);
      row.cells[10].value = f['base'].toStringAsFixed(2);
      row.cells[11].value = '${f['alicuota']} %';
      row.cells[12].value = f['iva'].toStringAsFixed(2);
      row.cells[13].value = f['retenido'].toStringAsFixed(2);
    }

    // Pie
    final lastRow = table.rows.add();
    lastRow.cells[7].value = 'TOTALES';
    lastRow.cells[8].value = _totalImporte.toStringAsFixed(2);
    lastRow.cells[12].value = _totalIVA.toStringAsFixed(2);

    table.draw(page: page, bounds: const Rect.fromLTWH(0, 120, 0, 0));

    // final bytes = doc.saveSync();
    // doc.dispose();
    // await _share(bytes, 'LibroCompras.pdf');
    final bytes = Uint8List.fromList(doc.saveSync());
    doc.dispose();
    await _share(bytes, 'LibroCompras.pdf');
  }

  /* --- Exportar Excel --- */
  Future<void> _exportExcel() async {
    final workbook = xlsio.Workbook();
    final sheet = workbook.worksheets[0];
    sheet.name = 'LibroCompras';

    // Cabecera
    final headers = [
      'Nº de Operación',
      'Fecha Emisión',
      'Nº Factura',
      'Nº Control',
      'Nº Nota Débito',
      'Nº Nota Crédito',
      'RIF Proveedor',
      'Nombre / Razón Social',
      'Importe Total',
      'Importe Exento',
      'Base Imponible',
      '% Alicuota',
      'Impuesto IVA',
      'IVA Retenido'
    ];
    for (var i = 0; i < headers.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
    }

    // Datos
    for (var r = 0; r < _filas.length; r++) {
      final f = _filas[r];
      sheet.getRangeByIndex(r + 2, 1).setNumber((f['operacion'] as int).toDouble());
      sheet.getRangeByIndex(r + 2, 2).setText(DateFormat('dd/MM/yyyy').format(f['fechaEmision']));
      sheet.getRangeByIndex(r + 2, 3).setText(f['nFactura']);
      sheet.getRangeByIndex(r + 2, 4).setText(f['nControl']);
      sheet.getRangeByIndex(r + 2, 5).setText(f['nDebito']);
      sheet.getRangeByIndex(r + 2, 6).setText(f['nCredito']);
      sheet.getRangeByIndex(r + 2, 7).setText(f['rifProv']);
      sheet.getRangeByIndex(r + 2, 8).setText(f['nombreProv']);
      sheet.getRangeByIndex(r + 2, 9).setNumber((f['total']  as num).toDouble());

      sheet.getRangeByIndex(r + 2, 10).setNumber(f['exento']);
      sheet.getRangeByIndex(r + 2, 11).setNumber((f['base'] as num).toDouble());
      sheet.getRangeByIndex(r + 2, 12).setNumber((f['alicuota'] as num).toDouble());
      sheet.getRangeByIndex(r + 2, 13).setNumber(f['iva']);
      sheet.getRangeByIndex(r + 2, 14).setNumber(f['retenido']);
    }

    // Totales
    final last = _filas.length + 2;
    sheet.getRangeByIndex(last, 8).setText('TOTALES');
    sheet.getRangeByIndex(last, 9).setNumber(_totalImporte);
    sheet.getRangeByIndex(last, 13).setNumber(_totalIVA);

    // final bytes = workbook.saveAsStream();
    // workbook.dispose();
    // await _share(bytes, 'LibroCompras.xlsx');
    final bytes = Uint8List.fromList(workbook.saveAsStream());
    workbook.dispose();
    await _share(bytes, 'LibroCompras.xlsx');
  }

  /* --- Exportar CSV --- */
  Future<void> _exportCSV() async {
    final rows = [
      [
        'Nº de Operación',
        'Fecha Emisión',
        'Nº Factura',
        'Nº Control',
        'Nº Nota Débito',
        'Nº Nota Crédito',
        'RIF Proveedor',
        'Nombre / Razón Social',
        'Importe Total',
        'Importe Exento',
        'Base Imponible',
        '% Alicuota',
        'Impuesto IVA',
        'IVA Retenido'
      ],
      ..._filas.map((e) => [
        e['operacion'],
        DateFormat('dd/MM/yyyy').format(e['fechaEmision']),
        e['nFactura'],
        e['nControl'],
        e['nDebito'],
        e['nCredito'],
        e['rifProv'],
        e['nombreProv'],
        e['total'],
        e['exento'],
        e['base'],
        e['alicuota'],
        e['iva'],
        e['retenido']
      ])
    ];
    final csv = const ListToCsvConverter().convert(rows);
    final bytes = Uint8List.fromList(csv.codeUnits);
    await _share(bytes, 'LibroCompras.csv');
  }

  /* --- Compartir --- */
  Future<void> _share(Uint8List bytes, String filename) async {
    final dir = Directory.systemTemp;
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles([XFile(file.path)],
        subject: 'Libro de Compras');
  }



  /* --- UI --- */
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
            const Text('Libro de Compra'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'pdf') _exportPDF();
              if (v == 'excel') _exportExcel();
              if (v == 'csv') _exportCSV();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: 'pdf', child: Text('Descargar PDF')),
              const PopupMenuItem(
                  value: 'excel', child: Text('Descargar Excel')),
              const PopupMenuItem(
                  value: 'csv', child: Text('Descargar CSV')),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(.98),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Datos generales
            TextFormField(
              controller: _rifCtrl,
              decoration: const InputDecoration(labelText: 'RIF'),
            ),
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre / Razón Social'),
            ),
            TextFormField(
              controller: _direccionCtrl,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            ListTile(
              title: const Text('Fecha'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_fecha)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectFecha(context),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar factura o proveedor...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _filter = v),
              ),
            ),

            // Tabla
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                dataRowHeight: 60,                // interlineado mayor
                columnSpacing: 20,
                dividerThickness: 1,
                columns: const [
                  DataColumn(label: Text('#Op')),
                  DataColumn(label: Text('Fecha Emisión')),
                  DataColumn(label: Text('Nº Factura')),
                  DataColumn(label: Text('Nº Control')),
                  DataColumn(label: Text('Nº Débito')),
                  DataColumn(label: Text('Nº Crédito')),
                  DataColumn(label: Text('RIF Prov')),
                  DataColumn(label: Text('Nombre Prov')),
                  DataColumn(label: Text('Total Bs')),
                  DataColumn(label: Text('Exento')),
                  DataColumn(label: Text('Base')),
                  DataColumn(label: Text('%')),
                  DataColumn(label: Text('IVA Bs')),
                  DataColumn(label: Text('Retenido')),
                ],
                rows: _filasFiltradas.map(
                      (e) => DataRow(
                    cells: [
                      DataCell(Text(e['operacion'].toString())),
                      DataCell(Text(DateFormat('dd/MM/yyyy').format(e['fechaEmision']))),
                      DataCell(Text(e['nFactura'])),
                      DataCell(Text(e['nControl'])),
                      DataCell(Text(e['nDebito'])),
                      DataCell(Text(e['nCredito'])),
                      DataCell(Text(e['rifProv'])),
                      DataCell(Text(e['nombreProv'])),
                      DataCell(Text(e['total'].toStringAsFixed(2))),
                      DataCell(Text(e['exento'].toStringAsFixed(2))),
                      DataCell(Text(e['base'].toStringAsFixed(2))),
                      DataCell(Text('${e['alicuota']} %')),
                      DataCell(Text(e['iva'].toStringAsFixed(2))),
                      DataCell(Text(e['retenido'].toStringAsFixed(2))),
                    ],
                  ),
                ).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // Totales
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Importe: ${_totalImporte.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Total IVA: ${_totalIVA.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }



}