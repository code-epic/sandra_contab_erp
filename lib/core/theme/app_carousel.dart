import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';


class ConceptsCarousel extends StatefulWidget {
  const ConceptsCarousel({super.key});
  @override
  State<ConceptsCarousel> createState() => _ConceptsCarouselState();
}


class _ConceptsCarouselState extends State<ConceptsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  final List<Map<String, String>> conceptos = [
    {
      'title': 'Gestión de Clientes',
      'desc': 'Registro y análisis de clientes.',
      'svg':  assetPath('svg/cliente.svg'),
      'url': '/cliente',
    },
    {
      'title': 'Contabilidad',
      'desc': 'Registro y análisis de transacciones financieras.',
      'svg':  assetPath('svg/calculator.svg'),
      'url': '/contab',
    },
    {
      'title': 'Compras y Ventas',
      'desc': 'Controla la adquisición y venta de bienes y servicios.',
      'svg':  assetPath('svg/invoice.svg'),
      'url': '/sales',
    },
    {
      'title': 'Nóminas y Finiquitos',
      'desc': 'Cálculo de salarios, deducciones y compensaciones.',
      'svg':  assetPath('svg/payroll.svg'),
      'url': '/nomina',
    },
    {
      'title': 'Pagos y Tesorería',
      'desc': 'Gestión de liquidez, pagos y cobros.',
      'svg':  assetPath('svg/wallet.svg'),
      'url': '/pagos',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() =>
        setState(() => _currentPage = _controller.page!.round()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 260,
          child: PageView.builder(
            controller: _controller,
            itemCount: conceptos.length,
            itemBuilder: (context, index) {
              final c = conceptos[index];
              final scale = _currentPage == index ? 1.0 : 0.85;
              final opacity = _currentPage == index ? 1.0 : 0.6;

              return AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 300),
                child: AnimatedOpacity(
                  opacity: opacity,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: InkWell(
                      onTap: () {
                        print(c['url']);
                        var url = c['url']?? '';
                        context.push( url );
                      },
                      child: Card(
                        elevation: 4,
                        color: Colors.white.withOpacity(.98),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(

                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Expanded(
                                child: SvgPicture.asset(
                                  c['svg']!,

                                  fit: BoxFit.contain,

                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                c['title']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c['desc']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            conceptos.length,
                (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == i ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? Colors.deepPurple : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
            ),
        ),
      ],
    );
  }
  }

