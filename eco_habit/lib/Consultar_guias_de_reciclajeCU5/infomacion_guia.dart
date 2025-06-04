import 'package:flutter/material.dart';
import 'model_guias.dart';

class InformacionGuia extends StatefulWidget {
  final Guia guia;

  const InformacionGuia({super.key, required this.guia});

  @override
  _InformacionGuiaState createState() => _InformacionGuiaState();
}

class _InformacionGuiaState extends State<InformacionGuia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guia.titulo),  // Accede al widget usando widget.guia
        backgroundColor: const Color(0xff368983),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen principal
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                widget.guia.imagenUrl, 
                fit: BoxFit.cover, 
                height: 200, // Ajuste de altura
                width: double.infinity,  // Asegura que la imagen ocupe todo el ancho
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/placeholder.png', 
                    fit: BoxFit.cover, 
                    height: 200, 
                    width: double.infinity,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Título
            Text(
              widget.guia.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Categoría y subcategoría
            Row(
              children: [
                Chip(
                  label: Text(widget.guia.categoria),
                  backgroundColor: Colors.green.shade100,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(widget.guia.subcategoria),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Descripción
            const Text(
              'Descripción:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              widget.guia.descripcion,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            const Text(
              'Pasos:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            // Listado de pasos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.guia.pasos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Paso ${index + 1}: ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(widget.guia.pasos[index]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
