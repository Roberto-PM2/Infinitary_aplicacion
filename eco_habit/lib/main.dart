import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'home_page.dart';
import 'Configurar_AlertaCU1/notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'hive_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <--- Añade esta línea

  

  // Inicializar Hive
  await Hive.initFlutter();

  // Abrir las cajas de Hive
  await Hive.openBox("ALERTAS");
  await Hive.openBox("Habitos");
  await Hive.openBox("Huella_anual");
  await Hive.openBox("habitos_diarios");
  await Hive.openBox("metas");

  await Hive.openBox("centros_reciclaje");
  await HiveService.cargarDatosInicialesDesdeJson();

  // Inicializar notificaciones
  await NotificationService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

