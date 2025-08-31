import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart' hide AppColors;
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/modules/contab/cmodel/plan_cuentas.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';

// --- Widget Principal de la Página ---

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});
  @override
  State<PlanPage> createState() => _PlanPage();
}



class _PlanPage extends State<PlanPage> {
  late final TextEditingController _searchController;
  late List<Cuenta> _cuentasFiltradasPorRif;
  late String _currentCompanyRif;
  final Map<String, bool> _expanded = {};
  bool _isLoading = false;

  // Nuevo estado para la importación pendiente
  bool _isImportPending = false;
  List<Cuenta> _importedCuentas = [];

  final List<Company> companies = [
    const Company(
      rif: 'J-30504090-7',
      razonSocial: 'EMPRESA MODELO',
      actividad: 'Contabilidad y Finanzas',
    ),
    const Company(
      rif: 'V-12345678-9',
      razonSocial: 'COMERCIAL ABC, C.A.',
      actividad: 'Comercio Minorista',
    ),
    const Company(
      rif: 'G-98765432-1',
      razonSocial: 'INVERSIONES GLOBAL, S.A.',
      actividad: 'Servicios de Inversión',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _currentCompanyRif = companies.first.rif;
    _updateCuentasForCompany(_currentCompanyRif);
    _searchController.addListener(_filter);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filter);
    _searchController.dispose();
    super.dispose();
  }

  // --- Lógica de Actualización de Datos ---
  Future<void> _updateCuentasForCompany(String rif) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentCompanyRif = rif;
      // Lógica de previsualización: Si hay una importación pendiente,
      // mostramos las cuentas importadas. De lo contrario, las guardadas.
      if (_isImportPending) {
        _cuentasFiltradasPorRif = _importedCuentas.where((c) => c.rif == rif).toList();
      } else {
        _cuentasFiltradasPorRif = DtoCuentaExample.where((c) => c.rif == rif).toList();
      }
      _expanded.clear();
      _searchController.clear();
      _filter();
      _isLoading = false;
    });
  }

  void _filter() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _expanded.clear();
      if (query.isNotEmpty) {
        final matchingAccounts = _cuentasFiltradasPorRif.where((c) =>
        c.descripcion.toLowerCase().contains(query) || c.codigo.toLowerCase().contains(query)
        ).toList();

        for (final cuenta in matchingAccounts) {
          _expanded[cuenta.codigo] = true;
          String currentCode = cuenta.codigo;
          while (currentCode.contains('.')) {
            currentCode = currentCode.substring(0, currentCode.lastIndexOf('.'));
            _expanded[currentCode] = true;
          }
        }
      }
    });
  }

  void _showCardContextMenu(BuildContext context, Cuenta cuenta, Offset tapPosition) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(tapPosition, tapPosition),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'editar',
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Editar', style: TextStyle(color: AppColors.textVividNavy, fontSize: 16)),
              Icon(PhosphorIcons.pencilSimple(), color: AppColors.purpleSoftmax),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'eliminar',
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Eliminar', style: TextStyle(color: AppColors.textVividNavy, fontSize: 16)),
              Icon(PhosphorIcons.trash(), color: AppColors.redSoftmax),
            ],
          ),
        ),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 6,
    ).then((result) {
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opción seleccionada: $result para ${cuenta.descripcion}')),
        );
      }
    });
  }

  // --- Lógica de Importación de Archivo ---
  Future<void> _importFile() async {
    final Company currentCompany = companies.firstWhere(
            (company) => company.rif == _currentCompanyRif,
        orElse: () => companies.first
    );

    final bool? shouldProceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isProcessing = false;

            Future<void> processFile() async {
              setState(() {
                isProcessing = true;
              });

              try {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['csv', 'txt'],
                );

                if (result != null) {
                  final file = result.files.first;
                  final fileExtension = file.extension?.toLowerCase();

                  // Validación de formato de archivo.
                  if (fileExtension != 'csv' && fileExtension != 'txt') {
                    throw Exception('Formato de archivo inválido. Solo se permiten archivos CSV y TXT.');
                  }

                  // Lógica de respaldo para leer los bytes del archivo.
                  List<int>? fileBytes = file.bytes;
                  if (fileBytes == null && file.path != null) {
                    // Si los bytes son nulos, intentamos leer el archivo directamente desde la ruta.
                    final fileIO = File(file.path!);
                    fileBytes = await fileIO.readAsBytes();
                  }

                  if (fileBytes == null || fileBytes.isEmpty) {
                    throw Exception('No se pudo leer el contenido del archivo. Es posible que el archivo esté vacío, dañado o que la aplicación no tenga permisos para acceder a él.');
                  }

                  final csvStringRaw = utf8.decode(fileBytes);
                  // Validación del formato de números de cuenta
                  final csvString = csvStringRaw.replaceAll(RegExp(r'(\d),(\d)'), r'$1.$2');

                  // Lógica de detección de delimitador más robusta.
                  final firstLines = csvString.split('\n').take(10).join('\n');
                  String detectedDelimiter = ',';

                  const delimiters = [',', ';', '\t', '|'];
                  int maxCount = 0;
                  for (final delimiter in delimiters) {
                    final count = delimiter.allMatches(firstLines).length;
                    if (count > maxCount) {
                      maxCount = count;
                      detectedDelimiter = delimiter;
                    }
                  }

                  if (maxCount == 0 && delimiters.every((d) => !firstLines.contains(d))) {
                    throw Exception('No se pudo detectar el delimitador en el archivo. Verifique el formato.');
                  }

                  final tableData = const CsvToListConverter(shouldParseNumbers: false)
                      .convert(csvString, fieldDelimiter: detectedDelimiter);

                  if (tableData.isEmpty) {
                    throw Exception('No se pudo leer el contenido del archivo. Es posible que esté vacío o mal formateado.');
                  }

                  final List<Cuenta> newCuentas = [];
                  // Búsqueda de la fila del encabezado que contiene 'código' y 'descripción'.
                  final headerRowIndex = tableData.indexWhere((row) =>
                  row.any((cell) =>  cell.toString().toLowerCase().contains('codigo')) &&
                      row.any((cell) => cell.toString().toLowerCase().contains('descripcion'))
                  );

                  if (headerRowIndex == -1) {
                    throw Exception('Formato de archivo inválido. No se encontró el encabezado requerido (ej. "CÓDIGO" y "DESCRIPCIÓN DE LA CUENTA").');
                  }

                  final cuentaColIndex = tableData[headerRowIndex].indexWhere((cell) =>  cell.toString().toLowerCase().contains('codigo'));
                  final descColIndex = tableData[headerRowIndex].indexWhere((cell) => cell.toString().toLowerCase().contains('descripcion'));

                  for (int i = headerRowIndex + 1; i < tableData.length; i++) {
                    final row = tableData[i];
                    if (row.length > cuentaColIndex && row[cuentaColIndex] != null && row[cuentaColIndex].toString().trim().isNotEmpty) {
                      final codigo = row[cuentaColIndex].toString().trim();
                      final descripcion = row.length > descColIndex ? row[descColIndex].toString().trim() : '';

                      if (codigo.isNotEmpty && descripcion.isNotEmpty) {
                        newCuentas.add(
                            Cuenta(
                                rif: currentCompany.rif,
                                codigo: codigo,
                                descripcion: descripcion,
                                naturaleza: 'DEBE/HABER',
                                totalizadora: true,
                                moneda: 'Bs.'
                            )
                        );
                      }
                    }
                  }

                  if (newCuentas.isEmpty) {
                    throw Exception('No se encontraron cuentas válidas para importar en el archivo.');
                  }

                  _importedCuentas = newCuentas;

                  if (mounted) {
                    setState(() {
                      _isImportPending = true;
                    });
                    Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('¡Importación completada! Presione "Guardar" para aplicar los cambios.'))
                    );
                  }
                } else {
                  if (mounted) Navigator.of(context).pop(false);
                }
              } catch (e) {
                if (mounted) {
                  Navigator.of(context).pop(false);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al importar el archivo: $e'))
                  );
                }
              } finally {
                setState(() {
                  isProcessing = false;
                });
              }
            }

            return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: EdgeInsets.zero,
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              content: Stack(
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: AppColors.purpleSoftmax,
                            child: Icon(PhosphorIcons.upload(PhosphorIconsStyle.bold), size: 44, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Confirmar Importación',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: isProcessing
                                ? Column(
                              children: [
                                const SizedBox(height: 20),
                                CircularProgressIndicator(strokeWidth: 2, color: AppColors.purpleSoftmax),
                                const SizedBox(height: 20),
                                Text(
                                  'Analizando documento...',
                                  style: TextStyle(color: AppColors.vividNavy.withOpacity(0.7)),
                                ),
                                const SizedBox(height: 20),
                              ],
                            )
                                : Column(
                              children: [
                                Text(
                                  '¿Desea importar el plan de cuentas y asociarlo con la siguiente empresa?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.vividNavy.withOpacity(0.7)),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.softGrey,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(PhosphorIcons.building(), size: 36, color: AppColors.vividNavy.withOpacity(0.7)),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentCompany.razonSocial,
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              'RIF: ${currentCompany.rif}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.textVividNavy.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      child: Text('Cancelar', style: TextStyle(color: AppColors.redSoftmax, fontWeight: FontWeight.bold)),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.purpleSoftmax,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      ),
                                      onPressed: processFile,
                                      child: const Text('Confirmar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: Icon(PhosphorIcons.xCircle(PhosphorIconsStyle.fill), size: 24, color: AppColors.textVividNavy.withOpacity(0.7)),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (shouldProceed == true) {
      if (mounted) {
        _updateCuentasForCompany(_currentCompanyRif);
      }
    }
  }

  // Nueva función para mostrar la confirmación de guardado
  Future<void> _showSaveConfirmationDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Confirmar cambios'),
          content: const Text(
              '¿Está seguro de que desea guardar los cambios? Esto reemplazará el plan de cuentas actual de la empresa.'
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancelar', style: TextStyle(color: AppColors.redSoftmax)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Confirmar', style: TextStyle(color: AppColors.purpleSoftmax)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _saveImportedData();
    }
  }

  // Nueva función para guardar los datos importados
  void _saveImportedData() {
    final Company currentCompany = companies.firstWhere(
            (company) => company.rif == _currentCompanyRif,
        orElse: () => companies.first
    );

    // Elimina las cuentas existentes de la empresa actual
    DtoCuentaExample.removeWhere((c) => c.rif == currentCompany.rif);

    // Añade las nuevas cuentas importadas
    DtoCuentaExample.addAll(_importedCuentas);

    // Reseteamos el estado y actualizamos la vista
    setState(() {
      _isImportPending = false;
      _importedCuentas = [];
    });

    // Mostramos un mensaje de éxito
    _updateCuentasForCompany(_currentCompanyRif);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan de cuentas guardado exitosamente.'))
    );
  }

  void _handleEdit(Cuenta cuenta) {
    print('Editar cuenta: ${cuenta.descripcion}');
  }

  void _showCompanySelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Seleccionar Empresa',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              ...companies.map((company) {
                return ListTile(
                  leading: Icon(PhosphorIcons.buildings(), color: AppColors.vividNavy),
                  title: Text(company.razonSocial),
                  subtitle: Text('RIF: ${company.rif}'),
                  onTap: () {
                    _updateCuentasForCompany(company.rif);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: AppColors.vividNavy,
        backgroundColor: AppColors.softGrey,
        titleSpacing: 0,
        title: const Text('Plan de Cuentas'),
        actions: <Widget>[
          // El botón de Guardar solo es visible cuando hay una importación pendiente.
          if (_isImportPending)
            IconButton(
              tooltip: 'Guardar Cambios',
              icon: Icon(PhosphorIcons.floppyDisk(PhosphorIconsStyle.regular)),
              onPressed: _showSaveConfirmationDialog,
            ),
          IconButton(
            tooltip: 'Cambiar de Empresa',
            icon: Icon(PhosphorIcons.briefcase()),
            onPressed: _showCompanySelector,
          ),
          IconButton(
            tooltip: 'Importar Plan',
            icon: Icon(PhosphorIcons.upload()),
            onPressed: _importFile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardClientCompany(
                companies: companies,
                onCompanyChanged: (company) => _updateCuentasForCompany(company.rif),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLoading
                        ? SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.purpleSoftmax),
                      ),
                    )
                        : Row(
                      children: [
                        Icon(PhosphorIcons.magnifyingGlass(), color: AppColors.vividNavy.withOpacity(0.5)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar por código o descripción...',
                              hintStyle: TextStyle(
                                color: AppColors.vividNavy.withOpacity(0.5),
                              ),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                              border: InputBorder.none,
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                icon: Icon(PhosphorIcons.x()),
                                color: AppColors.vividNavy.withOpacity(0.5),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {});
                                },
                              )
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: Colors.white,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.purpleSoftmax),
                    ),
                  )
                      : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                    child: Column(
                      children: _buildCuentaList(_cuentasFiltradasPorRif, 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }

  List<Widget> _buildCuentaList(List<Cuenta> cuentas, int level) {
    List<Widget> list = [];
    final isSearching = _searchController.text.isNotEmpty;

    final List<Cuenta> currentLevelCuentas = cuentas.where((c) {
      final parts = c.codigo.split('.');
      final isTopLevel = parts.length == level + 1;

      if (isSearching) {
        return isTopLevel && (_expanded[c.codigo] ?? false);
      }

      return isTopLevel;
    }).toList();

    for (final cuenta in currentLevelCuentas) {
      final children = cuentas.where((c) =>
      c.codigo.startsWith('${cuenta.codigo}.') && c.codigo != cuenta.codigo
      ).toList();
      final isExpanded = _expanded[cuenta.codigo] ?? false;
      final bool isParent = children.isNotEmpty;

      if (level == 0) {
        list.add(
          CuentaCard(
            cuenta: cuenta,
            onEdit: () {
              if (isParent) {
                setState(() {
                  _expanded[cuenta.codigo] = !isExpanded;
                });
              }
            },
            onLongPress: (details) {
              _showCardContextMenu(context, cuenta, details.globalPosition);
            },
            isParent: isParent,
            isExpanded: isExpanded,
          ),
        );
      } else {
        list.add(
          Padding(
            padding: EdgeInsets.only(left: 16.0 * level),
            child: HijoCuentaCard(
              cuenta: cuenta,
              onEdit: () {
                if (isParent) {
                  setState(() {
                    _expanded[cuenta.codigo] = !isExpanded;
                  });
                }
              },
              onLongPress: (details) {
                _showCardContextMenu(context, cuenta, details.globalPosition);
              },
              isParent: isParent,
              isExpanded: isExpanded,
            ),
          ),
        );
      }
      list.add(const Divider(color: AppColors.softGrey, thickness: 0.6));

      if (isExpanded && isParent) {
        list.add(
          Column(
            children: _buildCuentaList(children, level + 1),
          ),
        );
      }
    }
    return list;
  }
}



