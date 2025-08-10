import 'package:flutter/material.dart';

class AccionesContablesCard extends StatelessWidget {

  final List<ActionItem> items;
  const AccionesContablesCard({
    super.key,
    required this.items,
  });
  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(4),
      color: Colors.white.withOpacity(.98),
      elevation: 0.4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
              (index) => Column(
            children: [
              ActionTile(item: items[index]),
              if (index < items.length - 1) const Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }

  void navigate(BuildContext context, String route) =>
      Navigator.pushNamed(context, route);
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

class ActionTile extends StatelessWidget {
  final ActionItem item;
  const ActionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon, color: item.color, size: 28),
      title: Text(
        item.label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        item.detail,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      onTap: () => item.onTap(context),

    );
  }
}