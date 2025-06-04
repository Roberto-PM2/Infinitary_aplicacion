import 'package:flutter/material.dart';
import 'model_huella_anual.dart';

class ControladorHuellaAnual {
  final ModeloHuellaAnual modelo = ModeloHuellaAnual();

  final List<Map<String, dynamic>> preguntas = [
    {
      'id': 'km_auto',
      'text': '¿Cuántos km recorres en auto a la semana?',
      'type': 'double',
    },
    {
      'id': 'consumo_auto',
      'text': '¿Cuántos km/l consume tu auto?',
      'type': 'double',
    },
    {
      'id': 'km_transporte_publico',
      'text': '¿Cuántos km usas transporte público a la semana?',
      'type': 'double',
    },
    {
      'id': 'electricidad',
      'text': '¿Cuántos kWh consumes al mes en tu hogar?',
      'type': 'double',
    },
    {
      'id': 'gas',
      'text': '¿Cuántos m³ de gas consumes al mes?',
      'type': 'double',
    },
    {
      'id': 'agua',
      'text': '¿Cuántos litros de agua consumes al día?',
      'type': 'double',
    },
    {
      'id': 'carne',
      'text': '¿Cuántos días a la semana comes carne roja?',
      'type': 'int',
    },
    {
      'id': 'lacteos',
      'text': '¿Cuántos días a la semana consumes lácteos?',
      'type': 'int',
    },
    {
      'id': 'vegano',
      'text': '¿Sigues una dieta vegana?',
      'type': 'bool',
    },
    {
      'id': 'ropa',
      'text': '¿Cuántas prendas de ropa compras al mes?',
      'type': 'int',
    },
    {
      'id': 'electronicos',
      'text': '¿Cuántos dispositivos electrónicos compras al año?',
      'type': 'int',
    },
    {
      'id': 'viajes_avion',
      'text': '¿Cuántos vuelos de más de 3 horas haces al año?',
      'type': 'int',
    },
  ];

  int indicePreguntaActual = 0;
  bool cuestionarioIniciado = false;
  bool cuestionarioFinalizado = false;
  Map<String, String> respuestas = {};

  ControladorHuellaAnual();

  void iniciarCuestionario() {
    cuestionarioIniciado = true;
    indicePreguntaActual = 0;
    respuestas.clear();
    cuestionarioFinalizado = false;
  }

  void enviarRespuesta(String respuesta) {
    final preguntaActual = preguntas[indicePreguntaActual];
    respuestas[preguntaActual['id']] = respuesta;

    indicePreguntaActual++;
    if (indicePreguntaActual >= preguntas.length) {
      final resultado = modelo.calcularHuella(respuestas);
      modelo.guardarResultado(resultado);
      cuestionarioFinalizado = true;
    }
  }

  void reiniciarCuestionario() {
    cuestionarioIniciado = false;
    cuestionarioFinalizado = false;
    indicePreguntaActual = 0;
    respuestas.clear();
    modelo.limpiarDatos();
  }

  bool get tieneResultadoAlmacenado => modelo.huellaTotal > 0;
}
