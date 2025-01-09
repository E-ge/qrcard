import 'package:flutter/material.dart';
import '../../../core/services/language_service.dart';

class OnboardingModel {
  final String titleKey;
  final String descriptionKey;
  final Color backgroundColor;
  final IconData icon;

  OnboardingModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.backgroundColor,
    required this.icon,
  });

  String getTitle(String language) =>
      LanguageService.translate(titleKey, language);
  String getDescription(String language) =>
      LanguageService.translate(descriptionKey, language);

  static List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      titleKey: 'welcome',
      descriptionKey: 'welcome_desc',
      backgroundColor: Colors.blue.shade100,
      icon: Icons.waving_hand,
    ),
    OnboardingModel(
      titleKey: 'create_qr_title',
      descriptionKey: 'create_qr_desc',
      backgroundColor: Colors.green.shade100,
      icon: Icons.qr_code,
    ),
    OnboardingModel(
      titleKey: 'share_title',
      descriptionKey: 'share_desc',
      backgroundColor: Colors.purple.shade100,
      icon: Icons.share,
    ),
  ];
}
