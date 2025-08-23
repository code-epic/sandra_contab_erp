import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandra_contab_erp/core/models/cuenta.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/providers/scan_provider.dart';
import 'dart:io';

import 'package:sandra_contab_erp/screen/preview_edit_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanProvider = Provider.of<ScanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppColors.softGrey,
        backgroundColor: AppColors.vividNavy,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: AppColors.paleBlue,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).pop(),
            ),
            const Text('Previsualizar y Editar'),
          ],
        ),
        actions: <Widget>[


        ],
      ),
      backgroundColor: Colors.white.withOpacity(.98),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}