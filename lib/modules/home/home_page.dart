import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:go_router/go_router.dart';

import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/models/goaldprogress_card.dart';
import 'package:sandra_contab_erp/core/models/module.dart';
import 'package:sandra_contab_erp/core/models/voice_command.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_carousel.dart';
import 'package:sandra_contab_erp/core/theme/asistenteia_card.dart';
import 'package:sandra_contab_erp/core/theme/publicaciones_card.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


import '../security/auth_service.dart';
import 'dart:async';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final stt.SpeechToText _speech = stt.SpeechToText();
  late CommandExecutor _commandExecutor;
  bool _isListening = false;
  String _text = 'Presiona el micrófono y habla';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    _commandExecutor = CommandExecutor(
      triggerWord: 'sandra',
      commands: [
        VoiceCommand(
          phrase: 'escanea documentos automaticamente',
          // Lógica para el comando "Sandra, Escanea Documentos Automaticamente".
          // En un entorno real, podrías navegar a una página específica y llamar un método.
          action: (context) {
            // Suponiendo que tienes una clase llamada CinventariosPage con un método _scanDocument.
            // Aquí simulamos la acción con un mensaje en la consola.
            debugPrint('Navegando a CinventariosPage y lanzando _scanDocument().');
            // La siguiente línea de código es un ejemplo de cómo se podría implementar la navegación real.
            // GoRouter.of(context).push('/inventarios').then((_) {
            //   // Aquí se podría llamar al método de escaneo después de la navegación.
            // });
            _text = 'Navegando a la página de inventarios y escaneando documentos...';
          },
        ),
        VoiceCommand(
          phrase: 'listar galeria',
          action: (context) {
            debugPrint('Ejecutando acción para "Listar Galeria".');
            _text = 'Mostrando la galería...';
          },
        ),
        VoiceCommand(
          phrase: 'ver plan de cuentas',
          action: (context) {
            debugPrint('Ejecutando acción para "Ver plan de cuentas".');
            _text = 'Mostrando el plan de cuentas...';
          },
        ),
        VoiceCommand(
          phrase: 'consultar leyes',
          action: (context) {
            debugPrint('Ejecutando acción para "Consultar leyes".');
            _text = 'Consultando leyes...';
          },
        ),
        VoiceCommand(
          phrase: 'ver mis clientes',
          action: (context) {
            debugPrint('Ejecutando acción para "Ver mis clientes".');
            _text = 'Mostrando la lista de clientes...';
          },
        ),
      ],
    );
    _initSpeechToText();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initSpeechToText() async {
    bool available = await _speech.initialize(
      onError: (val) => print('Error: $val'),
      onStatus: (val) => print('Estado: $val'),
    );
    if (available) {
      setState(() {
        _isListening = false;
      });
    } else {
      setState(() {
        _text = 'El servicio no está disponible o no se concedieron permisos.';
      });
    }

  }

  void _startListening() async {

    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              _confidence = result.confidence;
            }
          }),
        );
      }
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: AppColors.vividNavy,
        backgroundColor: AppColors.softGrey,
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.textIndent()),
              color: AppColors.vividNavy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const Text('ContabApp'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                tooltip: 'Buscar',
                icon: Icon(PhosphorIcons.listMagnifyingGlass()),
                onPressed: () {
                  context.go('/login');
                },
              ),
              IconButton(
                tooltip: 'Cerrar Sesión',
                icon: Icon(PhosphorIcons.door()),
                onPressed: () {
                  _authService.logout();
                  context.go('/login');
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
              GoalProgressCard(data: GoalData(
                total: 30,
                reviewed: 10,
                pending: 15,
                analyzed: 5,
              )),
              const SizedBox(height: 5.0),
              // Aquí se agrega la nueva tarjeta
              PublicacionesCard(data: PublicationData(
                leyes: 50,
                normativas: 320,
                instructivos: 30,
              )),
              const SizedBox(height: 5.0),
              GoalAndAssistantCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }
}



// Nuevo Widget para la barra de navegacion
class FloatingNavBar extends StatefulWidget {
  const FloatingNavBar({super.key});

  @override
  State<FloatingNavBar> createState() => _FloatingNavBarState();
}


class _FloatingNavBarState extends State<FloatingNavBar> with SingleTickerProviderStateMixin {
  String _selectedTitle = XkModules.first.title;
  late AnimationController _tooltipController;
  late Animation<double> _animation;
  Timer? _tooltipTimer;
  bool _showTooltip = false;

  @override
  void initState() {
    super.initState();
    _tooltipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _tooltipController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    _tooltipTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _tooltipTimer?.cancel();
    _tooltipTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showTooltip = false;
        });
      }
    });
  }

  void _onModuleChanged(Module module) {
    setState(() {
      _selectedTitle = module.title;
      _showTooltip = true;
    });
    // Reinicia la animación y el temporizador
    _tooltipController.forward(from: 0.0);
    _startHideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1.0),
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ConceptsCarousel(
              modules: XkModules,
              onPageChanged: _onModuleChanged,
            ),
          ),
        ),
        // Widget flotante para el título (la nube)
        Positioned(
          left: 0,
          right: 0,
          bottom: 75,
          child: AnimatedOpacity(
            opacity: _showTooltip ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Center(
              child: Column( // Usamos una columna para alinear el texto y el triángulo
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container( // Este es el contenedor para el texto con forma de nube
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _selectedTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.vividNavy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Apuntador en forma de "V"
                  CustomPaint(
                    size: const Size(10, 10),
                    painter: TrianglePainter(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// CustomPainter para dibujar el triángulo del apuntador
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}




// Widget para la tarjeta de mensajes del sistema
class SystemMessagesCard extends StatelessWidget {
  const SystemMessagesCard({super.key});

  final List<String> systemMessages = const [
    'Nómina de Mayo procesada con éxito.',
    'Nuevo cliente agregado: Soluciones Z.',
    'Actualización de seguridad aplicada.',
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mensajes del Sistema',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ...systemMessages.map(
                  (message) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text('• $message'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Nuevo widget para la tabla de transacciones
class TransactionsTable extends StatelessWidget {
  const TransactionsTable({super.key});

  final List<Map<String, String>> transactions = const [
    {'descripcion': 'Pago de proveedor X', 'monto': '-\$500.00'},
    {'descripcion': 'Venta a cliente Y',  'monto': '+\$1,200.00'},
    {'descripcion': 'Compra de insumos',  'monto': '-\$150.00'},
    {'descripcion': 'Venta a cliente Z', 'monto': '+\$750.00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('DESCRIPCION', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('MONTO', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: transactions.map((transaction) {
            return DataRow(
              cells: [
                DataCell(Text(transaction['descripcion']!)),
                DataCell(Text(transaction['monto']!)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
