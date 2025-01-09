import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/services/language_service.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';
import '../viewmodel/qr_viewmodel.dart';

class CreateQRPage extends StatefulWidget {
  const CreateQRPage({super.key});

  @override
  State<CreateQRPage> createState() => _CreateQRPageState();
}

class _CreateQRPageState extends State<CreateQRPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _qrNameController;
  late TextEditingController _titleController;
  late TextEditingController _companyController;
  late TextEditingController _addressController;
  late TextEditingController _websiteController;
  late TextEditingController _noteController;
  String? _previewData;

  @override
  void initState() {
    super.initState();
    _qrNameController = TextEditingController();
    _titleController = TextEditingController();
    _companyController = TextEditingController();
    _addressController = TextEditingController();
    _websiteController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _qrNameController.dispose();
    _titleController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _generatePreview() {
    if (_formKey.currentState!.validate()) {
      final qrViewModel = context.read<QRViewModel>();
      final profileViewModel = context.read<ProfileViewModel>();

      // Check if required profile information is filled
      if (profileViewModel.fullName.isEmpty ||
          profileViewModel.phone.isEmpty ||
          profileViewModel.email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LanguageService.translate('fill_profile_first',
                context.read<SettingsViewModel>().language)),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Check if form fields are empty
      if (_titleController.text.isEmpty &&
          _companyController.text.isEmpty &&
          _addressController.text.isEmpty &&
          _websiteController.text.isEmpty &&
          _noteController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LanguageService.translate('empty_qr_not_allowed',
                context.read<SettingsViewModel>().language)),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final data = {
        'fullName': profileViewModel.fullName,
        'title': _titleController.text,
        'company': _companyController.text,
        'phone': profileViewModel.phone,
        'email': profileViewModel.email,
        'address': _addressController.text,
        'website': _websiteController.text,
        'note': _noteController.text,
      };

      setState(() {
        _previewData = qrViewModel.generateQRData(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsViewModel = context.watch<SettingsViewModel>();
    final qrViewModel = context.watch<QRViewModel>();
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
          LanguageService.translate('create_qr', settingsViewModel.language),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_previewData != null)
            TextButton(
              onPressed: () async {
                final data = {
                  'fullName': profileViewModel.fullName,
                  'title': _titleController.text,
                  'company': _companyController.text,
                  'phone': profileViewModel.phone,
                  'email': profileViewModel.email,
                  'address': _addressController.text,
                  'website': _websiteController.text,
                  'note': _noteController.text,
                };

                await qrViewModel.createQR(
                  qrName: _qrNameController.text,
                  cardInfo: data,
                );
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(
                LanguageService.translate('save', settingsViewModel.language),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil Bilgileri Kartı
            _buildCard(
              context,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LanguageService.translate(
                            'profile_info', settingsViewModel.language),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProfileInfoRow(
                        icon: Icons.person_outline,
                        label: LanguageService.translate(
                            'full_name', settingsViewModel.language),
                        value: profileViewModel.fullName,
                      ),
                      const SizedBox(height: 12),
                      _buildProfileInfoRow(
                        icon: Icons.phone_outlined,
                        label: LanguageService.translate(
                            'phone', settingsViewModel.language),
                        value: profileViewModel.phone,
                      ),
                      const SizedBox(height: 12),
                      _buildProfileInfoRow(
                        icon: Icons.email_outlined,
                        label: LanguageService.translate(
                            'email', settingsViewModel.language),
                        value: profileViewModel.email,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // QR Kart Bilgileri Formu
            Form(
              key: _formKey,
              child: _buildCard(
                context,
                children: [
                  _buildTextField(
                    controller: _qrNameController,
                    label: LanguageService.translate(
                        'qr_name', settingsViewModel.language),
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LanguageService.translate(
                            'required_field', settingsViewModel.language);
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _titleController,
                    label: LanguageService.translate(
                        'job_title', settingsViewModel.language),
                    icon: Icons.work_outline,
                  ),
                  _buildTextField(
                    controller: _companyController,
                    label: LanguageService.translate(
                        'company', settingsViewModel.language),
                    icon: Icons.business_outlined,
                  ),
                  _buildTextField(
                    controller: _addressController,
                    label: LanguageService.translate(
                        'address', settingsViewModel.language),
                    icon: Icons.location_on_outlined,
                  ),
                  _buildTextField(
                    controller: _websiteController,
                    label: LanguageService.translate(
                        'website', settingsViewModel.language),
                    icon: Icons.language_outlined,
                  ),
                  _buildTextField(
                    controller: _noteController,
                    label: LanguageService.translate(
                        'note', settingsViewModel.language),
                    icon: Icons.note_outlined,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _generatePreview,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  LanguageService.translate(
                      'generate_preview', settingsViewModel.language),
                ),
              ),
            ),
            if (_previewData != null) ...[
              const SizedBox(height: 32),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: _previewData!,
                    version: QrVersions.auto,
                    size: 200,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        validator: validator,
      ),
    );
  }
}
