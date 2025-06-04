import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

class Centro {
  final String id; 
  final String nombre;
  final String imagenUrl;
  final String direccion;
  final List<String> horarios;
  final String telefono;
  final double calificacion;
  final String ciudad;
  final double latitud;
  final double longitud;

  Centro({
    required this.id, 
    required this.nombre,
    required this.imagenUrl,
    required this.direccion,
    required this.horarios,
    required this.telefono,
    required this.calificacion,
    required this.ciudad,
    required this.latitud,
    required this.longitud,
  });

  factory Centro.fromMap(Map<String, dynamic> map) {
    return Centro(
      id: map['id'], 
      nombre: map['nombre'],
      imagenUrl: map['imagenUrl'],
      direccion: map['direccion'],
      horarios: List<String>.from(map['horarios']),
      telefono: map['telefono'],
      calificacion: (map['calificacion'] ?? 0).toDouble(),
      ciudad: map['ciudad'],
      latitud: (map['latitud'] ?? 0).toDouble(),
      longitud: (map['longitud'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'nombre': nombre,
      'imagenUrl': imagenUrl,
      'direccion': direccion,
      'horarios': horarios,
      'telefono': telefono,
      'calificacion': calificacion,
      'ciudad': ciudad,
      'latitud': latitud,
      'longitud': longitud,
    };
  }

  static Future<List<LatLng>> getRuta({
    required LatLng inicio,
    required LatLng destino,
  }) async {
    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248bf25cc205ba643acb41ecc3798102060',
    );

    final List<ORSCoordinate> routeCoordinates =
        await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(
          latitude: inicio.latitude, longitude: inicio.longitude),
      endCoordinate: ORSCoordinate(
          latitude: destino.latitude, longitude: destino.longitude),
    );

    return routeCoordinates
        .map((coord) => LatLng(coord.latitude, coord.longitude))
        .toList();
  }
}

class CentroRepository {
  static Future<List<Centro>> getCentros() async {
    try {
      final String response = await rootBundle.loadString('assets/archivos/centro.json');
      final List<dynamic> data = json.decode(response);
      return data.map((json) => Centro.fromMap(json)).toList();
    } catch (e) {
      print('Error cargando centros: $e');
      return [];
    }
  }
}

Future<List<Centro>> centrosReciclaje = CentroRepository.getCentros();