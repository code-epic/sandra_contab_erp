import 'package:flutter/material.dart';
import 'dart:math' as math;

// Define los datos de tu tarjeta
class GoalData {
  final int total;
  final int reviewed;
  final int pending;
  final int analyzed;

  GoalData({
    required this.total,
    required this.reviewed,
    required this.pending,
    required this.analyzed,
  });

  double get progressPercentage => (reviewed + analyzed) / total;
}

// Clase para los datos de la tabla
class ItemData {
  final String title;
  final int value;
  final Color color;
  final IconData icon;

  ItemData({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });
}

// Widget principal que construye la tarjeta
class GoalProgressCard extends StatelessWidget {
  final GoalData data;
  const GoalProgressCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Calcula los datos para la tabla estilizada
    final List<ItemData> items = [
      ItemData(
        title: 'Revisión',
        value: data.reviewed,
        color: const Color(0xFFF7BD69),
        icon: Icons.check_circle_outline,
      ),
      ItemData(
        title: 'Pendientes',
        value: data.pending,
        color: const Color(0xFF88D3CE),
        icon: Icons.access_time,
      ),
      ItemData(
        title: 'Analizado',
        value: data.analyzed,
        color: const Color(0xFFC0A2D3),
        icon: Icons.analytics_outlined,
      ),
    ];

    return Card(
      color: Colors.white,
      elevation: 0, // Sombra sutil
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cumplimiento de metas',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF283E51),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sección del gráfico circular
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CustomPaint(
                      painter: ProgressPainter(
                        progress: data.progressPercentage,
                        circleColor: const Color(0xFFE9EEF2),
                        progressColor: const Color(0xFF7CB8B0),
                      ),
                      child: Center(
                        child: Text(
                          '${(data.progressPercentage * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF283E51),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24.0),
                // Sección de la tabla estilizada
                Expanded(
                  flex: 2,
                  child: Column(
                    children: items.map((item) => buildRow(item)).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(ItemData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                item.icon,
                color: item.color,
                size: 20,
              ),
              const SizedBox(width: 8.0),
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF283E51),
                ),
              ),
            ],
          ),
          Text(
            item.value.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF283E51),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter para el gráfico de progreso
class ProgressPainter extends CustomPainter {
  final double progress;
  final Color circleColor;
  final Color progressColor;

  ProgressPainter({
    required this.progress,
    required this.circleColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - 5;

    // Pinta el círculo base (fondo)
    final circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawCircle(center, radius, circlePaint);

    // Pinta el arco de progreso
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final arcAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      arcAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
