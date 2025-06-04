import 'package:flutter/material.dart';

class PoliticaPage extends StatelessWidget {
  const PoliticaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política y Acuerdos de Uso'),
        backgroundColor: Color(0xff368983),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''Al utilizar esta aplicación, aceptas los términos de uso y políticas de privacidad establecidas por Infinitary.

Recolectamos y almacenamos información mínima y necesaria para el funcionamiento adecuado de la aplicación, incluyendo tus preferencias de configuración, historial de habitos, asi como acceso al sistema de notificaciones del dispositivo.

Infinitary se compromete a proteger tu información y no compartirá tus datos con terceros sin tu consentimiento.

Al continuar usando esta app, aceptas estas condiciones.''',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
