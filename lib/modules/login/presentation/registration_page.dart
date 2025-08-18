import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/modules/security/auth_service.dart';

  class RegistrationPage extends StatefulWidget {
    const RegistrationPage({super.key});

    @override
    State<RegistrationPage> createState() => _RegistrationPageState();
  }

  class _RegistrationPageState extends State<RegistrationPage> {

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.softGrey,
        body:
        Container(

            child: Center (

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 54),
                            Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(assetPath('job.png')),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(1), // borde delicado
                                      width: 2.4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 14,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Bienvenido a Sandra Contab App',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.navy,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 54),
                            textoRequisitos(
                              'Para continuar el proceso de creación de cuenta y nuestros servicios, debes cumplir lo siguientes requisitos.'
                            ),
                            const SizedBox(height: 16),
                            textoRequisitos(
                              '1. Venezolano mayor de edad\n2. Ser contador público debidamente certificado.'
                            ),
                            const SizedBox(height: 20),
                            textoRequisitos(
                              'También debe tener a la mano los siguientes documentos'
                            ),
                            const SizedBox(height: 16),
                            textoRequisitos(
                              '1. RIF vigente\n2. Cédula de Identidad laminada'
                            ),
                            const SizedBox(height: 20),
                            textoRequisitos(
                              'Una vez culminado el proceso de registro debe autenticar con tu huella en los dispositivos ContabApp'
                            ),
                            const SizedBox(height: 30),
                            textoRequisitos(
                              'Para Sandra Contab App, llevaremos la contabilidad a tus manos'
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.go('/'), // Navega a la página anterior
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.steelBlue),
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.steelBlue),
                              label: const Text(
                                'Ir atrás',
                                style: TextStyle(color: AppColors.steelBlue),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => context.go('/registration_step_2'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.steelBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Continuar'),
                                  SizedBox(width: 8),     // espacio entre texto e icono
                                  Icon(Icons.arrow_forward_ios, size: 16),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
          ),

            ),
        ),
      );
    }
  }