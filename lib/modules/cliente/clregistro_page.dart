import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/empresa.dart';
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/modules/cliente/formcliente.dart';

class ClregistroPage extends StatefulWidget {
  const ClregistroPage({super.key});
  @override
  State<ClregistroPage> createState() => _ClregistroPage();
}



class _ClregistroPage extends State<ClregistroPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  String _searchQuery = '';

  final List<Empresa> _clientes = [
    Empresa(
      id: '1',
      nombreComercial: 'Corpovex S.A.',
      razonSocial: 'Corporación Venezolana de Comercio Exterior',
      rif: 'J-310203884',
      actividadEconomica: 'Comercio al por mayor de productos alimenticios',
      rubroEconomico: ['Distribución de alimentos', 'Comercio exterior', 'Sector público'],
      direccionFiscal: 'Av. Francisco de Miranda, Torre Europa, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Sociedad Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'constitucion.pdf', 'solvencia.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '2',
      nombreComercial: 'Mercantil Servicios Financieros',
      razonSocial: 'Mercantil Servicios Financieros C.A.',
      rif: 'J-00002945-0',
      actividadEconomica: 'Servicios financieros y bancarios',
      rubroEconomico: ['Banca', 'Servicios financieros', 'Sector privado'],
      direccionFiscal: 'Torre Mercantil, Av. Andrés Bello, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'registro_mercantil.pdf', 'permiso_bancario.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '3',
      nombreComercial: 'PDVSA Petróleos de Venezuela',
      razonSocial: 'Petróleos de Venezuela S.A.',
      rif: 'J-00099653-7',
      actividadEconomica: 'Extracción y refinación de petróleo',
      rubroEconomico: ['Petróleo y gas', 'Energía', 'Sector público'],
      direccionFiscal: 'Torre PDVSA, La Campiña, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Sociedad Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_minera.pdf', 'registro_legal.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '4',
      nombreComercial: 'Empresas Polar',
      razonSocial: 'Cervecería Polar C.A.',
      rif: 'J-00002956-8',
      actividadEconomica: 'Industria alimenticia y bebidas',
      rubroEconomico: ['Alimentos', 'Bebidas', 'Sector privado'],
      direccionFiscal: 'Av. Francisco de Miranda, Los Palos Grandes, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'permiso_sanitario.pdf', 'marca_registrada.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '5',
      nombreComercial: 'Movilnet C.A.',
      razonSocial: 'Movilnet Compañía Anónima',
      rif: 'J-00002971-4',
      actividadEconomica: 'Servicios de telecomunicaciones móviles',
      rubroEconomico: ['Telecomunicaciones', 'Sector público'],
      direccionFiscal: 'Av. Francisco de Miranda, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_telecom.pdf', 'espectro.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '6',
      nombreComercial: 'Cantv',
      razonSocial: 'Compañía Anónima Nacional Teléfonos de Venezuela',
      rif: 'J-00002972-2',
      actividadEconomica: 'Servicios de telecomunicaciones fijos y móviles',
      rubroEconomico: ['Telecomunicaciones', 'Internet', 'Sector público'],
      direccionFiscal: 'Torre Cantv, Av. Francisco de Miranda, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'concesion_telecom.pdf', 'registro_nacional.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '7',
      nombreComercial: 'Banco de Venezuela',
      razonSocial: 'Banco de Venezuela S.A.C.A.',
      rif: 'J-00002946-8',
      actividadEconomica: 'Servicios bancarios universales',
      rubroEconomico: ['Banca', 'Servicios financieros', 'Sector público'],
      direccionFiscal: 'Av. Universidad, Esquina El Chorro, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Sociedad Anónima de Capital Abierto',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_bancaria.pdf', 'registro_sudeban.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '8',
      nombreComercial: 'Farmatodo C.A.',
      razonSocial: 'Farmatodo Compañía Anónima',
      rif: 'J-00002989-9',
      actividadEconomica: 'Comercio al por menor de productos farmacéuticos',
      rubroEconomico: ['Farmacias', 'Supermercados', 'Sector privado'],
      direccionFiscal: 'Centro Comercial Sambil, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_farmacia.pdf', 'permiso_sanitario.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '9',
      nombreComercial: 'Digitel GSM',
      razonSocial: 'Corporación Digitel C.A.',
      rif: 'J-00002975-7',
      actividadEconomica: 'Servicios de telecomunicaciones móviles',
      rubroEconomico: ['Telecomunicaciones', 'Sector privado'],
      direccionFiscal: 'Torre Digitel, Av. Francisco de Miranda, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_telecom.pdf', 'concesion_espectro.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '10',
      nombreComercial: 'Alimentos La Gaviota',
      razonSocial: 'Alimentos La Gaviota S.A.',
      rif: 'J-00002955-0',
      actividadEconomica: 'Industria de alimentos procesados',
      rubroEconomico: ['Alimentos', 'Industria manufacturera', 'Sector privado'],
      direccionFiscal: 'Zona industrial de Guatire, Miranda',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Sociedad Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'registro_sencamer.pdf', 'permiso_industrial.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '11',
      nombreComercial: 'Corpoelec',
      razonSocial: 'Corporación Eléctrica Nacional S.A.',
      rif: 'J-29591677-0',
      actividadEconomica: 'Generación, transmisión y distribución de energía eléctrica',
      rubroEconomico: ['Energía eléctrica', 'Sector público'],
      direccionFiscal: 'Av. Los Ilustres, Los Caobos, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Sociedad Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'concesion_electrica.pdf', 'registro_nacional.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '12',
      nombreComercial: 'Banco Bicentenario',
      razonSocial: 'Banco Bicentenario del Pueblo S.A.C.A.',
      rif: 'J-29448494-3',
      actividadEconomica: 'Servicios bancarios universales',
      rubroEconomico: ['Banca', 'Servicios financieros', 'Sector público'],
      direccionFiscal: 'Torre Bicentenario, Av. Urdaneta, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Sociedad Anónima de Capital Abierto',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_bancaria.pdf', 'registro_sudeban.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '13',
      nombreComercial: 'Inversiones Altamira',
      razonSocial: 'Inversiones Altamira C.A.',
      rif: 'J-00002999-6',
      actividadEconomica: 'Actividades inmobiliarias',
      rubroEconomico: ['Inmobiliaria', 'Sector privado'],
      direccionFiscal: 'Av. Francisco de Miranda, Altamira, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'registro_inmobiliario.pdf', 'permiso_construccion.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '14',
      nombreComercial: 'Suministros Industriales Veneca',
      razonSocial: 'Suministros Industriales Veneca C.A.',
      rif: 'J-00003001-1',
      actividadEconomica: 'Comercio al por mayor de productos industriales',
      rubroEconomico: ['Distribución industrial', 'Sector privado'],
      direccionFiscal: 'Zona industrial de Los Cortijos, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'registro_comercial.pdf', 'permiso_industrial.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),

    Empresa(
      id: '15',
      nombreComercial: 'Constructora Sambil',
      razonSocial: 'Constructora Sambil C.A.',
      rif: 'J-00003005-4',
      actividadEconomica: 'Construcción de centros comerciales y urbanizaciones',
      rubroEconomico: ['Construcción', 'Inmobiliaria', 'Sector privado'],
      direccionFiscal: 'Torre Europa, Caracas',
      telefono: '',
      correoElectronico: '',
      tipoSociedad: 'Compañía Anónima',
      estatusSeniat: 'Activo',
      documentosDigitales: ['rif.pdf', 'licencia_construccion.pdf', 'registro_inmobiliario.pdf'],
      logoUrl: 'https://cdn-icons-png.flaticon.com/512/3233/3233159.png',
    ),
  ];

  List<Empresa> get _filtered => _searchQuery.isEmpty
      ? _clientes
      : _clientes
      .where((c) =>
  c.nombreComercial.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      c.rif.toLowerCase().contains(_searchQuery.toLowerCase()))
      .toList();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nuevo() async {
    final nuevo = await Navigator.of(context).push<Empresa>(
      MaterialPageRoute(builder: (_) => const FormClienteScreen()),
    );
    if (nuevo != null) {
      setState(() => _clientes.add(nuevo));
    }
  }

  void _editar(Empresa c, int index) async {
    final editado = await Navigator.of(context).push<Empresa>(
      MaterialPageRoute(builder: (_) => FormClienteScreen(cliente: c)),
    );
    if (editado != null) {
      setState(() => _clientes[index] = editado);
    }
  }

  void _eliminarCliente(int index) {
    setState(() => _clientes.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cliente eliminado')),
    );
  }

  void _showCardContextMenu(BuildContext context, Empresa cliente, Offset tapPosition, int index) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(tapPosition, tapPosition),
        Offset.zero & overlay.size,
      ),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'modificar',
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Modificar', style: TextStyle(color: AppColors.textVividNavy, fontSize: 16)),
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
      if (result == 'modificar') {
        _editar(cliente, index);
      } else if (result == 'eliminar') {
        _eliminarCliente(index);
      }
    });
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
              icon: Icon(PhosphorIcons.arrowLeft()),
              color: AppColors.vividNavy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => context.go('/home'),
            ),
            const Text('Registrar clientes'),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(PhosphorIcons.userPlus()),
            onPressed: _nuevo,
            color: AppColors.vividNavy,
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: FadeTransition(
        opacity: _animation,
        child: Column(
          children: [
            _SearchCard(
              onSearch: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 0, bottom: 90),
                itemCount: _filtered.length,
                itemBuilder: (_, index) {
                  final c = _filtered[index];
                  // Nueva tarjeta con Slidable y decoración personalizada
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2.5),
                    child: Slidable(
                      key: ValueKey(c.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) => _eliminarCliente(index),
                            backgroundColor: AppColors.redSoftmax,
                            foregroundColor: Colors.white,
                            icon: PhosphorIcons.trash(),
                            label: 'Eliminar',
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () => _editar(c, index),
                        onLongPressStart: (details) => _showCardContextMenu(context, c, details.globalPosition, index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.vividNavy.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 5),
                              ),
                            ],

                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 68,
                                  height: 68,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.purpleSoft,
                                        blurRadius: 4,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor: AppColors.softGrey,
                                    backgroundImage: c.logoUrl != null ? NetworkImage(c.logoUrl!) : AssetImage('assets/job.contab.png'),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        c.nombreComercial,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: AppColors.textVividNavy.withOpacity(0.9),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c.rif,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                          color: AppColors.purpleSoftmax,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c.actividadEconomica  ?? '',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textVividNavy.withOpacity(0.6),
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(PhosphorIcons.arrowRight(), color: AppColors.vividNavy.withOpacity(0.5)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }
}

class _SearchCard extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const _SearchCard({required this.onSearch});

  @override
  State<_SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<_SearchCard> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _doSearch() async {
    final text = _searchController.text;
    if (text.isEmpty) return;
    // La reproducción de audio se ha eliminado por problemas de compatibilidad.

    widget.onSearch(text);

    // Limpiar y quitar foco
    _searchController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        color: Colors.white,
        child: InkWell(
          onTap: () {
            _focusNode.requestFocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.softGrey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    'Buscar',
                    style: TextStyle(
                      color: AppColors.vividNavy,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _focusNode,
                    enabled: true,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _doSearch(),
                    decoration: InputDecoration(
                      hintText: 'Consultar clientes',
                      hintStyle: TextStyle(
                        color: AppColors.vividNavy.withOpacity(0.5),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(PhosphorIcons.magnifyingGlass()),
                  color: AppColors.vividNavy,
                  onPressed: _doSearch,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}