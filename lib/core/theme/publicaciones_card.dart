import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:sandra_contab_erp/core/theme/app_color.dart';

class PublicationData {
  final int leyes;
  final int normativas;
  final int instructivos;

  PublicationData({
    required this.leyes,
    required this.normativas,
    required this.instructivos,
  });
}

// Widget de la nueva tarjeta de publicaciones
class PublicacionesCard extends StatefulWidget {
  final PublicationData data;
  const PublicacionesCard({super.key, required this.data});

  @override
  State<PublicacionesCard> createState() => _PublicacionesCardState();
}

class _PublicacionesCardState extends State<PublicacionesCard> {
  // Datos simulados para el gráfico de barras
  final List<DailyData> dailyData = [
    DailyData(day: 'LUN', count: 5),
    DailyData(day: 'MAR', count: 3),
    DailyData(day: 'MIÉ', count: 2),
    DailyData(day: 'JUE', count: 5),
    DailyData(day: 'VIE', count: 1),
    DailyData(day: 'SÁB', count: 6),
    DailyData(day: 'DOM', count: 4),
  ];

  String _selectedDay = DateFormat('dd').format(DateTime.now());
  String _selectedMonth = DateFormat('MMM').format(DateTime.now()).toUpperCase();

  void _onDayChanged(int index) {
    setState(() {
      final now = DateTime.now();
      final newDay = now.subtract(Duration(days: now.weekday - 1)).add(Duration(days: index));
      _selectedDay = DateFormat('dd').format(newDay);
      _selectedMonth = DateFormat('MMM').format(newDay).toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Normativas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.vividNavy,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPublicationItem(
                  'Contable',
                  widget.data.leyes,
                  const Color(0xFFF7BD69),
                  Icons.local_fire_department,
                  const Color(0xFFF7BD69).withOpacity(0.9),
                ),
                _buildPublicationItem(
                  'Laborales',
                  widget.data.normativas,
                  const Color(0xFF88D3CE),
                  Icons.article,
                  const Color(0xFF88D3CE).withOpacity(0.9),
                ),
                _buildPublicationItem(
                  'Tributarias',
                  widget.data.instructivos,
                  const Color(0xFFC0A2D3),
                  Icons.access_time_filled,
                  const Color(0xFFC0A2D3).withOpacity(0.9),
                ),
              ],
            ),
            const Divider(color: AppColors.softGrey, thickness: 1),
            Row(
              children: [
                Container(
                  width: 70,
                  height: 80, // Altura fija para simetría con el carrusel
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDay,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC0A2D3).withOpacity(0.9),
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 0.6,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        _selectedMonth,
                        style: TextStyle(
                          fontSize: 18,
                          color: const Color(0xFFC0A2D3).withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 0.6,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: BarChartCarousel(
                    data: dailyData,
                    onDayChanged: _onDayChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationItem(String title, int count, Color color, IconData icon, Color iconcolor) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // Lógica de navegación o acción al hacer clic
        },
        child: Card(
          color: color.withOpacity(0.15), // Aplica la opacidad aquí
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 24, color: iconcolor),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.vividNavy,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.vividNavy,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget del carrusel de barras
class BarChartCarousel extends StatefulWidget {
  final List<DailyData> data;
  final Function(int)? onDayChanged;
  const BarChartCarousel({super.key, required this.data, this.onDayChanged});

  @override
  State<BarChartCarousel> createState() => _BarChartCarouselState();
}

class _BarChartCarouselState extends State<BarChartCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.2);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpToPage(5000);
    });
    _controller.addListener(() {
      if (_controller.page != null) {
        final newPage = _controller.page!.round();
        if (_currentPage != newPage) {
          setState(() => _currentPage = newPage);
          final effectiveIndex = newPage % widget.data.length;
          widget.onDayChanged?.call(effectiveIndex);
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
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 17,
            child: Container(
              height: 1.0,
              color: AppColors.softGrey,
            ),
          ),
          PageView.builder(
            controller: _controller,
            itemCount: 10000,
            itemBuilder: (context, index) {
              final effectiveIndex = index % widget.data.length;
              final item = widget.data[effectiveIndex];
              final isSelected = effectiveIndex == (_currentPage % widget.data.length);
              final barColor = isSelected ? AppColors.vividNavy : AppColors.softGrey;

              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final maxHeight = constraints.maxHeight;
                  final textHeight = 12 + 4 + 12 + 4 + 12; // Altura estimada del texto y espacios
                  final barMaxHeight = maxHeight - textHeight;
                  final barHeight = (item.count.toDouble() / 6.0) * barMaxHeight;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${item.count}',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFFC0A2D3).withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          width: 20,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          item.day,
                          style: TextStyle(
                            fontSize: isSelected ? 12 : 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? const Color(0xFFC0A2D3).withOpacity(0.9) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}


class DailyData {
  final String day;
  final int count;

  DailyData({required this.day, required this.count});
}
