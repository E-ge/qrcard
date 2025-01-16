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
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      // FCM token al ve kaydet
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveToken(token);
        print('=================== FCM TOKEN ===================');
        print(token);
        print('===============================================');
      }

      // Token yenilendiğinde
      _firebaseMessaging.onTokenRefresh.listen((token) async {
        await _saveToken(token);
        print('=================== YENİ FCM TOKEN ===================');
        print(token);
        print('===================================================');
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
        print('Ön planda mesaj alındı:');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
        _handleMessage(message);
      });

      // Arka planda bildirim tıklandığında
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Arka planda bildirim tıklandı:');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
        _handleMessage(message);
      });

      // Uygulama kapalıyken bildirim tıklanma durumu
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        print('Uygulama kapalıyken bildirim tıklandı:');
        print('Title: ${initialMessage.notification?.title}');
        print('Body: ${initialMessage.notification?.body}');
        print('Data: ${initialMessage.data}');
        _handleMessage(initialMessage);
      }
    } catch (e) {
      print('Notification service initialization error: $e');
    }
  }

  void _handleMessage(RemoteMessage message) {
    try {
      print('Mesaj işleniyor:');
      print('Title: ${message.notification?.title}');
      print('Body: ${message.notification?.body}');
      print('Data: ${message.data}');

      // Bildirim tipine göre işlem yapabilirsiniz
      if (message.data['type'] == 'qr_scan') {
        print('QR tarama bildirimi: ${message.data['id']}');
        // TODO: QR tarama sayfasına yönlendirme yapılabilir
      }
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

  // Token'ı yazdırmak için yardımcı metod
  Future<void> printCurrentToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      print('=================== CURRENT FCM TOKEN ===================');
      print(token ?? 'Token bulunamadı');
      print('======================================================');
    } catch (e) {
      print('Token yazdırma hatası: $e');
    }
  }
}
