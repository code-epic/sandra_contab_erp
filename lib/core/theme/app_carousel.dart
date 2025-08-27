import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/models/module.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';


class ConceptsCarousel extends StatefulWidget {
  final List<Module> modules;
  final Function(Module)? onPageChanged;
  const ConceptsCarousel({super.key, required this.modules, this.onPageChanged});
  @override
  State<ConceptsCarousel> createState() => _ConceptsCarouselState();
}


class _ConceptsCarouselState extends State<ConceptsCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.2);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToPage(5000 + (widget.modules.length ~/ 2));
    });
    _controller.addListener(() {
      if (_controller.page != null) {
        final newPage = _controller.page!.round();
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
          final selectedModule = widget.modules[_currentPage % widget.modules.length];
          widget.onPageChanged?.call(selectedModule);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: PageView.builder(
        controller: _controller,
        itemCount: 10000,
        itemBuilder: (context, index) {
          final effectiveIndex = index % widget.modules.length;
          final m = widget.modules[effectiveIndex];

          final scale = _currentPage % widget.modules.length == effectiveIndex ? 1.6 : 1.0;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () {
                context.push(m.route);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(4),

                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: scale,
                      child: Icon(
                        m.icon,
                        size: 22,
                        color: AppColors.vividNavy,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
