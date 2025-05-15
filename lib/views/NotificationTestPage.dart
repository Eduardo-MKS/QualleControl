// ignore: file_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer? _notificationTimer;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Solicita permissão explicitamente (para Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _startNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _counter++;
      _showNotification('Notificação de teste $_counter');
    });
    print('Notificação iniciada');
  }

  void _stopNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'channel_id_test', // Altere aqui
          'Canal de Teste',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Alerta de Teste',
      message,
      platformChannelSpecifics,
    );
    print('Notificação mostrada: $message');
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
    print('Notificação parada');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulador de Notificações')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startNotifications,
              child: const Text('Iniciar notificações'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _stopNotifications,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Parar notificações'),
            ),
          ],
        ),
      ),
    );
  }
}
