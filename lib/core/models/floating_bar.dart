import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/models/module.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_carousel.dart';


import 'dart:async';

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

  void _onModuleTapped(String route) {
    GoRouter.of(context).go(route);
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
              onPageTapped: _onModuleTapped, // Pasam
              // onPageChanged: _onModuleChanged,
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

