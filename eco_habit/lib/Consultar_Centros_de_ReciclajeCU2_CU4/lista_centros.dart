import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controlador_centros.dart';
import 'informacion_centro.dart';
import 'model_centros.dart'; 

class CentrosReciclaje extends StatelessWidget {
  const CentrosReciclaje({super.key});

  void solicitarCentros(ControladorCentros controlador) {
    controlador.cargarCentros();
  }

  void navegar(BuildContext context, Centro centro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformacionCentro(centro: centro),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ControladorCentros(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Centros de Reciclaje"),
          backgroundColor: const Color(0xff368983),
        ),
        body: Consumer<ControladorCentros>(
          builder: (context, controlador, child) {
            // Llamar a solicitarCentros al inicializar
            if (!controlador.cargando && controlador.centros.isEmpty) {
              solicitarCentros(controlador);
            }

            if (controlador.cargando) {
              return const Center(child: CircularProgressIndicator());
            }

            final centros = controlador.centros;

            if (centros.isEmpty) {
              return const Center(child: Text('No se encontraron centros.'));
            }

            return ListView.builder(
              itemCount: centros.length,
              itemBuilder: (context, index) {
                final centro = centros[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(centro.imagenUrl, width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(centro.nombre),
                    subtitle: Text(centro.ciudad),
                    onTap: () => navegar(context, centro),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}