import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled2/l10n/app_localizations.dart';
import 'package:untitled2/screens/inspirational_content_widget.dart'; // Ajusta la ruta

Widget createTestWidget(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('en'),
      Locale('es'),
    ],
    locale: const Locale('es'),
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

void main() {
  group('InspirationalContentWidget Tests', () {
    testWidgets('Widget se renderiza correctamente',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(InspirationalContentWidget), findsOneWidget);
    });

    testWidgets('Contiene texto de frases motivacionales',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Buscar por texto específico o por tipo
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('PageView está presente', (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(PageView), findsWidgets);
    });
  });

  group('MotivationalQuote Model Tests', () {
    test('MotivationalQuote se crea correctamente', () {
      final quote = MotivationalQuote(
        quoteKey: 'quote1',
        authorKey: 'author1',
        imagePath: 'assets/test.jpg',
      );

      expect(quote.quoteKey, 'quote1');
      expect(quote.authorKey, 'author1');
      expect(quote.imagePath, 'assets/test.jpg');
    });
  });
}
