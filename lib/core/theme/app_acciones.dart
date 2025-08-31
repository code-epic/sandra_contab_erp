import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter/services.dart';

import 'app_color.dart' show AppColors;

// Clase que genera la tarjeta de acciones.
class AccionesContablesCard extends StatelessWidget {
  final List<ActionItem> items;
  const AccionesContablesCard({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
              (index) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ActionTile(item: items[index]),
          ),
        ),
      ),
    );
  }
}


typedef OnActionTap = void Function(BuildContext context);

class ActionItem {
  final IconData icon;
  final String label;
  final String detail;
  final Color color;
  final String? ruta;
  final OnActionTap onTap;

  ActionItem({
    required this.icon,
    required this.label,
    required this.detail,
    required this.color,
    this.ruta,
    required this.onTap,
  });
}

// Widget de un solo ítem en la lista, rediseñado y con animación.
class ActionTile extends StatefulWidget {
  final ActionItem item;
  const ActionTile({required this.item, super.key});

  @override
  State<ActionTile> createState() => _ActionTileState();
}

class _ActionTileState extends State<ActionTile> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          widget.item.onTap(context);
          HapticFeedback.lightImpact();
        },
        borderRadius: BorderRadius.circular(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: widget.item.color,
              ),
              child: Icon(widget.item.icon, color: Colors.white, size: 24),
            ),
            title: Text(
              widget.item.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textVividNavy,
              ),
            ),
            subtitle: Text(
              widget.item.detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textVividNavy.withOpacity(0.6),
              ),
            ),
            trailing: Icon(PhosphorIcons.arrowRight(), color: AppColors.textVividNavy.withOpacity(0.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
