import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/modules/cliente/formcliente.dart';

class ClregistroPage extends StatefulWidget {
  const ClregistroPage({super.key});
  @override
  State<ClregistroPage> createState() => _ClregistroPage();
}

class _ClregistroPage extends State<ClregistroPage> {

  final List<ClienteEmpresa> _clientes = [
    ClienteEmpresa(
      id: '1',
      nombre: 'Corpovex S.A.',
      rif: 'J-310203884',
      direccion: 'Av. Francisco de Miranda, Torre Europa, Caracas.',
      telefono: '',
      correo: '',
      descripcion: 'Empresa estatal de distribución de alimentos',
    ),
    ClienteEmpresa(
      id: '2',
      nombre: 'Mercantil Servicios Financieros',
      rif: 'J-00002945-0',
      direccion: 'Torre Mercantil, Av. Andrés Bello, Caracas.',
      telefono: '',
      correo: '',
      descripcion: 'Grupo bancario venezolano',
    ),
    ClienteEmpresa(
      id: '3',
      nombre: 'PDVSA Petróleos de Venezuela',
      rif: 'J-00099653-7',
      direccion: 'Torre PDVSA, La Campiña, Caracas.',
      logoUrl: 'https://i.imgur.com/pdvsa.png',
      telefono: '',
      correo: '',
      descripcion: 'Empresa petrolera estatal',
    ),
    ClienteEmpresa(
      id: '4',
      nombre: 'Polar Empresas Polar',
      rif: 'J-00002956-8',
      direccion: 'Av. Francisco de Miranda, Los Palos Grandes, Caracas.',
      telefono: '',
      correo: '',
      descripcion: 'Industria alimenticia y bebidas',
    ),
    ClienteEmpresa(
      id: '5',
      nombre: 'Movilnet C.A.',
      rif: 'J-00002971-4',
      descripcion: 'Av. Francisco de Miranda, Caracas.',
      telefono: '',
      correo: '',
      direccion: 'Operadora de telecomunicaciones',
    ),
    ClienteEmpresa(
      id: '6',
      nombre: 'Cantv Compañía Anónima',
      rif: 'J-00002972-2',
      descripcion: 'Empresa estatal de telecomunicaciones',
      telefono: '',
      correo: '',
      direccion: 'Torre Cantv, Av. Francisco de Miranda, Caracas',
    ),
    ClienteEmpresa(
      id: '7',
      nombre: 'Banco de Venezuela',
      rif: 'J-00002946-8',
      descripcion: 'Banco universal estatal',
      telefono: '',
      correo: '',
      direccion: 'Av. Universidad, Esquina El Chorro, Caracas.',
    ),
    ClienteEmpresa(
      id: '8',
      nombre: 'Farmatodo C.A.',
      rif: 'J-00002989-9',
      descripcion: 'Cadena de farmacias y supermercados',
      telefono: '',
      correo: '',
      direccion: 'Centro Comercial Sambil, Caracas',
    ),
    ClienteEmpresa(
      id: '9',
      nombre: 'Digitel GSM',
      rif: 'J-00002975-7',
      descripcion: 'Operadora móvil privada',
      telefono: '',
      correo: '',
      direccion: 'Torre Digitel, Av. Francisco de Miranda, Caracas',
    ),
    ClienteEmpresa(
      id: '10',
      nombre: 'Alimentos La Gaviota',
      rif: 'J-00002955-0',
      descripcion: 'Industria de alimentos',
      telefono: '',
      correo: '',
      direccion: 'Zona industrial de Guatire, Miranda.',
    ),
    ClienteEmpresa(
      id: '11',
      nombre: 'Corpoelec',
      rif: 'J-29591677-0',
      descripcion: 'Empresa eléctrica nacional',
      telefono: '',
      correo: '',
      direccion: 'Av. Los Ilustres, Los Caobos, Caracas',
    ),
    ClienteEmpresa(
      id: '12',
      nombre: 'Banco Bicentenario',
      rif: 'J-29448494-3',
      descripcion: 'Banco estatal',
      telefono: '',
      correo: '',
      direccion: 'Torre Bicentenario, Av. Urdaneta, Caracas.',
    ),
    ClienteEmpresa(
      id: '13',
      nombre: 'Inversiones Altamira C.A.',
      rif: 'J-00002999-6',
      descripcion: 'Empresa inmobiliaria',
      telefono: '',
      correo: '',
      direccion: 'Av. Francisco de Miranda, Altamira, Caracas.',
    ),
    ClienteEmpresa(
      id: '14',
      nombre: 'Suministros Industriales Veneca',
      rif: 'J-00003001-1',
      descripcion: 'Distribución industrial',
      telefono: '',
      correo: '',
      direccion: 'Zona industrial de Los Cortijos, Caracas.',
    ),
    ClienteEmpresa(
      id: '15',
      nombre: 'Constructora Sambil',
      rif: 'J-00003005-4',
      descripcion: 'Constructora de centros comerciales',
      telefono: '',
      correo: '',
      direccion: 'Torre Europa, Caracas',
    ),
  ];

  final _searchCtrl = TextEditingController();

  List<ClienteEmpresa> get _filtered => _searchCtrl.text.isEmpty
      ? _clientes
      : _clientes
      .where((c) =>
  c.nombre.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
      c.rif.toLowerCase().contains(_searchCtrl.text.toLowerCase()))
      .toList();

  void _nuevo() async {
    final nuevo = await Navigator.of(context).push<ClienteEmpresa>(
      MaterialPageRoute(builder: (_) => const FormClienteScreen()),
    );
    if (nuevo != null) {
      setState(() => _clientes.add(nuevo));
    }
  }

  void _editar(ClienteEmpresa c, int index) async {
    final editado = await Navigator.of(context).push<ClienteEmpresa>(
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

  void _enviarNotificacion(ClienteEmpresa c) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notificación enviada a ${c.nombre}')),
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
              padding: EdgeInsets.zero,   // quita padding extra
              constraints: const BoxConstraints(), // quita tamaño mínimo
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Registro de Cliente'),
          ],
        ),
        actions: <Widget>[

          Row(
            children: [


              IconButton(
                tooltip: 'Reportes Financieros',
                icon: const Icon(Icons.bar_chart_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Navegando a: Reportes financieros')),
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
        onPressed: _nuevo,
        child: const Icon(Icons.add_business, color:AppColors.softGrey),

      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ListView.builder(
          itemCount: _filtered.length,
          itemBuilder: (_, index) {
            final c = _filtered[index];

            return Column(
              children: [
                Slidable(
                  key: ValueKey(c.id),
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) => _enviarNotificacion(c),
                        backgroundColor: AppColors.vividNavy,
                        icon: Icons.notifications,
                        label: 'Notificar',
                      ),
                      SlidableAction(
                        onPressed: (_) => _eliminarCliente(index),
                        backgroundColor: Colors.red.shade300,
                        icon: Icons.delete,
                        label: 'Eliminar',
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: Container(
                      width: 68,                 // diámetro externo
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.20),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 34,              // tamaño del avatar
                        backgroundImage:
                        c.logoUrl != null ? NetworkImage(c.logoUrl!) : null,
                        child: c.logoUrl == null
                            ? const Icon(Icons.business, size: 32)
                            : null,
                      ),
                    ),
                    title: Text(
                      c.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${c.rif}\n',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: c.descripcion,
                          ),
                        ],
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    onTap: () => _editar(c, index),
                  ),
                ),

                // Línea divisoria (omitimos la última)
                if (index != _filtered.length - 1)
                  const Divider(height: 1, thickness: .5),
              ],
            );
          },
        ),
      ),

    );
  }


}


