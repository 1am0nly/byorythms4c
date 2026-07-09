import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:biorhythms_flutter/app.dart';

void main() {
  testWidgets('App shows onboarding on first launch', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BiorhythmsApp()));
    await tester.pumpAndSettle();
    expect(find.text('Добро пожаловать!'), findsOneWidget);
  });
}
