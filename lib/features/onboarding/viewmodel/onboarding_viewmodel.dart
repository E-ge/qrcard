import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/onboarding_model.dart';
import '../../home/view/home_page.dart';

class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  final SharedPreferences _prefs;
  int _currentPage = 0;
  static const String onboardingCompleteKey = 'onboarding_complete';

  OnboardingViewModel(this._prefs);

  int get currentPage => _currentPage;

  List<OnboardingModel> get pages => OnboardingModel.onboardingPages;

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> completeOnboarding(BuildContext context) async {
    await _prefs.setBool(onboardingCompleteKey, true);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<bool> isOnboardingComplete() async {
    return _prefs.getBool(onboardingCompleteKey) ?? false;
  }

  void nextPage() {
    if (_currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
