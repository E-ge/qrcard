import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  final SharedPreferences _prefs;

  // Tema ayarları
  bool _isDarkMode = false;

  // Bildirim ayarları
  bool _notificationsEnabled = true;
  bool _emailNotificationsEnabled = true;
  bool _qrScanNotificationsEnabled = true;

  // Gizlilik ayarları
  bool _isProfilePublic = true;
  bool _showEmail = true;
  bool _showPhone = true;

  // Dil ayarı
  String _language = 'Türkçe';

  // Font boyutu
  double _fontSize = 1.0; // 1.0 = normal, 1.2 = büyük, 0.8 = küçük

  SettingsViewModel(this._prefs) {
    _loadSettings();
  }

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get emailNotificationsEnabled => _emailNotificationsEnabled;
  bool get qrScanNotificationsEnabled => _qrScanNotificationsEnabled;
  bool get isProfilePublic => _isProfilePublic;
  bool get showEmail => _showEmail;
  bool get showPhone => _showPhone;
  String get language => _language;
  double get fontSize => _fontSize;

  // Ayarları yükle
  void _loadSettings() {
    _isDarkMode = _prefs.getBool('settings_dark_mode') ?? false;
    _notificationsEnabled = _prefs.getBool('settings_notifications') ?? true;
    _emailNotificationsEnabled =
        _prefs.getBool('settings_email_notifications') ?? true;
    _qrScanNotificationsEnabled =
        _prefs.getBool('settings_qr_scan_notifications') ?? true;
    _isProfilePublic = _prefs.getBool('settings_profile_public') ?? true;
    _showEmail = _prefs.getBool('settings_show_email') ?? true;
    _showPhone = _prefs.getBool('settings_show_phone') ?? true;
    _language = _prefs.getString('settings_language') ?? 'Türkçe';
    _fontSize = _prefs.getDouble('settings_font_size') ?? 1.0;
    notifyListeners();
  }

  // Tema değiştir
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool('settings_dark_mode', _isDarkMode);
    notifyListeners();
  }

  // Bildirimleri aç/kapa
  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefs.setBool('settings_notifications', _notificationsEnabled);
    notifyListeners();
  }

  // E-posta bildirimlerini aç/kapa
  Future<void> toggleEmailNotifications() async {
    _emailNotificationsEnabled = !_emailNotificationsEnabled;
    await _prefs.setBool(
        'settings_email_notifications', _emailNotificationsEnabled);
    notifyListeners();
  }

  // QR tarama bildirimlerini aç/kapa
  Future<void> toggleQrScanNotifications() async {
    _qrScanNotificationsEnabled = !_qrScanNotificationsEnabled;
    await _prefs.setBool(
        'settings_qr_scan_notifications', _qrScanNotificationsEnabled);
    notifyListeners();
  }

  // Profil gizliliğini değiştir
  Future<void> toggleProfileVisibility() async {
    _isProfilePublic = !_isProfilePublic;
    await _prefs.setBool('settings_profile_public', _isProfilePublic);
    notifyListeners();
  }

  // E-posta görünürlüğünü değiştir
  Future<void> toggleEmailVisibility() async {
    _showEmail = !_showEmail;
    await _prefs.setBool('settings_show_email', _showEmail);
    notifyListeners();
  }

  // Telefon görünürlüğünü değiştir
  Future<void> togglePhoneVisibility() async {
    _showPhone = !_showPhone;
    await _prefs.setBool('settings_show_phone', _showPhone);
    notifyListeners();
  }

  // Dil değiştir
  Future<void> setLanguage(String language) async {
    _language = language;
    await _prefs.setString('settings_language', language);
    notifyListeners();
  }

  // Font boyutunu değiştir
  Future<void> setFontSize(double size) async {
    _fontSize = size;
    await _prefs.setDouble('settings_font_size', size);
    notifyListeners();
  }
}
