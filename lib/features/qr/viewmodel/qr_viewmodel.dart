import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRCode {
  final String id;
  final String name;
  final String data;
  final Map<String, String> cardInfo;
  bool isActive;
  final DateTime createdAt;

  QRCode({
    required this.id,
    required this.name,
    required this.data,
    required this.cardInfo,
    required this.isActive,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data': data,
      'cardInfo': cardInfo,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory QRCode.fromJson(Map<String, dynamic> json) {
    return QRCode(
      id: json['id'],
      name: json['name'],
      data: json['data'],
      cardInfo: Map<String, String>.from(json['cardInfo']),
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class QRViewModel extends ChangeNotifier {
  final SharedPreferences _prefs;
  List<QRCode> _qrCodes = [];

  // Getters
  List<QRCode> get qrCodes => _qrCodes;
  List<QRCode> get activeQRCodes =>
      _qrCodes.where((qr) => qr.isActive).toList();

  QRViewModel(this._prefs) {
    _loadQRCodes();
  }

  void _loadQRCodes() {
    final qrCodesJson = _prefs.getStringList('qr_codes') ?? [];
    _qrCodes = qrCodesJson
        .map((json) => QRCode.fromJson(jsonDecode(json)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> _saveQRCodes() async {
    final qrCodesJson = _qrCodes.map((qr) => jsonEncode(qr.toJson())).toList();
    await _prefs.setStringList('qr_codes', qrCodesJson);
    notifyListeners();
  }

  Future<void> createQR({
    required String qrName,
    required Map<String, String> cardInfo,
  }) async {
    final qrData = generateQRData(cardInfo);
    final newQR = QRCode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: qrName,
      data: qrData,
      cardInfo: cardInfo,
      isActive: true,
      createdAt: DateTime.now(),
    );

    // Yeni QR kodu eklendiğinde diğer tüm QR kodları pasif yap
    for (var qr in _qrCodes) {
      qr.isActive = false;
    }

    _qrCodes.add(newQR);
    await _saveQRCodes();
  }

  Future<void> toggleQRStatus(String qrId) async {
    final qrIndex = _qrCodes.indexWhere((qr) => qr.id == qrId);
    if (qrIndex != -1) {
      // Eğer QR kodu aktif yapılıyorsa, diğerlerini pasif yap
      if (!_qrCodes[qrIndex].isActive) {
        for (var qr in _qrCodes) {
          qr.isActive = false;
        }
      }
      _qrCodes[qrIndex].isActive = !_qrCodes[qrIndex].isActive;
      await _saveQRCodes();
    }
  }

  Future<void> deleteQR(String qrId) async {
    _qrCodes.removeWhere((qr) => qr.id == qrId);
    await _saveQRCodes();
  }

  String generateQRData(Map<String, String> data) {
    final vCard = '''BEGIN:VCARD
VERSION:3.0
FN:${data['fullName']}
TEL:${data['phone']}
EMAIL:${data['email']}
TITLE:${data['title']}
ORG:${data['company']}
ADR:${data['address']}
URL:${data['website']}
NOTE:${data['note']}
END:VCARD''';

    return vCard;
  }
}
