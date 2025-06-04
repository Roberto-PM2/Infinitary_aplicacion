import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class Alerta {
  static final _boxName = "ALERTAS";
  static final _listKey = "LISTA_ALERTAS";
  
  final String texto;
  final TimeOfDay hora;

  Alerta({required this.texto, required this.hora});

  // Convertir a Map para guardar en Hive
  Map<String, dynamic> toMap() {
    return {
      'texto': texto,
      'hora': {'hour': hora.hour, 'minute': hora.minute},
    };
  }

  // Crear desde Map al leer de Hive (con conversión segura)
  factory Alerta.fromMap(Map<dynamic, dynamic> map) {
    final horaMap = Map<String, dynamic>.from(map['hora']);
    return Alerta(
      texto: map['texto'],
      hora: TimeOfDay(hour: horaMap['hour'], minute: horaMap['minute']),
    );
  }

  // Obtener todas las alertas
  static Future<List<Alerta>> getAlertas() async {
    final box = await Hive.openBox(_boxName);
    final lista = box.get(_listKey) ?? [];
    return lista.map<Alerta>((item) => Alerta.fromMap(item)).toList();
  }

  // Guardar todas las alertas
  static Future<void> saveAll(List<Alerta> alertas) async {
    final box = await Hive.openBox(_boxName);
    final listaMap = alertas.map((alerta) => alerta.toMap()).toList();
    await box.put(_listKey, listaMap);
  }

  // Agregar una alerta
  static Future<void> addAlerta(Alerta alerta) async {
    final alertas = await getAlertas();
    alertas.add(alerta);
    await saveAll(alertas);
  }

  // Actualizar una alerta
  static Future<void> update(int index, Alerta alerta) async {
    final alertas = await getAlertas();
    if (index >= 0 && index < alertas.length) {
      alertas[index] = alerta;
      await saveAll(alertas);
    }
  }

  // Eliminar una alerta
  static Future<void> delete(int index) async {
    final alertas = await getAlertas();
    if (index >= 0 && index < alertas.length) {
      alertas.removeAt(index);
      await saveAll(alertas);
    }
  }
}