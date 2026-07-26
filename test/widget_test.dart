import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:softverse_dash/app.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(Scaffold), findsOneWidget);

    // Flush the splash screen's navigation timer before the test tears down.
    await tester.pump(const Duration(seconds: 2));
  });
}
