import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_mks_app/service/firebase_messaging_service.dart';

class NotificationTestPage extends StatefulWidget {
  const NotificationTestPage({super.key});

  @override
  State<NotificationTestPage> createState() => _NotificationTestPageState();
}

class _NotificationTestPageState extends State<NotificationTestPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Timer? _notificationTimer;
  int _counter = 0;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _loadFCMToken();
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

  void _loadFCMToken() async {
    String? token = await FirebaseMessagingService.getToken();
    setState(() {
      _fcmToken = token;
    });
    print('FCM Token: $_fcmToken');
  }

  void _startNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _counter++;
      _showNotification('Notificação de teste $_counter');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notificações locais iniciadas!')),
    );
  }

  void _stopNotifications() {
    _notificationTimer?.cancel();
    _notificationTimer = null;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notificações locais paradas!')),
    );
  }

  Future<void> _showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'channel_id_test',
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
  }

  void _copyTokenToClipboard() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Token copiado para a área de transferência!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste de Notificações'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Seção de notificações locais
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notificações Locais',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _startNotifications,
                            child: const Text('Iniciar'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _stopNotifications,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Parar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Seção do Firebase Cloud Messaging
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Firebase Cloud Messaging',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Token FCM
                    const Text(
                      'Token FCM:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _fcmToken ?? 'Carregando...',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                          IconButton(
                            onPressed:
                                _fcmToken != null
                                    ? _copyTokenToClipboard
                                    : null,
                            icon: const Icon(Icons.copy),
                            tooltip: 'Copiar token',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botões de tópicos
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instruções
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Como testar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('1. Copie o token FCM acima'),
                    const Text('2. Vá para Firebase Console > Messaging'),
                    const Text('3. Crie uma nova mensagem'),
                    const Text('4. Cole o token no campo "Token FCM"'),
                    const Text('5. Envie a mensagem'),
                    const SizedBox(height: 8),
                    const Text(
                      'Ou use tópicos:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('1. Inscreva-se no tópico "teste"'),
                    const Text(
                      '2. No Firebase Console, envie para o tópico "teste"',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
