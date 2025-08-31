import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/voice_command.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class GoalAndAssistantCard extends StatefulWidget {
  const GoalAndAssistantCard({super.key});

  @override
  State<GoalAndAssistantCard> createState() => _GoalAndAssistantCardState();
}

class _GoalAndAssistantCardState extends State<GoalAndAssistantCard> {
  // Controlador para el PageView.
  final PageController _pageController = PageController();
  // Variable para rastrear la página actual.
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Añade un listener para saber cuándo cambia la página.
    _pageController.addListener(() {
      int newPage = _pageController.page!.round();
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Función para construir cada una de las tres páginas.
  Widget _buildPage({
    required Widget content,
    required Color backgroundWaveColor,
  }) {
    return Stack(
      children: [
        // La ola de mar extendida, usando el WavePainter.
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CustomPaint(
            size: const Size(double.infinity, 100),
            painter: WavePainter(color: backgroundWaveColor),
          ),
        ),
        // Contenido de la tarjeta.
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: content,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      // Se cambia el radio de la esquina a 6.0
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Container(
        height: 200, // Altura levemente aumentada.
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          children: [
            Expanded(
              // PageView para el desplazamiento de las secciones.
              child: PageView(
                controller: _pageController,
                children: [
                  _buildPage(
                    content: const AgendaPage(),
                    backgroundWaveColor: const Color(0xFFF7BD69).withOpacity(0.2),
                  ),
                  _buildPage(
                    content: const AsistenteContablePage(),
                    backgroundWaveColor: const Color(0xFF88D3CE).withOpacity(0.2),
                  ),
                  _buildPage(
                    content: const InformacionAlDiaPage(),
                    backgroundWaveColor: const Color(0xFFC0A2D3).withOpacity(0.2),
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


// Widget para la página de "Agendar Reuniones". Ahora es un widget con estado.
class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> with SingleTickerProviderStateMixin {
  // Instancia del motor de comandos.
  late CommandExecutor _commandExecutor;
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _recognizedText = 'Pulsa el botón del micrófono para comenzar a escuchar...';
  double _confidence = 1.0;

  // Controladores de animación
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Inicializamos el motor de comandos con los comandos predefinidos.
    _commandExecutor = CommandExecutor(
      triggerWord: 'Sandra',
      commands: [
        VoiceCommand(
          phrase: 'explorador de documentos',
          action: (context) {
            context.go('/explorador');
            setState(() {
              _recognizedText = 'Comando ejecutado: Explorador de documentos documentos...';
            });
          },
        ),
        VoiceCommand(
          phrase: 'escanea documentos automaticamente',
          action: (context) {
            debugPrint('Navegando a CinventariosPage y lanzando _scanDocument().');
            // Aquí puedes llamar a una función o navegar a otra pantalla.
            // context.go('/inventarios');
            setState(() {
              _recognizedText = 'Comando ejecutado: Escaneando documentos...';
            });
          },
        ),
        VoiceCommand(
          phrase: 'listar galeria',
          action: (context) {
            debugPrint('Ejecutando acción para "Listar Galeria".');
            setState(() {
              _recognizedText = 'Comando ejecutado: Mostrando la galería...';
            });
          },
        ),
        VoiceCommand(
          phrase: 'ver plan de cuentas',
          action: (context) {
            debugPrint('Ejecutando acción para "Ver plan de cuentas".');
            setState(() {
              context.go('/cplan');
              _recognizedText = 'Comando ejecutado: Mostrando el plan de cuentas...';
            });
          },
        ),
        VoiceCommand(
          phrase: 'consultar leyes',
          action: (context) {
            debugPrint('Ejecutando acción para "Consultar leyes".');
            setState(() {
              _recognizedText = 'Comando ejecutado: Consultando leyes...';
            });
          },
        ),
        VoiceCommand(
          phrase: 'ver mis clientes',
          action: (context) {
            debugPrint('Ejecutando acción para "Ver mis clientes".');
            setState(() {
              context.go('/inventarios');
              _recognizedText = 'Comando ejecutado: Mostrando la lista de clientes...';
            });
          },
        ),
      ],
    );


    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.repeat();
  }

  // Método para iniciar la escucha de voz.
  void _startListening() async {
    final player = AudioPlayer();
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() async {
              _recognizedText = result.recognizedWords;
              if (result.hasConfidenceRating && result.confidence > 0) {
                _confidence = result.confidence;
                _stopListening(_recognizedText);
                _animationController.stop(canceled:true);
                 await player.play(AssetSource('sound/recorder.mp3'));
              }
            });
          },
        );
      }
    }
  }

  // Método para detener la escucha.
  void _stopListening(String contenido) {
    _speech.stop();
    setState(() => _isListening = false);
    if (contenido != ''){

      _commandExecutor.execute(context, contenido);
    }

  }

  @override
  void dispose() {
    _animationController.dispose();
    _speech.stop();
    _speech.cancel();
    super.dispose();
  }

  // Botón del micrófono con efecto de sombra y color purpleSoftmax.
  Widget _buildMicrophoneButton() {
    return GestureDetector(
      onTap: () => {
        if(_isListening) {
          _stopListening('')
        }else{
          _startListening()
        }

      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sombra que da la sensación de sonar, ahora de color purpleSoftmax.
          if (_isListening)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.purpleSoftmax.withOpacity(0.4),
                        // El spreadRadius varía en el tiempo para crear el efecto de pulso
                        spreadRadius: 8.0 + (12.0 * _animation.value),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                );
              },
            ),
          Container(
            width: 60,
            height: 60,
            // Se elimina la palabra clave 'const' del BoxDecoration.
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purpleSoftmax, // Color de botón actualizado.
            ),
            // El ícono cambia dependiendo del estado de la escucha.
            child: Icon(
              !_isListening ? PhosphorIcons.microphone() : PhosphorIcons.microphoneSlash(),
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sandra tu asistente',
          style: TextStyle(
            fontSize: 13, // Título del tamaño de fuente 13.
            fontWeight: FontWeight.bold,
            color: AppColors.vividNavy,
          ),
        ),
        Divider(color: AppColors.vividNavy.withOpacity(0.3), height: 10), // Línea divisoria.
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _recognizedText,
                style: const TextStyle(fontSize: 14, color: AppColors.vividNavy),
              ),
            ),
            _buildMicrophoneButton(),
          ],
        ),
        const SizedBox(height: 10),
        // Muestra el nivel de confianza.
        Text(
          'Confianza: ${(_confidence * 100).toStringAsFixed(1)}%',
          style: TextStyle(fontSize: 10, color: AppColors.vividNavy.withOpacity(0.7)),
        ),
      ],
    );
  }
}

// Widget para la página de "Asistente Contable".
class AsistenteContablePage extends StatelessWidget {
  const AsistenteContablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asistente Contable',
          style: TextStyle(
            fontSize: 13, // Título del tamaño de fuente 13.
            fontWeight: FontWeight.bold,
            color: AppColors.vividNavy,
          ),
        ),
        Divider(color: AppColors.vividNavy.withOpacity(0.3), height: 10), // Línea divisoria.
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Simple', Icons.local_fire_department),
                _buildInfoRow('Rápido', Icons.local_fire_department),
              ],
            ),
            // Se muestra el icono del robot sin sombra.
            Icon(PhosphorIcons.robot(), size: 80, color: AppColors.yellowSoftmax), // Color del ícono actualizado.
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Confiable', Icons.lock_open_rounded),
                _buildInfoRow('Segura', Icons.enhanced_encryption_rounded),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Widget para crear filas de información.
  Widget _buildInfoRow(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.vividNavy),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14, color: AppColors.vividNavy)),
        ],
      ),
    );
  }
}

// Widget para la página de "Información al Día".
class InformacionAlDiaPage extends StatelessWidget {
  const InformacionAlDiaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Información al Día',
              style: TextStyle(
                fontSize: 13, // Título del tamaño de fuente 13.
                fontWeight: FontWeight.bold,
                color: AppColors.vividNavy,
              ),
            ),
            // Menú de tres puntos.
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.vividNavy),
              onSelected: (String result) {
                if (result == 'verMas') {
                  context.go('/noticias');
                } else if (result == 'configurar') {
                  // Lógica para ir a la página de configuración.
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'verMas',
                  child: Text('Ver más'),
                ),
                const PopupMenuItem<String>(
                  value: 'configurar',
                  child: Text('Configurar'),
                ),
              ],
            ),
          ],
        ),
        // Se elimina la línea divisoria.
        const SizedBox(height: 10),
        _buildInfoRow('Facturas fiscal venezuela', Icons.info_outline),
        _buildInfoRow('Actualiza tu RIF', Icons.info_outline),
        _buildInfoRow('Valor de la unidad vigente', Icons.info_outline),
      ],
    );
  }

  // Widget para crear filas de información.
  Widget _buildInfoRow(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.vividNavy),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14, color: AppColors.vividNavy)),
        ],
      ),
    );
  }
}

// CustomPainter para dibujar la ola de mar.
// Se mantiene separada ya que es una clase de pintor personalizada.
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Path para la ola.
    final path = Path()
      ..moveTo(size.width, size.height * 0.4)
      ..cubicTo(size.width * 0.75, size.height * 0.1, size.width * 0.5, size.height * 0.6, size.width * 0.4, size.height * 0.4)
      ..cubicTo(size.width * 0.3, size.height * 0.5, size.width * 0.1, size.height * 0.8, 0, size.height * 0.9)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
