import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class ModelRegistroDiario {
  static const String boxName = 'habitos_diarios';
  
  final Map<String, double> valoresCO2 = {
    'vehiculo': 0.010,
    'transporte_publico': 0.004,
    'caminar_bici': 0.0,
    'carne_roja': 0.008,
    'plastico': 0.003,
    'reciclaje': -0.003,
    'compras': 0.010,
    'aire_ac': 0.007,
    'luces': 0.002,
    'botellas': 0.0015,
  };

  final List<String> opciones = ['si', 'no'];
  
  Future<List<Map>> getRegistros() async {
    final box = await Hive.openBox(boxName);
    return box.values.toList().cast<Map>();
  }

  Future<void> agregarRegistro(Map data) async {
    final box = await Hive.openBox(boxName);
    await box.add(data);
  }

  Future<void> eliminarRegistro(int index) async {
    final box = await Hive.openBox(boxName);
    await box.deleteAt(index);
  }

  Future<void> eliminarTodosRegistros() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  bool existeRegistroParaFecha(List<Map> registros, String fecha) {
    return registros.any((r) => r['fecha'] == fecha);
  }

  double calcularConsumo(Map<String, String> respuestas) {
    double total = 0.0;
    respuestas.forEach((clave, valor) {
      if (valor == 'si') {
        total += valoresCO2[clave] ?? 0.0;
      }
    });
    return total;
  }

  String obtenerPregunta(String clave) {
    switch (clave) {
      case 'vehiculo': return '¿Usaste vehículo motorizado?';
      case 'transporte_publico': return '¿Tomaste transporte público?';
      case 'caminar_bici': return '¿Caminaste o usaste bici?';
      case 'carne_roja': return '¿Consumiste carne roja?';
      case 'plastico': return '¿Consumiste productos envasados en plástico?';
      case 'reciclaje': return '¿Reciclaste hoy?';
      case 'compras': return '¿Compraste artículos nuevos?';
      case 'aire_ac': return '¿Usaste aire acondicionado/calefacción?';
      case 'luces': return '¿Dejaste luces encendidas innecesariamente?';
      case 'botellas': return '¿Consumiste agua embotellada/bebidas desechables?';
      default: return clave;
    }
  }
}