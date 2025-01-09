import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/language_service.dart';
import '../viewmodel/settings_viewmodel.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.grey[50]
              : Colors.grey[900],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              LanguageService.translate('settings', viewModel.language),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(
                        LanguageService.translate(
                            'dark_mode', viewModel.language),
                        context,
                      ),
                      const SizedBox(height: 8),
                      _buildCard(
                        context,
                        children: [
                          _buildSwitchTile(
                            title: LanguageService.translate(
                                'dark_mode', viewModel.language),
                            subtitle: LanguageService.translate(
                                'dark_mode_desc', viewModel.language),
                            value: viewModel.isDarkMode,
                            onChanged: (value) => viewModel.toggleDarkMode(),
                            icon: Icons.dark_mode_outlined,
                            context: context,
                          ),
                          _buildDivider(),
                          _buildExpandableTile(
                            title: LanguageService.translate(
                                'font_size', viewModel.language),
                            subtitle:
                                _getFontSizeText(viewModel.fontSize, viewModel),
                            icon: Icons.text_fields,
                            context: context,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    Slider(
                                      value: viewModel.fontSize,
                                      min: 0.8,
                                      max: 1.2,
                                      divisions: 4,
                                      label: _getFontSizeText(
                                          viewModel.fontSize, viewModel),
                                      onChanged: (value) =>
                                          viewModel.setFontSize(value),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        LanguageService.translate(
                            'notifications', viewModel.language),
                        context,
                      ),
                      const SizedBox(height: 8),
                      _buildCard(
                        context,
                        children: [
                          _buildSwitchTile(
                            title: LanguageService.translate(
                                'notifications', viewModel.language),
                            subtitle: LanguageService.translate(
                                'notifications_desc', viewModel.language),
                            value: viewModel.notificationsEnabled,
                            onChanged: (value) =>
                                viewModel.toggleNotifications(),
                            icon: Icons.notifications_outlined,
                            context: context,
                          ),
                          if (viewModel.notificationsEnabled) ...[
                            _buildDivider(),
                            _buildSwitchTile(
                              title: LanguageService.translate(
                                  'email_notifications', viewModel.language),
                              subtitle: LanguageService.translate(
                                  'email_notifications_desc',
                                  viewModel.language),
                              value: viewModel.emailNotificationsEnabled,
                              onChanged: (value) =>
                                  viewModel.toggleEmailNotifications(),
                              icon: Icons.email_outlined,
                              context: context,
                            ),
                            _buildDivider(),
                            _buildSwitchTile(
                              title: LanguageService.translate(
                                  'qr_scan_notifications', viewModel.language),
                              subtitle: LanguageService.translate(
                                  'qr_scan_notifications_desc',
                                  viewModel.language),
                              value: viewModel.qrScanNotificationsEnabled,
                              onChanged: (value) =>
                                  viewModel.toggleQrScanNotifications(),
                              icon: Icons.qr_code_scanner_outlined,
                              context: context,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        LanguageService.translate(
                            'privacy', viewModel.language),
                        context,
                      ),
                      const SizedBox(height: 8),
                      _buildCard(
                        context,
                        children: [
                          _buildSwitchTile(
                            title: LanguageService.translate(
                                'profile_visibility', viewModel.language),
                            subtitle: LanguageService.translate(
                                'profile_visibility_desc', viewModel.language),
                            value: viewModel.isProfilePublic,
                            onChanged: (value) =>
                                viewModel.toggleProfileVisibility(),
                            icon: Icons.visibility_outlined,
                            context: context,
                          ),
                          _buildDivider(),
                          _buildSwitchTile(
                            title: LanguageService.translate(
                                'email_visibility', viewModel.language),
                            subtitle: LanguageService.translate(
                                'email_visibility_desc', viewModel.language),
                            value: viewModel.showEmail,
                            onChanged: (value) =>
                                viewModel.toggleEmailVisibility(),
                            icon: Icons.alternate_email,
                            context: context,
                          ),
                          _buildDivider(),
                          _buildSwitchTile(
                            title: LanguageService.translate(
                                'phone_visibility', viewModel.language),
                            subtitle: LanguageService.translate(
                                'phone_visibility_desc', viewModel.language),
                            value: viewModel.showPhone,
                            onChanged: (value) =>
                                viewModel.togglePhoneVisibility(),
                            icon: Icons.phone_outlined,
                            context: context,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        LanguageService.translate(
                            'language', viewModel.language),
                        context,
                      ),
                      const SizedBox(height: 8),
                      _buildCard(
                        context,
                        children: [
                          _buildLanguageSelector(context, viewModel),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle(
                        LanguageService.translate('about', viewModel.language),
                        context,
                      ),
                      const SizedBox(height: 8),
                      _buildCard(
                        context,
                        children: [
                          _buildListTile(
                            title: LanguageService.translate(
                                'version', viewModel.language),
                            subtitle: '1.0.0',
                            icon: Icons.info_outline,
                            onTap: () {},
                            context: context,
                          ),
                          _buildDivider(),
                          _buildListTile(
                            title: LanguageService.translate(
                                'license', viewModel.language),
                            subtitle: LanguageService.translate(
                                'license_desc', viewModel.language),
                            icon: Icons.description_outlined,
                            onTap: () {},
                            context: context,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required BuildContext context,
  }) {
    return SwitchListTile.adaptive(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildExpandableTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
    required BuildContext context,
  }) {
    return ExpansionTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      children: children,
    );
  }

  Widget _buildLanguageSelector(
      BuildContext context, SettingsViewModel viewModel) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.language,
          color: Theme.of(context).primaryColor,
        ),
      ),
      title: Text(
        LanguageService.translate('language', viewModel.language),
      ),
      subtitle: Text(viewModel.language),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguageDialog(context, viewModel),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[200],
    );
  }

  String _getFontSizeText(double size, SettingsViewModel viewModel) {
    if (size <= 0.8) {
      return LanguageService.translate('small', viewModel.language);
    }
    if (size >= 1.2) {
      return LanguageService.translate('large', viewModel.language);
    }
    return LanguageService.translate('normal', viewModel.language);
  }

  void _showLanguageDialog(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          LanguageService.translate('language', viewModel.language),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Türkçe'),
              trailing: viewModel.language == 'Türkçe'
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                viewModel.setLanguage('Türkçe');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('English'),
              trailing: viewModel.language == 'English'
                  ? Icon(Icons.check, color: Theme.of(context).primaryColor)
                  : null,
              onTap: () {
                viewModel.setLanguage('English');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
