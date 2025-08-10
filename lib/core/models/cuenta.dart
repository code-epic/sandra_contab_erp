import 'package:flutter/material.dart';

class Cuenta {
  final String codigo;
  final String descripcion;
  final String naturaleza;
  final bool totalizadora;
  final String? moneda;

  const Cuenta({
    required this.codigo,
    required this.descripcion,
    required this.naturaleza,
    this.totalizadora = false,
    this.moneda = 'Bs.'
  });
}



class AppColors {
  static const Color softGrey = Color(0xFFE5E5E5);
  static const Color vividNavy = Color(0xFF191970);
  static const Color paleBlue = Color(0xFFADD8E6);
}


class XHeader extends StatelessWidget {
  final void Function(int) onSort;
  final bool asc;
  final int sortCol;

  const XHeader({super.key, required this.onSort, required this.asc, required this.sortCol});

  Widget _cell(String label, int col, {int flex = 1}) => Expanded(
    flex: flex,
    child: InkWell(
      onTap: () => onSort(col),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            if (sortCol == col)
              Icon(asc ? Icons.arrow_upward : Icons.arrow_downward, size: 16),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Row(
        children: [
          _cell('CUENTA', 0, flex: 5),
          _cell('DESCRIPCION', 1, flex: 4),
          _cell('NAT', 2, flex: 1),
        ],
      ),
    );
  }
}

class XRow extends StatelessWidget {
  final Cuenta cuenta;
  final VoidCallback onTap;

  const XRow({super.key, required this.cuenta, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Text(
                cuenta.codigo,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                cuenta.descripcion,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                cuenta.naturaleza,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}