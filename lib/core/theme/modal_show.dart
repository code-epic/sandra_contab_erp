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


  static void ShowCongratulation(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: 300,
            height: 400,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Fondo degradado azul en la parte superior
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Center(
                    // Imagen circular en el centro
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: Image.asset(
                          'sandra.png', // Asegúrate de tener la imagen sandra.png en tus assets
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "¡Felicitaciones!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Spacer(),

                // Botón de continuar
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Continuar", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
