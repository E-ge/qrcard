import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _tokenKey = 'fcm_token';

  Future<void> initialize() async {
    try {
      // FCM izinlerini al
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      // FCM token al ve kaydet
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveToken(token);
        print('FCM Token: $token');
      }

      // Token yenilendiğinde
      _firebaseMessaging.onTokenRefresh.listen((token) async {
        await _saveToken(token);
        print('FCM Token yenilendi: $token');
      });

      // Ön planda bildirim gösterme ayarları
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Ön planda bildirim geldiğinde
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Ön planda mesaj alındı: ${message.notification?.title}');
        _handleMessage(message);
      });

      // Arka planda bildirim tıklandığında
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Arka planda bildirim tıklandı: ${message.notification?.title}');
        _handleMessage(message);
      });

      // Uygulama kapalıyken bildirim tıklanma durumu
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print(
            'Uygulama kapalıyken bildirim tıklandı: ${initialMessage.notification?.title}');
        _handleMessage(initialMessage);
      }
    } catch (e) {
      print('Notification service initialization error: $e');
    }
  }

  void _handleMessage(RemoteMessage message) {
    try {
      // Burada bildirime tıklandığında yapılacak işlemleri ekleyebilirsiniz
      // Örneğin: Belirli bir sayfaya yönlendirme
      print('Mesaj işleniyor: ${message.notification?.title}');
      print('Mesaj data: ${message.data}');
    } catch (e) {
      print('Mesaj işleme hatası: $e');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      print('Token kaydetme hatası: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('Token alma hatası: $e');
      return null;
    }
  }
}
