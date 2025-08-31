import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:go_router/go_router.dart';

import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/models/floating_bar.dart';
import 'package:sandra_contab_erp/core/models/goaldprogress_card.dart';
import 'package:sandra_contab_erp/core/models/module.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/core/theme/app_carousel.dart';
import 'package:sandra_contab_erp/core/theme/asistenteia_card.dart';
import 'package:sandra_contab_erp/core/theme/publicaciones_card.dart';

import 'package:sandra_contab_erp/core/models/api_service.dart';
import 'package:sandra_contab_erp/core/models/empresa.dart';
import 'package:sandra_contab_erp/core/services/vector_generator_service.dart';


import '../security/auth_service.dart';
import 'dart:async';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  final _vectorGeneratorService = VectorGeneratorService();
  final ApiService _apiService = ApiService();


  Future<void> _saveEmpresa() async {
    try {
      await _vectorGeneratorService.loadModel();
      print('Modelo TFLite cargado exitosamente.');
      final combinedText = "Comercio, Servicios, Ventas de repuestos, Venta de productos electrónicos.";
      final perfilVector = await _vectorGeneratorService.generateVector(combinedText);
      // Crea el objeto Empresa
      final nuevaEmpresa = Empresa(
        // ... otros campos del formulario ...
        rif: 'J-12345678-9',
        nombreComercial: 'Empresa de Prueba',
        rubroEconomico: ['Comercio', 'Servicios'],
        perfilVector: perfilVector,
        documentosDigitales: [],
        contadorId: '123456789',
        fechaCreacion: DateTime.now(),
        ultimaActualizacion: DateTime.now(),
      );

      print(nuevaEmpresa.toJson());

      final result = await _apiService.ejecutar(funcion: 'CTAB_IEmpresa', valores: nuevaEmpresa.toJson());


      if (result.containsKey('msj') && result['msj'] != null) {


      } else if (result.containsKey('Cuerpo')) {
        print(result['Cuerpo']);
      }
      print(result);

      // _vectorGeneratorService.dispose();

      print('Empresa guardada exitosamente.');

    } catch (e) {
      print('Error al cargar el modelo TFLite: $e');
    }
  }

  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.decelerate,
      ),
    );
    // _loadModules();
  }

  _loadModules() async {
    final player = AudioPlayer();
    await player.play(AssetSource('sound/home.mp3'));
  }



  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        foregroundColor: AppColors.vividNavy,
        backgroundColor: AppColors.softGrey,
        automaticallyImplyLeading: false, // Oculta la flecha de retroceso
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: Icon(PhosphorIcons.textIndent()),
              color: AppColors.vividNavy,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            const Text('ContabApp'),
          ],
        ),
        actions: <Widget>[
          Row(
            children: [
              IconButton(
                tooltip: 'Explorador',
                icon: Icon(PhosphorIcons.desktop()),
                onPressed: () {
                  context.go('/explorador');
                },
              ),
              IconButton(
                tooltip: 'Cerrar Sesión',
                icon: Icon(PhosphorIcons.door()),
                onPressed: () {
                  _authService.logout();
                  context.go('/login');
                },
              ),
            ],
          ),
        ],
      ),
      backgroundColor: AppColors.softGrey,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 150.0, left: 8, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GoalProgressCard(data: GoalData(
                total: 30,
                reviewed: 10,
                pending: 15,
                analyzed: 5,
              )),
              const SizedBox(height: 5.0),
              // Aquí se agrega la nueva tarjeta
              PublicacionesCard(data: PublicationData(
                leyes: 50,
                normativas: 320,
                instructivos: 30,
              )),
              const SizedBox(height: 5.0),
              GoalAndAssistantCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FloatingNavBar(),
    );
  }
}


