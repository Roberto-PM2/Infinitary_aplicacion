import 'package:flutter/material.dart';
import 'model_guias.dart';

class ControladorGuias extends ChangeNotifier {
  List<Guia> _guias = [];
  bool _cargando = false;
  String? _categoriaFiltro;
  String? _subcategoriaFiltro;

  List<Guia> get guias => _guias;
  bool get cargando => _cargando;
  String? get categoriaFiltro => _categoriaFiltro;
  String? get subcategoriaFiltro => _subcategoriaFiltro;

  ControladorGuias() {
    cargarGuias();
  }

  Future<void> cargarGuias() async {
    _cargando = true;
    notifyListeners();

    try {
      _guias = await guiasDisponibles;
    } catch (e) {
      print('Error al cargar guías: $e');
      _guias = []; // Lista vacía en caso de error
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> actualizarGuias() async {
    await cargarGuias();
  }

  List<Guia> get guiasFiltradas {
    if (_categoriaFiltro == null && _subcategoriaFiltro == null) {
      return _guias;
    } else if (_categoriaFiltro != null && _subcategoriaFiltro == null) {
      return _guias.where((g) => g.categoria == _categoriaFiltro).toList();
    } else if (_categoriaFiltro == null && _subcategoriaFiltro != null) {
      return _guias.where((g) => g.subcategoria == _subcategoriaFiltro).toList();
    } else {
      return _guias.where((g) => 
        g.categoria == _categoriaFiltro && 
        g.subcategoria == _subcategoriaFiltro
      ).toList();
    }
  }

  void aplicarFiltros({String? categoria, String? subcategoria}) {
    _categoriaFiltro = categoria;
    _subcategoriaFiltro = subcategoria;
    notifyListeners();
  }

  void limpiarFiltros() {
    _categoriaFiltro = null;
    _subcategoriaFiltro = null;
    notifyListeners();
  }

}