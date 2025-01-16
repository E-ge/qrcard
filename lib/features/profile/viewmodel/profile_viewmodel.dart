import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  final SharedPreferences _prefs;
  String _fullName = '';
  String _phone = '';
  String _email = '';
  String _emailDomain = '@hotmail.com';
  String _carModel = '';
  String _modelYear = '';
  String? _profileImageBase64;

  // Getters
  String get fullName => _fullName;
  String get phone => _phone;
  String get email => '$_email$_emailDomain';
  String get emailUsername => _email;
  String get emailDomain => _emailDomain;
  String get carModel => _carModel;
  String get modelYear => _modelYear;
  String? get profileImageBase64 => _profileImageBase64;

  // E-posta domain listesi
  static const List<String> emailDomains = [
    '@hotmail.com',
    '@gmail.com',
    '@outlook.com',
    '@yahoo.com',
    '@icloud.com',
  ];

  ProfileViewModel(this._prefs) {
    _loadProfile();
  }

  void _loadProfile() {
    _fullName = _prefs.getString('profile_full_name') ?? '';
    _phone = _prefs.getString('profile_phone') ?? '';
    _email = _prefs.getString('profile_email') ?? '';
    _emailDomain = _prefs.getString('profile_email_domain') ?? '@hotmail.com';
    _carModel = _prefs.getString('profile_car_model') ?? '';
    _modelYear = _prefs.getString('profile_model_year') ?? '';
    _profileImageBase64 = _prefs.getString('profile_image');
    notifyListeners();
  }

  Future<void> updateProfile({
    required String fullName,
    required String phone,
    required String email,
    required String emailDomain,
    required String carModel,
    required String modelYear,
  }) async {
    _fullName = fullName;
    _phone = phone;
    _email = email;
    _emailDomain = emailDomain;
    _carModel = carModel;
    _modelYear = modelYear;

    await _prefs.setString('profile_full_name', fullName);
    await _prefs.setString('profile_phone', phone);
    await _prefs.setString('profile_email', email);
    await _prefs.setString('profile_email_domain', emailDomain);
    await _prefs.setString('profile_car_model', carModel);
    await _prefs.setString('profile_model_year', modelYear);

    notifyListeners();
  }

  Future<void> updateProfileImage(String base64Image) async {
    _profileImageBase64 = base64Image;
    await _prefs.setString('profile_image', base64Image);
    notifyListeners();
  }

  Future<void> removeProfileImage() async {
    _profileImageBase64 = null;
    await _prefs.remove('profile_image');
    notifyListeners();
  }
}
