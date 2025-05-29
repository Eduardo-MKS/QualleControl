import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // Inicializar o serviço
  static Future<void> initialize() async {
    // Solicitar permissões
    await _requestPermissions();

    // Configurar notificações locais
    await _initializeLocalNotifications();

    // Configurar listeners do Firebase
    await _setupFirebaseListeners();

    // Obter e imprimir o token FCM
    await _getTokenAndPrint();

    _firebaseMessaging.subscribeToTopic('TESTE-NOTIFICACOES');
  }

  // Solicitar permissões
  static Future<void> _requestPermissions() async {
    // Permissão para notificações (Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Permissão FCM
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('Permissão FCM: ${settings.authorizationStatus}');
  }

  // Configurar notificações locais
  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('splash');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notificação tocada: ${response.payload}');
        // Aqui você pode navegar para uma tela específica
      },
    );

    // Criar canal de notificação para Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notificações Importantes',
      description: 'Canal para notificações importantes',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Configurar listeners do Firebase
  static Future<void> _setupFirebaseListeners() async {
    // Quando o app está em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em foreground: ${message.messageId}');
      _showLocalNotification(message);
    });

    // Quando o app está em background e o usuário toca na notificação
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Mensagem aberta do background: ${message.messageId}');
      _handleNotificationTap(message);
    });

    // Verificar se o app foi aberto por uma notificação
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('App aberto por notificação: ${initialMessage.messageId}');
      _handleNotificationTap(initialMessage);
    }
  }

  // Obter token FCM
  static Future<void> _getTokenAndPrint() async {
    String? token = await _firebaseMessaging.getToken();
    print('=== TOKEN FCM ===');
    print(token);
    print('================');

    // Listener para quando o token for atualizado
    _firebaseMessaging.onTokenRefresh.listen((token) {
      print('Token FCM atualizado: $token');
    });
  }

  // Mostrar notificação local quando o app está em foreground
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'high_importance_channel',
          'Notificações Importantes',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
          icon: 'splash',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Nova Notificação',
      message.notification?.body ?? 'Você tem uma nova mensagem',
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  // Lidar com toque na notificação
  static void _handleNotificationTap(RemoteMessage message) {
    print('Dados da notificação: ${message.data}');
    // Aqui você pode navegar para uma tela específica baseada nos dados
    // Exemplo: navigatorKey.currentState?.pushNamed('/specific_page');
  }

  // Obter token atual
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  // Inscrever em tópico
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    print('Inscrito no tópico: $topic');
  }

  // Desinscrever de tópico
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    print('Desinscrito do tópico: $topic');
  }
}

// Handler para mensagens em background
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensagem recebida em background: ${message.messageId}');
  print('Título: ${message.notification?.title}');
  print('Corpo: ${message.notification?.body}');
  print('Dados: ${message.data}');
}
