import 'package:flutter/material.dart';
import 'model_centros.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

class ControladorCentros extends ChangeNotifier {
  List<Centro> _centros = [];
  bool _cargando = false;
  List<LatLng> _puntosRuta = [];
  bool _cargandoMapa = false;

  List<Centro> get centros => _centros;
  bool get cargando => _cargando;
  List<LatLng> get puntosRuta => _puntosRuta;
  bool get cargandoMapa => _cargandoMapa;

  ControladorCentros() {
    
    cargarCentros();
  }

  Future<void> cargarCentros() async {
    _cargando = true;
    notifyListeners();

    try {
      
      _centros = await centrosReciclaje;
    } catch (e) {
      print('Error al cargar centros: $e');
      _centros = []; // Lista vacía en caso de error
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> actualizarCentros() async {
    await cargarCentros();
  }

  Future<List<LatLng>> solicitarRuta({
    required LatLng origen,
    required LatLng destino,
  }) async {
    _cargandoMapa = true;
    notifyListeners();

    try {
      _puntosRuta = await Centro.getRuta(inicio: origen, destino: destino);
      return _puntosRuta;
    } catch (e) {
      print('Error al solicitar ruta: $e');
      return [];
    } finally {
      _cargandoMapa = false;
      notifyListeners();
    }
  }

  void limpiarRuta() {
    _puntosRuta = [];
    notifyListeners();
  }

  // Método para buscar centros por nombre o ciudad
  List<Centro> buscarCentros(String query) {
    if (query.isEmpty) return _centros;
    
    return _centros.where((centro) {
      return centro.nombre.toLowerCase().contains(query.toLowerCase()) ||
             centro.ciudad.toLowerCase().contains(query.toLowerCase()) ||
             centro.direccion.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}