import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Servicio de idioma simplificado
class TestLanguageService extends ChangeNotifier {
  Locale _currentLocale = const Locale('en', 'US');

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;

  void changeLanguage(Locale newLocale) {
    _currentLocale = newLocale;
    notifyListeners();
  }
}

// Selector de idiomas para pruebas
class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  bool isExpanded = false;

  final List<Map<String, String>> languages = [
    {'code': 'en', 'name': '🇺🇸 English'},
    {'code': 'es', 'name': '🇪🇸 Español'},
    {'code': 'fr', 'name': '🇫🇷 Français'},
    {'code': 'ru', 'name': '🇷🇺 Русский'},
    {'code': 'zh', 'name': '🇨🇳 中文'},
    {'code': 'qu', 'name': '🇵🇪 Quechua'},
    {'code': 'ja', 'name': '🇯🇵 日本語'},
    {'code': 'pt', 'name': '🇧🇷 Português'},
  ];

  @override
  Widget build(BuildContext context) {
    final languageService = Provider.of<TestLanguageService>(context);

    return Column(
      children: [
        ListTile(
          title: const Text('Language'),
          subtitle: Text('Current: ${languageService.currentLanguageCode}'),
          trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
          onTap: () => setState(() => isExpanded = !isExpanded),
        ),
        if (isExpanded)
          ...languages.map((lang) => ListTile(
                title: Text(lang['name']!),
                onTap: () {
                  languageService.changeLanguage(Locale(lang['code']!));
                  setState(() => isExpanded = false);
                },
              )),
      ],
    );
  }
}

// Widget wrapper para las pruebas
Widget createTestWidget(Widget child) {
  return ChangeNotifierProvider<TestLanguageService>(
    create: (_) => TestLanguageService(),
    child: MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('es', 'ES'),
        Locale('fr'),
        Locale('ru'),
        Locale('zh'),
        Locale('qu'),
        Locale('ja', 'JP'),
        Locale('pt', 'BR'),
      ],
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Language Selector Tests', () {
    testWidgets(
        'should display current language and expand options when tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LanguageSelector()));
      await tester.pumpAndSettle();

      // Verificar estado inicial
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Current: en'), findsOneWidget);
      expect(find.text('🇺🇸 English'), findsNothing);

      // Expandir opciones
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      // Verificar opciones expandidas (solo algunas para no hacer el test muy largo)
      expect(find.text('🇺🇸 English'), findsOneWidget);
      expect(find.text('🇪🇸 Español'), findsOneWidget);
      expect(find.text('🇯🇵 日本語'), findsOneWidget);
      expect(find.text('🇧🇷 Português'), findsOneWidget);
    });

    testWidgets('should change language when option is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LanguageSelector()));
      await tester.pumpAndSettle();

      // Expandir y seleccionar español
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🇪🇸 Español'));
      await tester.pumpAndSettle();

      // Verificar cambio de idioma
      expect(find.text('Current: es'), findsOneWidget);
      expect(find.text('🇪🇸 Español'),
          findsNothing); // Se colapsa después de seleccionar
    });

    testWidgets('should collapse when language is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const LanguageSelector()));
      await tester.pumpAndSettle();

      // Abrir selector
      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      expect(find.text('🇷🇺 Русский'), findsOneWidget);

      // Seleccionar idioma
      await tester.tap(find.text('🇷🇺 Русский'));
      await tester.pumpAndSettle();

      // Verificar que se colapsa
      expect(find.text('🇷🇺 Русский'), findsNothing);
      expect(find.text('Current: ru'), findsOneWidget);
    });
  });

  group('Language Service Tests', () {
    test('should change language correctly', () {
      final service = TestLanguageService();

      expect(service.currentLanguageCode, equals('en'));

      service.changeLanguage(const Locale('es'));
      expect(service.currentLanguageCode, equals('es'));

      service.changeLanguage(const Locale('qu'));
      expect(service.currentLanguageCode, equals('qu'));
    });
  });
}
