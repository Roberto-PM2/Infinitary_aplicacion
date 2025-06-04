import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Inicializar
  Future<void> initNotification() async {
    if (_isInitialized) return;


    //inicializar zona horaria
    tz.initializeTimeZones();
    final String currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));


    //init android
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint("Notificación recibida: ${response.payload}");
      },
    );

    _isInitialized = true;
  }

  // Detalles de la notificación
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id', // Corrige el typo en "channel"
        'Daily Notifications',
        channelDescription: 'Daily Notifications channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  // Mostrar notificación
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails(), // Llama a la función correctamente
    );
  }

  //notificacion programada
  //horas (0-23)
  //minutos (0-59)
  Future<void> scheduleNotification({
  int id = 1,
  required String title,
  required String body,
  required int hour,
  required int minute,
}) async {
  // Asegurar que la zona horaria esté inicializada
  if (!tz.timeZoneDatabase.isInitialized) {
    tz.initializeTimeZones();
    final String currentTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimezone));
  }

  final now = tz.TZDateTime.now(tz.local);
  var scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    minute,
  );

  // Si la hora ya pasó hoy, programar para mañana
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  try {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,

    );
    debugPrint("Notificación programada para: $scheduledDate");
  } catch (e) {
    debugPrint("Error al programar notificación: $e");
  }
}

  //cancelar las notificaciones
  Future<void> cancellNotification() async {
    await notificationsPlugin.cancelAll();
  }
  
}
