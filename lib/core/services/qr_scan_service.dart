import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'notification_service.dart';
import 'dart:io';

class QRScanService {
  static final QRScanService _instance = QRScanService._internal();
  factory QRScanService() => _instance;
  QRScanService._internal();

  final String _baseUrl =
      'YOUR_BACKEND_URL'; // TODO: Backend URL'nizi buraya ekleyin
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<void> reportScan({
    required String qrId,
    required String scannedData,
  }) async {
    try {
      // Cihaz bilgilerini al
      final deviceData = await _getDeviceInfo();

      // FCM token'ı al
      final fcmToken = await NotificationService().getToken();

      // Backend'e tarama bilgisini gönder
      final response = await http.post(
        Uri.parse('$_baseUrl/qr-scans'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'qrId': qrId,
          'scannedData': scannedData,
          'deviceInfo': deviceData,
          'fcmToken': fcmToken,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('QR tarama bildirimi gönderilemedi');
      }
    } catch (e) {
      print('QR tarama hatası: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return {
          'platform': 'Android',
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'deviceId': androidInfo.id,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return {
          'platform': 'iOS',
          'model': iosInfo.model,
          'systemVersion': iosInfo.systemVersion,
          'deviceId': iosInfo.identifierForVendor,
        };
      }
      return {
        'platform': 'Unknown',
        'deviceId': 'unknown',
      };
    } catch (e) {
      print('Cihaz bilgisi alınamadı: $e');
      return {
        'platform': 'Unknown',
        'deviceId': 'unknown',
      };
    }
  }
}
