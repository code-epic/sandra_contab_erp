import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart' hide AppColors;
import 'package:sandra_contab_erp/core/theme/app_color.dart';

// --- Definición de datos de ejemplo (Venezuela) con RIF ---
var DtoCuentaExample =  [
  Cuenta(rif: 'J-30504090-7', codigo: '1', descripcion: 'ACTIVOS', naturaleza: 'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '1.1', descripcion: 'ACTIVO CORRIENTE', naturaleza: 'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '1.1.1', descripcion: 'CAJA Y BANCOS', naturaleza:  'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '1.1.1.1', descripcion: 'CAJA PRINCIPAL', naturaleza:  'DEBE', totalizadora: false, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '1.1.1.2', descripcion: 'BANCOS NACIONALES', naturaleza:  'DEBE', totalizadora: false, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '2', descripcion: 'PASIVOS', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '2.1', descripcion: 'PASIVO CORRIENTE', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '3', descripcion: 'PATRIMONIO', naturaleza:  'DEBE/HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'J-30504090-7', codigo: '4', descripcion: 'INGRESOS', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),

  Cuenta(rif: 'V-12345678-9', codigo: '1', descripcion: 'ACTIVOS', naturaleza: 'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '1.1', descripcion: 'ACTIVO CORRIENTE', naturaleza: 'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '2', descripcion: 'PASIVOS', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '2.1', descripcion: 'PASIVO CORRIENTE', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '3', descripcion: 'PATRIMONIO', naturaleza:  'DEBE/HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '4', descripcion: 'INGRESOS', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '5', descripcion: 'GASTOS', naturaleza:  'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'V-12345678-9', codigo: '5.1', descripcion: 'GASTOS DE OFICINA', naturaleza:  'DEBE', totalizadora: true, moneda: 'Bs.'),

  Cuenta(rif: 'G-98765432-1', codigo: '1', descripcion: 'ACTIVOS', naturaleza: 'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'G-98765432-1', codigo: '1.1', descripcion: 'ACTIVO CORRIENTE', naturaleza: 'DEBE', totalizadora: true, moneda: 'Bs.'),
  Cuenta(rif: 'G-98765432-1', codigo: '2', descripcion: 'PASIVOS', naturaleza:  'HABER', totalizadora: true, moneda: 'Bs.'),
];


// --- Modelo de datos para la empresa ---
class Company {
  final String rif;
  final String razonSocial;
  final String actividad;

  const Company({
    required this.rif,
    required this.razonSocial,
    required this.actividad,
  });
}

// --- CustomPainter para el efecto de onda ---
class WavePainter extends CustomPainter {
  final Color waveColor;
  final double animationValue;

  WavePainter({required this.waveColor, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.9);

    for (double i = 0; i < size.width; i++) {
      final y = size.height * 0.9 + 5 * sin((i / 40 + animationValue) * pi * 2);
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// --- Tarjeta para mostrar la información de la empresa ---
class CardClientCompany extends StatefulWidget {
  final List<Company> companies;
  final Function(Company) onCompanyChanged;

  const CardClientCompany({
    required this.companies,
    required this.onCompanyChanged,
    super.key,
  });

  @override
  State<CardClientCompany> createState() => _CardClientCompanyState();
}

class _CardClientCompanyState extends State<CardClientCompany> with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  late Color _waveColor;
  final _random = Random();
  final List<Color> _waveColors = [
    AppColors.purpleSoftmax,
    AppColors.greenSoftmax,
    AppColors.yellowSoftmax,
    AppColors.redSoftmax,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
          _waveColor = _waveColors[_random.nextInt(_waveColors.length)];
        });
        widget.onCompanyChanged(widget.companies[newPage]);
      }
    });

    _waveColor = _waveColors[_random.nextInt(_waveColors.length)];
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_waveController);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120, // Ajusta la altura del carrusel según tus necesidades
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.companies.length,
            itemBuilder: (context, index) {
              final company = widget.companies[index];
              return Stack(
                children: [
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Company image/icon
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: AppColors.purpleSoftmax,
                            ),
                            child: Icon(
                              PhosphorIcons.buildings(),
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  company.razonSocial,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textVividNavy,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'RIF: ${company.rif}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textVividNavy.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Actividad: ${company.actividad}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textVividNavy.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AnimatedBuilder(
                        animation: _waveAnimation,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: WavePainter(
                              waveColor: _waveColor,
                              animationValue: _waveAnimation.value,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.companies.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppColors.purpleSoftmax
                    : AppColors.purpleSoftmax.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// --- Clase que genera la tarjeta de contenido para cada cuenta ---
class CuentaCard extends StatelessWidget {
  final Cuenta cuenta;
  final VoidCallback onEdit;
  final bool isParent;
  final bool isExpanded;
  final GestureLongPressStartCallback onLongPress;

  const CuentaCard({
    required this.cuenta,
    required this.onEdit,
    required this.onLongPress,
    this.isParent = false,
    this.isExpanded = false,
    super.key,
  });

  Color _getNatureColor(String naturaleza) {
    if (naturaleza.contains('DEBE')) return AppColors.greenSoft;
    if (naturaleza.contains('HABER')) return AppColors.yellowSoft;
    return AppColors.purpleSoft;
  }

  Color _getNatureVividColor(String naturaleza) {
    if (naturaleza.contains('DEBE')) return AppColors.greenSoftmax;
    if (naturaleza.contains('HABER')) return AppColors.yellowSoftmax;
    return AppColors.purpleSoftmax;
  }

  @override
  Widget build(BuildContext context) {
    final leadingColor = _getNatureColor(cuenta.naturaleza);
    final vividColor = _getNatureVividColor(cuenta.naturaleza);
    final totalizadoraIcon = cuenta.totalizadora ? PhosphorIcons.sigma() : PhosphorIcons.file();

    return GestureDetector(
      onTap: onEdit,
      onLongPressStart: onLongPress,
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppColors.vividNavy.withOpacity(0.8),
                ),
                child: Icon(totalizadoraIcon, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cuenta.codigo} - ${cuenta.descripcion}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textVividNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Naturaleza: ${cuenta.naturaleza}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textVividNavy.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isParent)
                Icon(
                  isExpanded ? PhosphorIcons.caretUp() : PhosphorIcons.caretDown(),
                  color: AppColors.textVividNavy.withOpacity(0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Nuevo widget para las sub-cuentas (Hijos) ---
class HijoCuentaCard extends StatelessWidget {
  final Cuenta cuenta;
  final VoidCallback onEdit;
  final bool isParent;
  final bool isExpanded;
  final GestureLongPressStartCallback onLongPress;

  const HijoCuentaCard({
    required this.cuenta,
    required this.onLongPress,
    required this.onEdit,
    this.isParent = false,
    this.isExpanded = false,
    super.key,
  });

  Color _getNatureColor(String naturaleza) {
    if (naturaleza.contains('DEBE')) return AppColors.greenSoft;
    if (naturaleza.contains('HABER')) return AppColors.yellowSoft;
    return AppColors.purpleSoft;
  }

  @override
  Widget build(BuildContext context) {
    final totalizadoraIcon = cuenta.totalizadora ? PhosphorIcons.folder() : PhosphorIcons.file();
    final isTotalizadora = cuenta.totalizadora;

    return GestureDetector(
      onTap: onEdit,
      onLongPressStart: onLongPress,
      child: Card(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            children: [
              Container(
                height: 20,
                width: 2,
                color: AppColors.vividNavy.withOpacity(0.3),
              ),
              const SizedBox(width: 10),
              Icon(
                totalizadoraIcon,
                color: AppColors.textVividNavy.withOpacity(isTotalizadora ? 0.8 : 0.6),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${cuenta.codigo} - ${cuenta.descripcion}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textVividNavy.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Naturaleza: ${cuenta.naturaleza}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textVividNavy.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isParent)
                Icon(
                  isExpanded ? PhosphorIcons.caretUp() : PhosphorIcons.caretDown(),
                  color: AppColors.textVividNavy.withOpacity(0.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}