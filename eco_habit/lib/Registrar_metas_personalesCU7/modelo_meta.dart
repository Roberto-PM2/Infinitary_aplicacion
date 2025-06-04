import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class ModeloMeta {
  static const String _nombreCaja = 'metas';
  static const String _claveLista = 'LISTA_METAS';

  final String titulo;
  final String tipo;
  final double valor;
  final String unidad;
  final DateTime inicio;
  final DateTime fin;
  final String emoji;
  double progreso;

  ModeloMeta({
    required this.titulo,
    required this.tipo,
    required this.valor,
    required this.unidad,
    required this.inicio,
    required this.fin,
    required this.emoji,
    this.progreso = 0,
  });

  // === Conversión Mapa para Hive ===

  Map<String, dynamic> aMapa() {
    return {
      'titulo': titulo,
      'tipo': tipo,
      'valor': valor,
      'unidad': unidad,
      'inicio': inicio.toIso8601String(),
      'fin': fin.toIso8601String(),
      'emoji': emoji,
      'progreso': progreso,
    };
  }

  factory ModeloMeta.desdeMapa(Map<dynamic, dynamic> mapa) {
    return ModeloMeta(
      titulo: mapa['titulo'],
      tipo: mapa['tipo'],
      valor: mapa['valor'],
      unidad: mapa['unidad'],
      inicio: DateTime.parse(mapa['inicio']),
      fin: DateTime.parse(mapa['fin']),
      emoji: mapa['emoji'],
      progreso: mapa['progreso'] ?? 0,
    );
  }

  // === Funciones de almacenamiento ===

  static Future<List<ModeloMeta>> obtenerMetasDB() async {
    final caja = await Hive.openBox(_nombreCaja);
    final lista = caja.get(_claveLista) ?? [];
    print('Metas obtenidas de Hive: $lista');
    return lista.map<ModeloMeta>((item) => ModeloMeta.desdeMapa(item)).toList();
  }

  static Future<void> guardarTodas(List<ModeloMeta> metas) async {
    final caja = await Hive.openBox(_nombreCaja);
    final listaMapas = metas.map((meta) => meta.aMapa()).toList();
    await caja.put(_claveLista, listaMapas);
  }

  static Future<void> agregarMetaDB(ModeloMeta meta) async {
    final metas = await obtenerMetasDB();
    metas.add(meta);
    await guardarTodas(metas);
  }

  static Future<void> actualizarDB(int indice, ModeloMeta meta) async {
    final metas = await obtenerMetasDB();
    if (indice >= 0 && indice < metas.length) {
      metas[indice] = meta;
      await guardarTodas(metas);
    }
  }

  static Future<void> eliminarDB(int indice) async {
    final metas = await obtenerMetasDB();
    if (indice >= 0 && indice < metas.length) {
      metas.removeAt(indice);
      await guardarTodas(metas);
    }
  }

  static Future<void> limpiarTodasDB() async {
    final caja = await Hive.openBox(_nombreCaja);
    await caja.delete(_claveLista);
  }


  // === Utilidades ===

  static final Map<String, List<String>> unidadesPorTipo = {
    'Ahorrar agua': ['litros'],
    'Ahorrar luz': ['kWh', 'horas'],
    'Reciclaje': ['kg', 'piezas'],
    'Reducir residuos': ['kg'],
  };

  static List<String> obtenerUnidadesPorTipo(String tipo) {
    return unidadesPorTipo[tipo] ?? [];
  }

  static final Map<String, String> sugerenciasEmoji = {
    'recicla': '♻️',
    'reciclaje': '♻️',
    'agua': '💧',
    'luz': '💡',
    'dormir': '😴',
    'caminar': '🚶',
    'leer': '📚',
    'plantar': '🌱',
  };

  static String obtenerEmojiSugerido(String texto) {
    final textoMinusculas = texto.toLowerCase();
    for (final entrada in sugerenciasEmoji.entries) {
      if (textoMinusculas.contains(entrada.key)) {
        return entrada.value;
      }
    }
    return '✨';
  }

  static final List<String> opcionesEmoji = [
    '♻️', '💧', '💡', '😴', '📚', '🏃', '🍎', '🧘', '🚴', '☀️',
    '🎯', '📅', '✅', '🎓', '🛌', '🧹', '🧼', '🪴', '🌍', '❤️',
  ];
}