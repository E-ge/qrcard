import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/view/onboarding_page.dart';
import 'features/onboarding/viewmodel/onboarding_viewmodel.dart';
import 'features/home/view/home_page.dart';
import 'features/profile/viewmodel/profile_viewmodel.dart';
import 'features/settings/viewmodel/settings_viewmodel.dart';
import 'features/qr/viewmodel/qr_viewmodel.dart';
import 'core/services/notification_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase'i başlat
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey:
                'AIzaSyD2xwutq3V75GbX0bpjvU8eRlEM6EAAABI', // google-services.json'dan alın
            appId:
                '1:402652164142:android:5e8c96d7df5dab79352fbf', // google-services.json'dan alın
            messagingSenderId: '402652164142', // google-services.json'dan alın
            projectId: 'qrcard-a84a3', // google-services.json'dan alın
            storageBucket:
                'qrcard-a84a3.firebasestorage.app' // google-services.json'dan alın
            ),
      );
    }

    // Bildirimleri başlat
    await NotificationService().initialize();

    // SharedPreferences'ı başlat
    final prefs = await SharedPreferences.getInstance();
    final bool isOnboardingComplete =
        prefs.getBool('onboarding_complete') ?? false;

    runApp(MyApp(prefs: prefs, isOnboardingComplete: isOnboardingComplete));
  } catch (e) {
    print('Initialization error: $e');
    // Temel uygulamayı hata mesajıyla başlat
    runApp(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
              'Uygulama başlatılırken bir hata oluştu. Lütfen tekrar deneyin.'),
        ),
      ),
    ));
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool isOnboardingComplete;

  const MyApp(
      {super.key, required this.prefs, required this.isOnboardingComplete});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => ProfileViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => SettingsViewModel(prefs)),
        ChangeNotifierProvider(create: (_) => QRViewModel(prefs)),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'QR Card',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              brightness: Brightness.light,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blue,
                brightness: Brightness.dark,
              ),
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(settings.fontSize),
                ),
                child: child!,
              );
            },
            home: ErrorBoundary(
              child: isOnboardingComplete
                  ? const HomePage()
                  : const OnboardingPage(),
            ),
          );
        },
      ),
    );
  }
}

class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          try {
            return child;
          } catch (e) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Bir hata oluştu',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => child),
                          );
                        },
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
