// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrcard/main.dart';

void main() {
  testWidgets('Onboarding test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(MyApp(prefs: prefs, isOnboardingComplete: false));

    expect(find.text('Hoş Geldiniz'), findsOneWidget);
    expect(find.text('Atla'), findsOneWidget);
    expect(find.text('İleri'), findsOneWidget);
  });
}
