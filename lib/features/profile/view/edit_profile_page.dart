import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/services/language_service.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../viewmodel/profile_viewmodel.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _carModelController;
  late TextEditingController _modelYearController;
  String _selectedEmailDomain = '@hotmail.com';
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final profileViewModel = context.read<ProfileViewModel>();
    _fullNameController =
        TextEditingController(text: profileViewModel.fullName);
    _phoneController = TextEditingController(text: profileViewModel.phone);
    _emailController =
        TextEditingController(text: profileViewModel.emailUsername);
    _carModelController =
        TextEditingController(text: profileViewModel.carModel);
    _modelYearController =
        TextEditingController(text: profileViewModel.modelYear);
    _selectedEmailDomain = profileViewModel.emailDomain;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _carModelController.dispose();
    _modelYearController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      context.read<ProfileViewModel>().updateProfileImage(base64Image);
    }
  }

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
          LanguageService.translate('edit_profile', settingsViewModel.language),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await profileViewModel.updateProfile(
                  fullName: _fullNameController.text,
                  phone: _phoneController.text,
                  email: _emailController.text,
                  emailDomain: _selectedEmailDomain,
                  carModel: _carModelController.text,
                  modelYear: _modelYearController.text,
                );
                if (mounted) {
                  Navigator.pop(context);
                }
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profil Fotoğrafı
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
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
                                  base64Decode(
                                      profileViewModel.profileImageBase64!),
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
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Form Alanları
              _buildCard(
                context,
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    label: LanguageService.translate(
                        'full_name', settingsViewModel.language),
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LanguageService.translate(
                            'required_field', settingsViewModel.language);
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _phoneController,
                    label: LanguageService.translate(
                        'phone', settingsViewModel.language),
                    icon: Icons.phone_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LanguageService.translate(
                            'required_field', settingsViewModel.language);
                      }
                      return null;
                    },
                  ),
                  // E-posta Alanı
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: LanguageService.translate(
                                  'email', settingsViewModel.language),
                              prefixIcon: Container(
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.email_outlined,
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return LanguageService.translate(
                                    'required_field',
                                    settingsViewModel.language);
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedEmailDomain,
                              items: ProfileViewModel.emailDomains
                                  .map((domain) => DropdownMenuItem(
                                        value: domain,
                                        child: Text(domain),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedEmailDomain = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTextField(
                    controller: _carModelController,
                    label: LanguageService.translate(
                        'vehicle_model', settingsViewModel.language),
                    icon: Icons.directions_car_outlined,
                  ),
                  _buildTextField(
                    controller: _modelYearController,
                    label: LanguageService.translate(
                        'model_year', settingsViewModel.language),
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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
