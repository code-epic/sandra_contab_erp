import 'package:flutter/material.dart';
import 'app_color.dart';

class AlertService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Método para mostrar el Alert
  static void ShowAlert(BuildContext context, String message, {int type = 1}) {
    showDialog(
      context: context,
      barrierDismissible: type != 2, // Solo se puede cerrar tipo 1 con un gesto o botón
      builder: (BuildContext context) {
        if (type == 2) {
          // Modal de Cargando (Tipo 2)
          return Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                // Permite cerrar el modal tocando en cualquier parte (si es necesario)
                HideAlert(context); // Cierra el modal al tocar
              },
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.steelBlue),
                ),
              ),
            ),
          );
        }

        // Modal normal con icono estático (Tipo 1)
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Esquinas redondeadas para el modal
          ),
          contentPadding: EdgeInsets.all(2),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.easeInOut,
                width: 80,
                height: 80,
                child: Icon(
                  Icons.warning_amber_rounded,
                  size: 60,
                  color: AppColors.darkOrange,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                HideAlert(context); // Cierra el modal cuando presionas aceptar
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Aceptar',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.softGrey),
              ),
            ),
          ],
        );
      },
    );
  }

  // Método para ocultar el modal cuando lo desees
  static void HideAlert(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop(); // Cierra el último dialog abierto
    }
  }
}
