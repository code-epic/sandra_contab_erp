import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:sandra_contab_erp/core/constants/modules.dart';
import 'package:sandra_contab_erp/core/theme/app_color.dart';
import 'package:sandra_contab_erp/modules/security/auth_service.dart';

class RegistrationStep2Page extends StatefulWidget {
  const RegistrationStep2Page({super.key});

  @override
  State<RegistrationStep2Page> createState() => _RegistrationStep2Page();
}

class _RegistrationStep2Page extends State<RegistrationStep2Page> {

  bool _acceptedPolicies = false;

  final String _privacyPolicyText = """
  ## 1. Introducción
  Bienvenido a Sandra Contab App. Su privacidad es de suma importancia para nosotros. Esta política de privacidad describe cómo recopilamos, utilizamos, procesamos y compartimos su información personal.

  ## 2. Información que Recopilamos
  Para poder brindarle nuestros servicios, recopilamos la siguiente información personal:
  * Información de Registro: Al crear una cuenta, recopilamos su nombre, dirección de correo electrónico, y otros datos de contacto.
  * Información del Perfil: Recopilamos información sobre su profesión (contador público), RIF y número de cédula de identidad, para validar su registro.
  * Datos de Uso del Servicio: Recopilamos datos sobre cómo interactúa con nuestra aplicación, incluyendo el tipo de operaciones contables que realiza y la frecuencia de uso.
  * Datos de Autenticación Biométrica: Al activar la autenticación con huella dactilar, el sistema de su dispositivo gestiona esta información. Nosotros no almacenamos sus datos biométricos. Solo verificamos si la autenticación fue exitosa.

  ## 3. Uso de la Información
  Utilizamos su información para:
  * Mejorar, personalizar y expandir
  * Entender y analizar cómo utiliza nuestra aplicación
  * Desarrollar nuevos productos, y funcionalidades.
  * Comunicarnos con usted, directamente o a través de uno de nuestros socios, para servicio al cliente, para proporcionarle actualizaciones y otra información relacionada con el servicio.
  * Procesar sus transacciones.

  ## 4. Compartir Información
  No vendemos, comerciamos ni alquilamos su información personal a terceros. Solo compartimos su información con terceros de confianza que nos ayudan a operar nuestra aplicación, conducir nuestro negocio o servirle, siempre que esas partes acuerden mantener esta información confidencial.

  ## 5. Seguridad de la Información
  Implementamos una variedad de medidas de seguridad para mantener la seguridad de su información personal. Sus datos están almacenados en servidores seguros y el acceso está restringido a nuestro personal autorizado.

  ## 6. Sus Derechos
  Usted tiene derecho a acceder, corregir, actualizar o solicitar la eliminación de su información personal.

  ## 7. Cambios en esta Política
  Podemos actualizar nuestra Política de Privacidad de vez en cuando. Le notificaremos sobre cualquier cambio publicando la nueva Política de Privacidad en esta página.
  """
      .replaceAll('  ', '') // Elimina espacios extra
      .replaceAll('\n\n', '\n'); // Normaliza saltos de línea

  // Esta función auxiliar se encarga de parsear el texto de Markdown y
  // construir los widgets de texto con el estilo adecuado.
  List<Widget> _buildPrivacyPolicyContent(BuildContext context) {
    // Definimos los estilos para los diferentes elementos de Markdown
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold);
    final subtitleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    final bodyStyle = Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 13);

    // Dividimos el texto en líneas para procesarlas
    final lines = _privacyPolicyText.split('\n');
    final List<Widget> widgets = [];

    // Iteramos sobre cada línea y creamos el widget correspondiente
    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      if (line.startsWith('# ')) {
        widgets.add(Text(line.substring(2), style: titleStyle, textAlign: TextAlign.justify));
      } else if (line.startsWith('## ')) {
        widgets.add(Text(line.substring(3), style: subtitleStyle, textAlign: TextAlign.justify));
      } else if (line.startsWith('* ')) {
        // Para los elementos de la lista, extraemos el texto y lo ponemos en negrita
        final parts = line.substring(2).split(':');
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 4.0),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                text: '• ',
                style: bodyStyle?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: '${parts[0]}: ',
                    style: bodyStyle?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: parts.length > 1 ? parts.sublist(1).join(':').trim() : '',
                    style: bodyStyle,
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        widgets.add(Text(line, style: bodyStyle, textAlign: TextAlign.justify));
      }
      widgets.add(const SizedBox(height: 8));
    }

    return widgets;
  }
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
              Center (
                child: SingleChildScrollView(
                padding:  EdgeInsets.only(left:   24.0,
                  top:   84.0,
                  right:  0.0,
                  bottom: 0.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                        Row(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(assetPath('sandra.png')),
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
                                'Políticas de Privacidad',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navy,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                  ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 20,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      ..._buildPrivacyPolicyContent(context),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: _acceptedPolicies,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _acceptedPolicies = newValue ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text(
                              'Acepto los términos y condiciones de las políticas de privacidad de Sandra Contab App.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                        onPressed: () => context.push('/register'), // Navega a la página anterior
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
                      child: ElevatedButton.icon(
                        onPressed: _acceptedPolicies
                            ? () => context.push('/registration_step_3')
                            : null, // El botón está deshabilitado si no se aceptan las políticas
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _acceptedPolicies ? AppColors.steelBlue : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        label: const Text('Continuar'),
                      ),
                    ),
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