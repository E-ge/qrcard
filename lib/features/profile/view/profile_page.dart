import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../viewmodel/profile_viewmodel.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();
    final profileViewModel = context.watch<ProfileViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          LanguageService.translate('profile', settingsViewModel.language),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profil Fotoğrafı
            Hero(
              tag: 'profile_avatar',
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                  image: profileViewModel.profileImageBase64 != null
                      ? DecorationImage(
                          image: MemoryImage(
                            base64Decode(profileViewModel.profileImageBase64!),
                          ),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileViewModel.profileImageBase64 == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Premium Üye',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Kişisel Bilgiler
            _buildSection(
              context,
              title: LanguageService.translate(
                  'personal_info', settingsViewModel.language),
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.person_outline,
                  label: LanguageService.translate(
                      'full_name', settingsViewModel.language),
                  value: profileViewModel.fullName,
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.phone_outlined,
                  label: LanguageService.translate(
                      'phone', settingsViewModel.language),
                  value: profileViewModel.phone,
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.email_outlined,
                  label: LanguageService.translate(
                      'email', settingsViewModel.language),
                  value: profileViewModel.email,
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Araç Bilgileri
            _buildSection(
              context,
              title: LanguageService.translate(
                  'vehicle_info', settingsViewModel.language),
              children: [
                _buildInfoItem(
                  context,
                  icon: Icons.directions_car_outlined,
                  label: LanguageService.translate(
                      'vehicle_model', settingsViewModel.language),
                  value: profileViewModel.carModel,
                ),
                _buildInfoItem(
                  context,
                  icon: Icons.calendar_today_outlined,
                  label: LanguageService.translate(
                      'model_year', settingsViewModel.language),
                  value: profileViewModel.modelYear,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
