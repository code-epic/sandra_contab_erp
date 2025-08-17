import 'package:flutter/material.dart';

import 'app_color.dart';

void ShowAlert(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
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
              Navigator.of(context).pop();
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