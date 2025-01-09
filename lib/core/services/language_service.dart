class LanguageService {
  static final Map<String, Map<String, String>> _translations = {
    'Türkçe': {
      'settings': 'Ayarlar',
      'dark_mode': 'Karanlık Mod',
      'dark_mode_desc': 'Koyu tema kullan',
      'font_size': 'Yazı Boyutu',
      'notifications': 'Bildirimler',
      'notifications_desc': 'Tüm bildirimleri aç/kapa',
      'email_notifications': 'E-posta Bildirimleri',
      'email_notifications_desc': 'E-posta yoluyla bildirim al',
      'qr_scan_notifications': 'QR Tarama Bildirimleri',
      'qr_scan_notifications_desc': 'QR kodunuz tarandığında bildirim al',
      'privacy': 'Gizlilik',
      'profile_visibility': 'Profil Görünürlüğü',
      'profile_visibility_desc': 'Profilinizi herkese açık yap',
      'email_visibility': 'E-posta Görünürlüğü',
      'email_visibility_desc': 'E-posta adresinizi göster',
      'phone_visibility': 'Telefon Görünürlüğü',
      'phone_visibility_desc': 'Telefon numaranızı göster',
      'language': 'Dil',
      'about': 'Uygulama Hakkında',
      'version': 'Sürüm',
      'license': 'Lisans',
      'license_desc': 'Açık kaynak lisansları görüntüle',
      'small': 'Küçük',
      'normal': 'Normal',
      'large': 'Büyük',
      'qr_card': 'QR Kart',
      'active_qr': 'Aktif QR Kod',
      'share': 'Paylaş',
      'recent_activities': 'Son Aktiviteler',
      'qr_viewed': 'QR Kodunuz Görüntülendi',
      'minutes_ago': 'dakika önce',
      'create_qr': 'QR Oluştur',
      'profile': 'Profil',
      'premium_member': 'Premium Üye',
      'personal_info': 'Kişisel Bilgiler',
      'full_name': 'Ad Soyad',
      'age': 'Yaş',
      'phone': 'Telefon',
      'email': 'E-posta',
      'vehicle_info': 'Araç Bilgileri',
      'vehicle_model': 'Araç Modeli',
      'model_year': 'Model Yılı',
      'edit_profile': 'Profili Düzenle',
      'welcome': 'Hoş Geldiniz',
      'welcome_desc':
          'QR Card uygulamasına hoş geldiniz. Kolayca kartvizitinizi dijital ortama taşıyın.',
      'create_qr_title': 'QR Kod Oluşturun',
      'create_qr_desc': 'Bilgilerinizi girin ve özel QR kodunuzu oluşturun.',
      'share_title': 'Paylaşın',
      'share_desc': 'QR kodunuzu paylaşın ve iş bağlantılarınızı genişletin.',
      'skip': 'Atla',
      'next': 'İleri',
      'start': 'Başla',
      'save': 'Kaydet',
      'required_field': 'Bu alan gerekli',
      'invalid_email': 'Geçerli bir e-posta adresi girin',
      'qr_name': 'QR Kod Adı',
      'generate_preview': 'Önizleme Oluştur',
      'my_qr_codes': 'QR Kodlarım',
      'no_qr_codes': 'Henüz QR kodunuz yok',
      'create_first_qr': 'İlk QR Kodunu Oluştur',
      'active': 'Aktif',
      'inactive': 'Pasif',
      'view_all': 'Tümünü Gör',
      'no_active_qr': 'Aktif QR kod yok\nYeni bir QR kod oluşturun',
      'job_title': 'Ünvan',
      'company': 'Şirket',
      'address': 'Adres',
      'website': 'Web Sitesi',
      'note': 'Not',
      'invalid_phone': 'Geçerli bir telefon numarası girin',
      'profile_info': 'Profil Bilgileri',
      'profile_info_desc': 'Bu bilgiler profilinizden otomatik olarak alınır',
      'fill_profile_first':
          'QR oluşturmak için önce profil bilgilerinizi doldurun',
      'empty_qr_not_allowed':
          'Boş QR kodu oluşturulamaz. En az bir alan doldurulmalıdır',
    },
    'English': {
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'dark_mode_desc': 'Use dark theme',
      'font_size': 'Font Size',
      'notifications': 'Notifications',
      'notifications_desc': 'Enable/disable all notifications',
      'email_notifications': 'Email Notifications',
      'email_notifications_desc': 'Receive notifications via email',
      'qr_scan_notifications': 'QR Scan Notifications',
      'qr_scan_notifications_desc': 'Get notified when your QR code is scanned',
      'privacy': 'Privacy',
      'profile_visibility': 'Profile Visibility',
      'profile_visibility_desc': 'Make your profile public',
      'email_visibility': 'Email Visibility',
      'email_visibility_desc': 'Show your email address',
      'phone_visibility': 'Phone Visibility',
      'phone_visibility_desc': 'Show your phone number',
      'language': 'Language',
      'about': 'About App',
      'version': 'Version',
      'license': 'License',
      'license_desc': 'View open source licenses',
      'small': 'Small',
      'normal': 'Normal',
      'large': 'Large',
      'qr_card': 'QR Card',
      'active_qr': 'Active QR Code',
      'share': 'Share',
      'recent_activities': 'Recent Activities',
      'qr_viewed': 'Your QR Code was viewed',
      'minutes_ago': 'minutes ago',
      'create_qr': 'Create QR',
      'profile': 'Profile',
      'premium_member': 'Premium Member',
      'personal_info': 'Personal Information',
      'full_name': 'Full Name',
      'age': 'Age',
      'phone': 'Phone',
      'email': 'Email',
      'vehicle_info': 'Vehicle Information',
      'vehicle_model': 'Vehicle Model',
      'model_year': 'Model Year',
      'edit_profile': 'Edit Profile',
      'welcome': 'Welcome',
      'welcome_desc':
          'Welcome to QR Card app. Easily digitize your business card.',
      'create_qr_title': 'Create QR Code',
      'create_qr_desc':
          'Enter your information and create your custom QR code.',
      'share_title': 'Share',
      'share_desc': 'Share your QR code and expand your business connections.',
      'skip': 'Skip',
      'next': 'Next',
      'start': 'Start',
      'save': 'Save',
      'required_field': 'This field is required',
      'invalid_email': 'Please enter a valid email address',
      'qr_name': 'QR Code Name',
      'generate_preview': 'Generate Preview',
      'my_qr_codes': 'QR Kodlarım',
      'no_qr_codes': 'Henüz QR kodunuz yok',
      'create_first_qr': 'İlk QR Kodunu Oluştur',
      'active': 'Aktif',
      'inactive': 'Pasif',
      'view_all': 'Tümünü Gör',
      'no_active_qr': 'Aktif QR kod yok\nYeni bir QR kod oluşturun',
      'job_title': 'Job Title',
      'company': 'Company',
      'address': 'Address',
      'website': 'Website',
      'note': 'Note',
      'invalid_phone': 'Please enter a valid phone number',
      'profile_info': 'Profile Information',
      'profile_info_desc':
          'These details are automatically filled from your profile',
      'fill_profile_first':
          'Please fill your profile information before creating a QR code',
      'empty_qr_not_allowed':
          'Cannot create empty QR code. At least one field must be filled',
    },
  };

  static String translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }
}
