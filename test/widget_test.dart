import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifeloop/main.dart';

void main() {
  testWidgets('LifeLoop app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: LifeLoopApp()));

    // Verify that onboarding screen loads.
    expect(find.text('LifeLoop'), findsOneWidget);
    expect(find.text('Your Life, Connected'), findsOneWidget);
  });
}
