import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';


class HiveService {
  static Future<void> cargarDatosInicialesDesdeJson() async {
    final box = await Hive.openBox('centros_reciclaje');

    if (box.isNotEmpty) return;

    final jsonString = await rootBundle.loadString('assets/archivos/centro.json');
    final List<dynamic> centrosJson = json.decode(jsonString);

    for (int i = 0; i < centrosJson.length; i++) {
      await box.put(i, centrosJson[i]); 
    }


  }
}