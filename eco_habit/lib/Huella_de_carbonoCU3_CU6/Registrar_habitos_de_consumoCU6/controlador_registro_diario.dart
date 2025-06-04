import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model_registro_diario.dart';

class ControladorRegistroDiario {
  final ModelRegistroDiario _model = ModelRegistroDiario();
  DateTime _selectedDate = DateTime.now();
  final Map<String, String> respuestas = {
    'vehiculo': 'no',
    'transporte_publico': 'no',
    'caminar_bici': 'no',
    'carne_roja': 'no',
    'plastico': 'no',
    'reciclaje': 'no',
    'compras': 'no',
    'aire_ac': 'no',
    'luces': 'no',
    'botellas': 'no',
  };

  DateTime get selectedDate => _selectedDate;

  Future<List<Map>> obtenerRegistros() async {
    return await _model.getRegistros();
  }

  Future<void> agregarRegistro(BuildContext context) async {
    final registros = await obtenerRegistros();
    final formatted = DateFormat('dd/MM/yyyy').format(_selectedDate);
    
    if (_model.existeRegistroParaFecha(registros, formatted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya existe un registro para $formatted')),
      );
    } else {
      final consumo = _model.calcularConsumo(respuestas);
      final data = {
        'fecha': formatted,
        'consumo_diario': consumo,
        ...respuestas,
      };
      await _model.agregarRegistro(data);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro guardado')),
      );
    }
  }

  Future<void> eliminarRegistro(int index) async {
    await _model.eliminarRegistro(index);
  }

  Future<void> eliminarTodosRegistros() async {
    await _model.eliminarTodosRegistros();
  }

  void actualizarRespuesta(String clave, String valor) {
    respuestas[clave] = valor;
  }

  void actualizarFecha(DateTime nuevaFecha) {
    _selectedDate = nuevaFecha;
  }

  String obtenerPregunta(String clave) {
    return _model.obtenerPregunta(clave);
  }

  List<String> get opciones => _model.opciones;
}