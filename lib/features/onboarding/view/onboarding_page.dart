import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/services/language_service.dart';
import '../../settings/viewmodel/settings_viewmodel.dart';
import '../model/onboarding_model.dart';
import '../viewmodel/onboarding_viewmodel.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingViewModel = context.watch<OnboardingViewModel>();
    final settingsViewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: onboardingViewModel.pageController,
              onPageChanged: onboardingViewModel.setCurrentPage,
              itemCount: OnboardingModel.onboardingPages.length,
              itemBuilder: (context, index) {
                final page = OnboardingModel.onboardingPages[index];
                return OnboardingPageView(
                  page: page,
                  language: settingsViewModel.language,
                );
              },
            ),
            Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: onboardingViewModel.pageController,
                    count: OnboardingModel.onboardingPages.length,
                    effect: WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 16,
                      activeDotColor: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (onboardingViewModel.currentPage <
                            OnboardingModel.onboardingPages.length - 1)
                          TextButton(
                            onPressed: () =>
                                onboardingViewModel.skipOnboarding(),
                            child: Text(
                              LanguageService.translate(
                                  'skip', settingsViewModel.language),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        ElevatedButton(
                          onPressed: () {
                            if (onboardingViewModel.currentPage ==
                                OnboardingModel.onboardingPages.length - 1) {
                              onboardingViewModel.completeOnboarding(context);
                            } else {
                              onboardingViewModel.nextPage();
                            }
                          },
                          child: Text(
                            onboardingViewModel.currentPage ==
                                    OnboardingModel.onboardingPages.length - 1
                                ? LanguageService.translate(
                                    'start', settingsViewModel.language)
                                : LanguageService.translate(
                                    'next', settingsViewModel.language),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPageView extends StatelessWidget {
  final OnboardingModel page;
  final String language;

  const OnboardingPageView({
    super.key,
    required this.page,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: page.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 80,
              color: page.backgroundColor.withBlue(255),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            page.getTitle(language),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.getDescription(language),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
