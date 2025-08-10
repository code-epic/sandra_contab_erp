import 'package:flutter/material.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart' hide AppColors;
import 'package:sandra_contab_erp/core/theme/app_color.dart';

// --- Widget Principal de la Página ---

class PlanPage extends StatefulWidget {
  const PlanPage({super.key});
  @override
  State<PlanPage> createState() => _PlanPage();
}

class _PlanPage extends State<PlanPage> {
  final _search = TextEditingController();
  late List<Cuenta> _cuentas;
  late List<Cuenta> _filtered;
  bool _asc = true;
  int _sortCol = 0;

  @override
  void initState() {
    super.initState();
    _cuentas = _data;
    _filtered = List.from(_cuentas);
    _search.addListener(_filter);
  }

  // Datos de ejemplo (Venezuela)
  final _data = const [
    Cuenta(codigo: '100.00.0.00.00.00.00.00', descripcion: 'ACTIVOS', naturaleza: 'D/H', totalizadora: true, moneda: 'Bs.'),
    Cuenta(codigo: '110.00.0.00.00.00.00.00', descripcion: 'ACTIVO CORRIENTE', naturaleza:  'D/H', totalizadora: true, moneda: 'Bs.'),
    Cuenta(codigo: '111.00.0.00.00.00.00.00', descripcion: 'CAJA Y BANCOS', naturaleza:  'D/H', moneda: 'Bs.'),
    Cuenta(codigo: '200.00.0.00.00.00.00.00', descripcion: 'PASIVOS', naturaleza:  'D/H', totalizadora: true, moneda: 'Bs.'),
    Cuenta(codigo: '210.00.0.00.00.00.00.00', descripcion: 'PASIVO CORRIENTE', naturaleza:  'D/H', totalizadora: true, moneda: 'Bs.'),
    Cuenta(codigo: '300.00.0.00.00.00.00.00', descripcion: 'PATRIMONIO', naturaleza:  'D/H', totalizadora: true, moneda: 'Bs.'),
    Cuenta(codigo: '400.00.0.00.00.00.00.00', descripcion: 'INGRESOS', naturaleza:  'D/H', totalizadora: true, moneda: 'Bs.'),
    Cuenta(codigo: '500.00.0.00.00.00.00.00', descripcion: 'GASTOS', naturaleza:  'D/H', totalizadora: true, moneda: 'Bs.'),
  ];

  void _filter() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = _cuentas.where((c) =>
      c.codigo.toLowerCase().contains(q) ||
          c.descripcion.toLowerCase().contains(q)).toList();
    });
  }

  void _sort(int col) {
    setState(() {
      if (_sortCol == col) _asc = !_asc;
      _sortCol = col;
      _filtered.sort((a, b) {
        int cmp;
        switch (col) {
          case 0:
            cmp = a.codigo.compareTo(b.codigo);
            break;
          case 1:
            cmp = a.descripcion.compareTo(b.descripcion);
            break;
          case 2:
            cmp = a.naturaleza.compareTo(b.naturaleza);
            break;
          default:
            cmp = 0;
        }
        return _asc ? cmp : -cmp;
      });
    });
  }

  void _showDetail(Cuenta c) {
    final formKey = GlobalKey<FormState>();

    // Controladores para los campos
    final descController = TextEditingController(text: c.descripcion);
    String naturaleza = c.naturaleza;
    bool totalizadora = c.totalizadora;
    String moneda = 'Bs'; // Valor por defecto

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Text('Editar cuenta: ${c.codigo}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),

                      // Descripción
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(labelText: 'Descripción'),
                        validator: (val) => val!.isEmpty ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 10),

                      // Naturaleza (dropdown)
                      DropdownButtonFormField<String>(
                        value: naturaleza,
                        decoration: const InputDecoration(labelText: 'Naturaleza'),
                        items: ['D/H', 'H/D'].map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        )).toList(),
                        onChanged: (val) => setState(() => naturaleza = val!),
                      ),
                      const SizedBox(height: 10),

                      // Totalizadora (dropdown)
                      DropdownButtonFormField<bool>(
                        value: totalizadora,
                        decoration: const InputDecoration(labelText: 'Totalizadora'),
                        items: const [
                          DropdownMenuItem(value: true, child: Text('Sí')),
                          DropdownMenuItem(value: false, child: Text('No')),
                        ],
                        onChanged: (val) => setState(() => totalizadora = val!),
                      ),
                      const SizedBox(height: 10),

                      // Tipo de moneda (dropdown)
                      DropdownButtonFormField<String>(
                        value: moneda,
                        decoration: const InputDecoration(labelText: 'Tipo de moneda'),
                        items: const [
                          DropdownMenuItem(value: 'Bs', child: Text('Bs')),
                          DropdownMenuItem(value: '\$', child: Text('\$')),
                          DropdownMenuItem(value: '€', child: Text('€')),
                        ],
                        onChanged: (val) => setState(() => moneda = val!),
                      ),
                      const SizedBox(height: 25),

                      // Botones de acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'delete'),
                            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                // Aquí puedes guardar los cambios
                                final updated = Cuenta(
                                  codigo: c.codigo,
                                  descripcion: descController.text,
                                  naturaleza: naturaleza,
                                  totalizadora: totalizadora,
                                  moneda: moneda,
                                );
                                Navigator.pop(context, updated); // Retorna el objeto editado
                              }
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Botón cerrar (X)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Plan de Cuentas'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                tooltip: 'Plan de Cuentas',
                icon: const Icon(Icons.account_tree_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Plan de Cuentas')),
                  );
                },
              ),
              IconButton(
                tooltip: 'Reportes Financieros',
                icon: const Icon(Icons.bar_chart_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Reportes financieros')),
                  );
                },
              ),
              IconButton(
                tooltip: 'Configuración',
                icon: const Icon(Icons.settings_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Configuración')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white.withOpacity(.98),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.vividNavy,
        child: const Icon(Icons.edit_note, color: AppColors.paleBlue,),
        onPressed: () => _showDetail(Cuenta(codigo: '', descripcion: '', naturaleza: '')),
      ),
      body: Column(
        children: [
          // Filtro
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por código o descripción',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Encabezado responsive
          XHeader(onSort: _sort, asc: _asc, sortCol: _sortCol),
          // Tabla
          Expanded(
            child: ListView(
              children: [
                for (final c in _filtered)
                  XRow(cuenta: c, onTap: () => _showDetail(c)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
