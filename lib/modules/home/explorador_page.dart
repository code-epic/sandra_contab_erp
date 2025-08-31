import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/documento.dart';
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
import 'package:sandra_contab_erp/core/services/documento_service.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/publicaciones_card.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

class ExploradorPage extends StatefulWidget {
  const ExploradorPage({super.key});

  @override
  State<ExploradorPage> createState() => _ExploradorPageState();
}

class _ExploradorPageState extends State<ExploradorPage> {
  bool _isSearching = false;
  // Instancia del servicio
  final DocumentoService _documentoService = DocumentoService();
  // Estado para los documentos y los datos del gráfico
  List<Documento> _documentos = [
    Documento(titulo: 'Factura 1', estatus: 'REVISION', fecha: '28JUN25', peso: '2mb', conciliacion: 'Automatica'),
    Documento(titulo: 'Factura 2', estatus: 'PENDIENTE', fecha: '28JUN25', peso: '2mb', conciliacion: 'Automatica'),
    Documento(titulo: 'Factura 3', estatus: 'ANALIZADO', fecha: '28JUN25', peso: '2mb', conciliacion: 'Automatica'),
    Documento(titulo: 'Factura 4', estatus: 'REVISION', fecha: '27JUN25', peso: '3mb', conciliacion: 'Automatica'),
    Documento(titulo: 'Factura 5', estatus: 'PENDIENTE', fecha: '27JUN25', peso: '1mb', conciliacion: 'Automatica'),
    Documento(titulo: 'Factura 6', estatus: 'ANALIZADO', fecha: '26JUN25', peso: '2mb', conciliacion: 'Manual'),
    Documento(titulo: 'Factura 7', estatus: 'REVISION', fecha: '26JUN25', peso: '4mb', conciliacion: 'Manual'),
    Documento(titulo: 'Factura 8', estatus: 'PENDIENTE', fecha: '25JUN25', peso: '2mb', conciliacion: 'Manual'),
    Documento(titulo: 'Factura 9', estatus: 'ANALIZADO', fecha: '25JUN25', peso: '2mb', conciliacion: 'Automatica'),
    Documento(titulo: 'Factura 10', estatus: 'REVISION', fecha: '25JUN25', peso: '2mb', conciliacion: 'Automatica'),
  ];
  // List<DailyData> _dailyData = [];

  final List<DailyData> _dailyData = [
    DailyData(day: 'LUN', count: 5),
    DailyData(day: 'MAR', count: 3),
    DailyData(day: 'MIÉ', count: 2),
    DailyData(day: 'JUE', count: 5),
    DailyData(day: 'VIE', count: 1),
    DailyData(day: 'SÁB', count: 6),
    DailyData(day: 'DOM', count: 4),
  ];

  bool _isLoading = false;


  // Método para alternar el estado de búsqueda.
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
  }

  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      print('Buscando: $query');
      _toggleSearch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: AppColors.vividNavy,
        backgroundColor: AppColors.softGrey,
        titleSpacing: 0,
        // El AppBar contiene el botón de regreso y el título de la página.
        title: Row(
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.arrowLeft()),
              color: AppColors.vividNavy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => context.go('/home'), // Navega de regreso
            ),
            const Text('Explorador'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              if (_isSearching)
              IconButton(
                tooltip: 'Explorador',
                icon: Icon(PhosphorIcons.desktop()),
                onPressed: () {
                  _toggleSearch();
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 150.0, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SearchCard(onSearch: _handleSearch),
              if (!_isSearching) ...[
                const SizedBox(height: 5),
                _FoldersCard(onTap: _toggleSearch),
                const SizedBox(height: 5),
                const _GeneralCard(), 
                const SizedBox(height: 5),
                const _CapacityCard(),
                const SizedBox(height: 5),
                const _CapacityFileCard(),
              ] else ...[

                if (_isLoading)
                  const Center(child: CircularProgressIndicator(color: AppColors.vividNavy))
                else
                  const SizedBox(height: 5),
                  _ResultCard(
                    onTap: () {
                      _isSearching = false;
                      _documentos = []; // Opcional: limpiar la lista
                    },
                    documentos: _documentos,
                    dailyData: _dailyData,
                  ),
              ],
            ],
          ),
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

    // Sonido
    final player = AudioPlayer();
    await player.play(AssetSource('sound/search.mp3'));

    // Llamada real
    widget.onSearch(text);

    // Limpiar y quitar foco
    _searchController.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.softGrey,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                    hintText: 'Explorador de documentos',
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
    );
  }
}








class _GraphCard extends StatefulWidget {
  final List<DailyData> dailyData;

  const _GraphCard({required this.dailyData});

  @override
  State<_GraphCard> createState() => _GraphCardState();
}

class _GraphCardState extends State<_GraphCard> {
  String _selectedDay = DateFormat('dd').format(DateTime.now());
  String _selectedMonth = DateFormat('MMM').format(DateTime.now()).toUpperCase();

  void _onDayChanged(int index) {
    setState(() {
      final now = DateTime.now();
      // El día actual es el índice 0 del carrusel, así que ajustamos la fecha.
      final newDay = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: index));
      _selectedDay = DateFormat('dd').format(newDay);
      _selectedMonth = DateFormat('MMM').format(newDay).toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Indicador de la fecha
            Container(
              width: 70,
              height: 80,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _selectedDay,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.purpleSoftmax,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 0.6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _selectedMonth,
                    style:  TextStyle(
                      fontSize: 18,
                      color: AppColors.purpleSoftmax,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 0.6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14.0),
            // Carrusel de barras
            Expanded(
              child: BarChartCarousel(
                data: widget.dailyData,
                onDayChanged: _onDayChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}






class _ResultCard extends StatefulWidget {
  final VoidCallback onTap;
  final List<Documento> documentos;
  final List<DailyData> dailyData;

  const _ResultCard({
    required this.onTap,
    required this.documentos,
    required this.dailyData,
  });

  @override
  State<_ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<_ResultCard> {
  late List<Documento> _documentos;

  @override
  void initState() {
    super.initState();
    _documentos = List.from(widget.documentos);
  }

  void _removeDocumento(Documento documento) {
    setState(() {
      _documentos.remove(documento);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: Colors.white,
      child: Column(
        children: [
          _GraphCard(dailyData: widget.dailyData),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Column(
                  children: _documentos.map((doc) => _DocumentoItem(
                    key: ValueKey(doc.titulo),
                    documento: doc,
                    onDocumentRemoved: () => _removeDocumento(doc),
                  )).toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentoItem extends StatefulWidget {
  final Documento documento;
  final VoidCallback? onDocumentRemoved;

  const _DocumentoItem({required Key key, required this.documento, this.onDocumentRemoved}) : super(key: key);

  @override
  State<_DocumentoItem> createState() => _DocumentoItemState();
}

class _DocumentoItemState extends State<_DocumentoItem> {
  double _dragExtent = 0;
  static const double _actionExtent = 100.0;
  static const Color purpleSoft = Color(0xFFD3C6E5);
  bool _isPressed = false;

  Map<String, dynamic> _getStatusIconAndColor(String estatus) {
    switch (estatus.toUpperCase()) {
      case 'REVISION':
        return {
          'icon': PhosphorIcons.pencilSimpleLine(),
          'color': AppColors.yellowSoftmax
        };
      case 'PENDIENTE':
        return {
          'icon': PhosphorIcons.clock(),
          'color': AppColors.purpleSoftmax
        };
      case 'ANALIZADO':
        return {
          'icon': PhosphorIcons.checkCircle(),
          'color': AppColors.greenSoftmax
        };
      default:
        return {'icon': Icons.circle, 'color': AppColors.vividNavy};
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.delta.dx;
      _dragExtent = _dragExtent.clamp(0.0, _actionExtent);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragExtent > _actionExtent * 0.4) {
      setState(() {
        _dragExtent = _actionExtent;
      });
    } else {
      setState(() {
        _dragExtent = 0;
      });
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: const Text('Eliminar documento'),
        content: const Text('¿Está seguro de que desea eliminar este documento? Esta acción es irreversible.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _dragExtent = 0);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final player = AudioPlayer();

              Navigator.of(context).pop();
              if (widget.onDocumentRemoved != null) {
                widget.onDocumentRemoved!();
                await player.play(AssetSource('sound/eliminar.mp3'));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleSoftmax,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        title: const Text('Editar documento'),
        content: const Text('¿Desea editar este documento?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              print('Ir a edición de: ${widget.documento.titulo}');
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.purpleSoftmax,
              foregroundColor: AppColors.vividNavy,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Editar'),
          ),
        ],
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    if (_dragExtent == 0) {
      print('Tocado: ${widget.documento.titulo}');
    }
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusIconAndColor(widget.documento.estatus);
    final bool isConciliacionAutomatica = widget.documento.conciliacion.toLowerCase() == 'automatica';
    final Color checkColor = isConciliacionAutomatica ? AppColors.greenSoftmax : Colors.grey.shade400;

    return Column(
      children: [
        GestureDetector(
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onLongPress: _showEditDialog,
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: Stack(
            children: [
              // Fondo de acciones que se muestra al deslizar
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  color: AppColors.greenSoft,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 24.0),
                  child: AnimatedOpacity(
                    opacity: _dragExtent > 0 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: _buildActionButton(
                      icon: PhosphorIcons.trash(),
                      text: 'Eliminar',
                      color: AppColors.purpleSoftmax,
                      onPressed: _showDeleteDialog,
                    ),
                  ),
                ),
              ),
              // Contenido principal del ítem que se mueve
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(_dragExtent, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    if (_isPressed)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (_dragExtent > 0) {
                        setState(() => _dragExtent = 0);
                      } else {
                        print('Tocado: ${widget.documento.titulo}');
                      }
                    },
                    splashColor: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.softGrey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/job.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.documento.titulo,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.vividNavy,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      statusData['icon'],
                                      color: statusData['color'],
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Estatus: ${widget.documento.estatus}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.vividNavy),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(PhosphorIcons.calendarBlank(), color: AppColors.vividNavy, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Fecha: ${widget.documento.fecha}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.vividNavy),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(PhosphorIcons.handWithdraw(), color: AppColors.vividNavy, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Conciliación: ${widget.documento.conciliacion}',
                                      style: const TextStyle(fontSize: 11, color: AppColors.vividNavy),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                widget.documento.peso,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.purpleSoftmax,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Icon(
                                PhosphorIcons.check(),
                                color: checkColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: AppColors.softGrey, thickness: 1),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: 30), // Tamaño del ícono ajustado
        ),
        Text(
          text,
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold), // Texto en negrita
        ),
      ],
    );
  }
}







// Nueva tarjeta para la sección de "Carpetas" con el nuevo diseño y sin el título.
class _FoldersCard extends StatelessWidget {
  final VoidCallback onTap;

  const _FoldersCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Pasamos la función de clic a cada _FolderItem
            Expanded(
              child: _FolderItem(
                title: 'Docs',
                icon: PhosphorIcons.fileText(),
                folderColor: AppColors.greenSoftmax,
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 8), // Espacio entre carpetas
            Expanded(
              child: _FolderItem(
                title: 'Cuentas',
                icon: PhosphorIcons.robot(),
                folderColor: AppColors.purpleSoftmax,
                onTap: onTap,
              ),
            ),
            const SizedBox(width: 8), // Espacio entre carpetas
            Expanded(
              child: _FolderItem(
                title: 'Declara.',
                icon: PhosphorIcons.chatTeardropDots(),
                folderColor: AppColors.yellowSoftmax,
                onTap: onTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para cada carpeta, con un diseño más realista y efecto de clic.
class _FolderItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color folderColor;
  final VoidCallback onTap;

  const _FolderItem({
    required this.title,
    required this.icon,
    required this.folderColor,
    required this.onTap,
  });

  @override
  State<_FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends State<_FolderItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Contenedor que simula la tarjeta de la carpeta.
            Container(
              width: double.infinity,
              height: 80, // Altura ajustada
              decoration: BoxDecoration(
                color: widget.folderColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Pestaña de la carpeta.
                  Positioned(
                    top: 0,
                    left: 10,
                    child: Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: widget.folderColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  // Contenido de la carpeta (ícono y texto).
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start, // Alineación a la izquierda
                      children: [
                        // Ícono.
                        Icon(
                          widget.icon,
                          size: 22, // Tamaño del ícono aún más reducido
                          color: widget.folderColor,
                        ),
                        const SizedBox(height: 6),
                        // Título de la carpeta.
                        Text(
                          widget.title,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.vividNavy,
                            fontWeight: FontWeight.w500,
                            fontSize: 12, // Tamaño de fuente reducido
                          ),
                        ),
                      ],
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
}


// Tarjeta para la sección "General" con el nuevo diseño de gráfico e iconos.
class _GeneralCard extends StatefulWidget {
  const _GeneralCard({super.key});

  @override
  State<_GeneralCard> createState() => _GeneralCardState();
}

class _GeneralCardState extends State<_GeneralCard> {
  // Lista de datos para el gráfico (lun 20, mar 13, etc.).
  final List<Map<String, dynamic>> _graphData = [
    {'day': 'LU', 'value': 20},
    {'day': 'MA', 'value': 13},
    {'day': 'MI', 'value': 25},
    {'day': 'JU', 'value': 18},
    {'day': 'VI', 'value': 30},
    {'day': 'SA', 'value': 15},
    {'day': 'DO', 'value': 22},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Sección del gráfico.
            Expanded(
              child: GestureDetector(
                // Manejo del deslizamiento horizontal.
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! > 0) {
                    // Deslizamiento hacia la derecha (día anterior).
                    print('Deslizamiento hacia la derecha');
                  } else if (details.primaryVelocity! < 0) {
                    // Deslizamiento hacia la izquierda (día siguiente).
                    print('Deslizamiento hacia la izquierda');
                  }
                },
                child: Container(
                  height: 150,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: AppColors.purpleSoft,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    children: [
                      // El widget de dibujo personalizado para el gráfico.
                      CustomPaint(
                        painter: _GraphPainter(data: _graphData),
                        size: Size.infinite,
                      ),
                      // Leyenda de la fecha.
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '25',
                              style: TextStyle(
                                color: AppColors.vividNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'JUL',
                              style: TextStyle(
                                color: AppColors.vividNavy,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Tres íconos a la derecha.
            Column(
              children: [
                _buildIconContainer(PhosphorIcons.list(), AppColors.vividNavy),
                const SizedBox(height: 10),
                _buildIconContainer(PhosphorIcons.graph(), AppColors.vividNavy),
                const SizedBox(height: 10),
                _buildIconContainer(PhosphorIcons.circle(), AppColors.vividNavy),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para crear el contenedor de un ícono con el borde.
  Widget _buildIconContainer(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.softGrey, width: 2),
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }
}

// Clase para dibujar el gráfico personalizado.
class _GraphPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _GraphPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    // Definimos los pinceles para dibujar.
    final Paint linePaint = Paint()
      ..color = AppColors.purpleSoftmax
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint axisPaint = Paint()
      ..color = AppColors.purpleSoftmax.withOpacity(0.5)
      ..strokeWidth = 1.0;

    final Paint pointPaint = Paint()
      ..color = AppColors.purpleSoftmax
      ..style = PaintingStyle.fill;

    // Dibujar el eje X.
    canvas.drawLine(Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    // Dibujar el eje Y.
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);

    // Dibuja las etiquetas del eje X (días de la semana).
    final double daySpacing = size.width / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      final textSpan = TextSpan(
        text: data[i]['day'],
        style: const TextStyle(color: AppColors.vividNavy, fontSize: 12, fontWeight: FontWeight.bold),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(i * daySpacing - textPainter.width / 2, size.height + 5));
    }

    // Calcula la escala de los valores en el eje Y.
    final double maxValue = data.map((e) => e['value'] as int).reduce((a, b) => a > b ? a : b).toDouble();
    final double yStep = size.height / maxValue;

    // Crea la ruta para el gráfico.
    final path = Path();
    if (data.isNotEmpty) {
      path.moveTo(0, size.height - (data[0]['value'] * yStep));
      canvas.drawCircle(Offset(0, size.height - (data[0]['value'] * yStep)), 4.0, pointPaint);
    }
    for (int i = 1; i < data.length; i++) {
      final x = i * daySpacing;
      final y = size.height - (data[i]['value'] * yStep);
      path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 4.0, pointPaint);
    }

    // Dibuja la línea del gráfico.
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}






// Archivo: ExploradorPage.dart
// Nuevo widget para un solo ítem de la tarjeta de capacidad.
class _MetricItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String metric;
  final double progress;
  final Color baseColor;

  const _MetricItem({
    required this.icon,
    required this.title,
    required this.metric,
    required this.progress,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Barra de progreso de fondo
            Positioned.fill(
              child: Container(
                alignment: Alignment.bottomLeft,
                child: FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: baseColor,
                      gradient: LinearGradient(
                        colors: [baseColor.withOpacity(0.2), baseColor.withOpacity(0.5)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            // Contenido principal de la métrica
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: 28, color: baseColor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: AppColors.vividNavy.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        metric,
                        style: TextStyle(
                          color: AppColors.vividNavy,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Nueva tarjeta de Capacidad inspirada en el boceto
class _CapacityCard extends StatelessWidget {
  const _CapacityCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos, estos serían dinámicos
    const double diskUsed = 15;
    const double diskTotal = 100;
    const int companiesAffiliated = 2;
    const int companiesTotal = 5;
    const int referralsCount = 4;
    const int referralsTotal = 4;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Row(
          children: [
            // Sección de Disco
            _MetricItem(
              icon: PhosphorIcons.hardDrives(),
              title: 'Disco',
              metric: '${diskUsed.toStringAsFixed(0)}MB de ${diskTotal.toStringAsFixed(0)}MB',
              progress: diskUsed / diskTotal,
              baseColor: AppColors.greenSoftmax,
            ),
            // Separador 1
            const SizedBox(width: 8),
            Container(
              width: 1,
              color: AppColors.softGrey,
              height: 60, // Altura del separador
            ),
            const SizedBox(width: 8),
            // Sección de Empresas
            _MetricItem(
              icon: PhosphorIcons.building(),
              title: 'Empresas',
              metric: '$companiesAffiliated de $companiesTotal',
              progress: companiesAffiliated / companiesTotal,
              baseColor: AppColors.yellowSoftmax,
            ),
            // Separador 2
            const SizedBox(width: 8),
            Container(
              width: 1,
              color: AppColors.softGrey,
              height: 60, // Altura del separador
            ),
            const SizedBox(width: 8),
            // Sección de Referidos
            _MetricItem(
              icon: PhosphorIcons.users(),
              title: 'Referidos',
              metric: '$referralsCount de $referralsTotal',
              progress: referralsCount / referralsTotal,
              baseColor: AppColors.purpleSoftmax,
            ),
          ],
        ),
      ),
    );
  }
}




// Nueva tarjeta para la sección de "Capacidad de almacenamiento".
class _CapacityFileCard extends StatelessWidget {
  const _CapacityFileCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Ejemplo de datos de capacidad. Estos serían dinámicos en una aplicación real.
    const double totalCapacity = 1250; // GB
    const double usedCapacity = 50; // GB
    final double usagePercentage = usedCapacity / totalCapacity;

    return GestureDetector(
      onTap: () {
        // Lógica futura para cuando el usuario toque la tarjeta
        print('Card de capacidad tocada.');
      },
      child: Card(
        elevation: 2,
        shadowColor: AppColors.vividNavy.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Ícono que representa el almacenamiento
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.greenSoftmax.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  PhosphorIcons.file(),
                  color: AppColors.greenSoftmax,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cantidad de documentos importados',
                      style: TextStyle(
                        color: AppColors.vividNavy,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Texto con el detalle de la capacidad usada y total.
                    Text(
                      ' ${usedCapacity.toStringAsFixed(1)} de  ${totalCapacity.toStringAsFixed(1)} Archivos',
                      style: TextStyle(
                        color: AppColors.vividNavy.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Indicador de progreso con esquinas redondeadas.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: usagePercentage,
                        backgroundColor: AppColors.softGrey,
                        color: AppColors.greenSoftmax,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
