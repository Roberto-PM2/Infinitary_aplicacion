import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';
import 'controlador_centros.dart'; 
import 'package:provider/provider.dart';

class Mapa extends StatefulWidget {
  final LatLng destino; // Recibido como parámetro

  const Mapa({super.key, required this.destino});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  LatLng? currentPosition;
  bool posInicialCalculada = false;
  late final MapController _mapController;
  StreamSubscription<Position>? _positionStream;
  List<LatLng> points = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    startLocationUpdates();
  }

  // Actualiza la ubicación en tiempo real
  void startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Actualiza cada 10 metros
      ),
    ).listen((Position position) {
      final nuevaPos = LatLng(position.latitude, position.longitude);
      setState(() {
        currentPosition = nuevaPos;
        if (!posInicialCalculada) {
          //getCoordinates(nuevaPos, widget.destino);
          solicitarRuta(nuevaPos, widget.destino);
          posInicialCalculada = true;
        }
      });
      _mapController.move(nuevaPos, _mapController.camera.zoom);
    });
  }

  // Obtiene la ruta usando OpenRouteService a través del controlador
  Future<void> solicitarRuta(LatLng startPoint, LatLng endPoint) async {
    setState(() {
      isLoading = true;
    });

    try {
      final controlador = ControladorCentros(); // o usa Provider si ya está inyectado
      final puntosObtenidos = await controlador.solicitarRuta(
        origen: startPoint,
        destino: endPoint,
      );

      setState(() {
        points = puntosObtenidos;
        isLoading = false;
      });
    } catch (e) {
      print('Error al obtener la ruta: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  // Obtiene la ruta usando OpenRouteService
  Future<void> getCoordinates(LatLng startPoint, LatLng endPoint) async {
    setState(() {
      isLoading = true;
    });

    final OpenRouteService client = OpenRouteService(
      apiKey: '5b3ce3597851110001cf6248bf25cc205ba643acb41ecc3798102060', // Reemplaza por tu API key
    );

    try {
      final List<ORSCoordinate> routeCoordinates =
          await client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(
            latitude: startPoint.latitude, longitude: startPoint.longitude),
        endCoordinate: ORSCoordinate(
            latitude: endPoint.latitude, longitude: endPoint.longitude),
      );

      final List<LatLng> routePoints = routeCoordinates
          .map((coordinate) =>
              LatLng(coordinate.latitude, coordinate.longitude))
          .toList();

      setState(() {
        points = routePoints;
        isLoading = false;
      });
    } catch (e) {
      print('Error al obtener la ruta: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa centro de reciclaje', style: TextStyle(fontSize: 22)),
        backgroundColor: const Color(0xff368983),
      ),
      body: currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                content(),
                if (isLoading)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
    );
  }

  Widget content() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: currentPosition!,
        initialZoom: 15,
        interactionOptions:
            const InteractionOptions(flags: InteractiveFlag.all),
      ),
      children: [
        openStreetManTileLayer,
        MarkerLayer(
          markers: [
            Marker(
              point: currentPosition!,
              width: 60,
              height: 60,
              child: const Icon(Icons.my_location,
                  color: Colors.blue, size: 40),
            ),
            Marker(
              point: widget.destino,
              width: 60,
              height: 60,
              child: const Icon(Icons.location_on,
                  color: Colors.red, size: 40),
            ),
          ],
        ),
        if (points.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: points,
                strokeWidth: 4.0,
                color: Colors.green,
              )
            ],
          ),
      ],
    );
  }

  TileLayer get openStreetManTileLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.tuempresa.tuapp',
      );
}
