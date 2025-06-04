import 'package:flutter/material.dart';
import 'modelo_meta.dart';

class ControladorMeta {
  Future<List<ModeloMeta>> obtenerMetas() async {
    return await ModeloMeta.obtenerMetasDB();
  }

  Future<void> agregarMeta({
    required String titulo,
    required String tipo,
    required double valor,
    required String unidad,
    required DateTime inicio,
    required DateTime fin,
    required String emoji,
    required double progreso,
    required BuildContext context,
  }) async {
    if (titulo.trim().isEmpty || valor <= 0) {
      _mostrarError(context, 'Por favor ingresa valores validos');
      return;
    }

    final nuevaMeta = ModeloMeta(
      titulo: titulo,
      tipo: tipo,
      valor: valor,
      unidad: unidad,
      inicio: inicio,
      fin: fin,
      emoji: emoji,
      progreso: progreso,
    );
    

    await ModeloMeta.agregarMetaDB(nuevaMeta);
  }

  //aqui
  Future<void> actualizarMeta({
    required int index,
    required String titulo,
    required String tipo,
    required double valor,
    required String unidad,
    required DateTime inicio,
    required DateTime fin,
    required String emoji,
    required double progreso,
    required BuildContext context,
  }) async {
    if (titulo.trim().isEmpty || valor <= 0) {
      _mostrarError(context, 'Por favor ingresa valores validos');
      return;
    }

    final metaActualizada = ModeloMeta(
      titulo: titulo,
      tipo: tipo,
      valor: valor,
      unidad: unidad,
      inicio: inicio,
      fin: fin,
      emoji: emoji,
      progreso: progreso,
    );

    await ModeloMeta.actualizarDB(index, metaActualizada);
  }

  Future<void> eliminarMeta(int index) async {
    await ModeloMeta.eliminarDB(index);
  }


  Future<void> eliminarTodasLasMetas() async {
    await ModeloMeta.limpiarTodasDB();
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }
}
