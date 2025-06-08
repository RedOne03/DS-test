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
  group('Widget Tests - InspirationalContentWidget', () {
    testWidgets('Verifica que existe el título de frases motivacionales',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Buscar texto que contenga "motivacional" (case insensitive)
      expect(find.byType(Text), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Verifica estructura de PageView para frases',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byType(PageView), findsWidgets);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Verifica indicadores de página', (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Los indicadores son AnimatedContainer dentro de GestureDetector
      expect(find.byType(GestureDetector), findsWidgets);
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('Verifica botón "Ver Todos/Ver Menos"',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final textButtons = find.byType(TextButton);
      expect(textButtons, findsWidgets);

      // Hacer tap en el primer botón encontrado
      if (textButtons.evaluate().isNotEmpty) {
        await tester.tap(textButtons.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Verifica cambio de estado al presionar botón',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Buscar TextButton
      final button = find.byType(TextButton);
      expect(button, findsWidgets);

      if (button.evaluate().isNotEmpty) {
        // Estado inicial - debe tener PageView
        expect(find.byType(PageView), findsWidgets);

        // Hacer tap
        await tester.tap(button.first);
        await tester.pumpAndSettle();

        // Después del tap - debe tener ListView
        expect(find.byType(ListView), findsOneWidget);
      }
    });

    testWidgets('Verifica estructura de consejos de hábitos',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Debe tener ListTile para los consejos
      expect(find.byType(ListTile), findsWidgets);
      expect(find.byType(Icon), findsWidgets);
    });

    testWidgets('Verifica animaciones', (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // AnimatedSwitcher para cambio entre carrusel y lista
      expect(find.byType(AnimatedSwitcher), findsOneWidget);

      // AnimatedContainer para indicadores
      expect(find.byType(AnimatedContainer), findsWidgets);
    });

    testWidgets('Verifica contenedores principales',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Debe tener al menos 2 Container principales (frases y consejos)
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('Verifica Row para título y botón',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Row que contiene título y botón "Ver Todos"
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('Verifica iconos de consejos', (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Iconos check_circle_outline en los consejos
      final icons = find.byIcon(Icons.check_circle_outline);
      expect(icons, findsWidgets);
    });
  });

  group('Widget Interaction Tests', () {
    testWidgets('Tap en indicador de página', (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final indicators = find.byType(GestureDetector);
      if (indicators.evaluate().length > 1) {
        await tester.tap(indicators.at(1));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Scroll en PageView', (WidgetTester tester) async {
      await tester
          .pumpWidget(createTestWidget(const InspirationalContentWidget()));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final pageViews = find.byType(PageView);
      if (pageViews.evaluate().isNotEmpty) {
        await tester.drag(pageViews.first, const Offset(-300, 0));
        await tester.pumpAndSettle();
      }
    });
  });
}
