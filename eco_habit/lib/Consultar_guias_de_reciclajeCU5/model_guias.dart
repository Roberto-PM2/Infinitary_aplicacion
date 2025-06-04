import 'dart:convert';
import 'package:flutter/services.dart';

class Guia {
  final String id;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String subcategoria;
  final String imagenUrl;
  final List<String> pasos;

  Guia({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.subcategoria,
    required this.imagenUrl,
    required this.pasos,
  });

  factory Guia.fromMap(Map<String, dynamic> map) {
    return Guia(
      id: map['id'],
      titulo: map['titulo'] ?? '',
      descripcion: map['descripcion'] ?? '',
      categoria: map['categoria'] ?? '',
      subcategoria: map['subcategoria'] ?? '',
      imagenUrl: map['imagenUrl'] ?? '',
      pasos: List<String>.from(map['pasos'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'categoria': categoria,
      'subcategoria': subcategoria,
      'imagenUrl': imagenUrl,
      'pasos': pasos,
    };
  }
}

class GuiaRepository {
  static Future<List<Guia>> getGuias() async {
    try {
      // Cargar desde archivo JSON en assets
      final String response = await rootBundle.loadString('assets/archivos/guias.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Guia.fromMap(json)).toList();
    } catch (e) {
      print('Error cargando guías: $e');
      return []; // Retorna lista vacía en caso de error
    }
  }
}

// Carga inicial de las guías
Future<List<Guia>> guiasDisponibles = GuiaRepository.getGuias();