import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nota/app.dart';

void main() {
  group('NotaApp', () {
    testWidgets('shows the home screen in English', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('en')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const NotaApp());

      expect(find.text('Nothing logged yet today.'), findsOneWidget);
    });
    testWidgets('shows the home screen in French', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('fr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);

      await tester.pumpWidget(const NotaApp());

      expect(
        find.text("Rien de noté aujourd'hui pour l'instant."),
        findsOneWidget,
      );
    });
  });
}
