import 'package:flutter/material.dart';
import 'modelo_alerta.dart';
import 'notifications_service.dart';

class AlertasController {
  final NotificationService _notificationService = NotificationService();

  Future<List<Alerta>> obtenerAlertas() async {
    return await Alerta.getAlertas();
  }

  Future<void> agregarAlerta({
    required String texto,
    required TimeOfDay hora,
    required BuildContext context,
  }) async {
    if (texto.trim().isEmpty) {
      _mostrarError(context, 'TextoPor favor ingresa un texto para la alerta');
      return;
    }

    await _notificationService.scheduleNotification(
      title: "Tu alerta",
      body: texto,
      hour: hora.hour,
      minute: hora.minute,
    );

    final nuevaAlerta = Alerta(texto: texto, hora: hora);
    await Alerta.addAlerta(nuevaAlerta);
  }

  Future<void> editarAlerta({
    required int index,
    required String texto,
    required TimeOfDay hora,
    required BuildContext context,
  }) async {
    if (texto.trim().isEmpty) {
      _mostrarError(context, 'Por favor ingresa un texto para la alerta');
      return;
    }

    await _notificationService.cancellNotification();

    await _notificationService.scheduleNotification(
      title: "Tu alerta",
      body: texto,
      hour: hora.hour,
      minute: hora.minute,
    );

    final alertaActualizada = Alerta(texto: texto, hora: hora);
    await Alerta.update(index, alertaActualizada);
  }

  Future<void> eliminarAlerta(int index) async {
    await _notificationService.cancellNotification();
    await Alerta.delete(index);
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }
}