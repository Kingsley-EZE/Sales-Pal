import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


Future<void> settleThroughDatabase(WidgetTester tester) async {
  await tester.runAsync(() async {
    for (var attempt = 0; attempt < 50; attempt++) {
      await tester.pump();

      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) return;

      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  });

  await tester.pumpAndSettle();
}

Future<void> tapThroughDatabase(WidgetTester tester, String label) async {
  await tester.runAsync(() async {
    await tester.tap(find.text(label));
    await tester.pump();
    await Future<void>.delayed(const Duration(milliseconds: 100));
  });

  await settleThroughDatabase(tester);
}
