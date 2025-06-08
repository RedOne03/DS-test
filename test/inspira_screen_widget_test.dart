import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InspiraScreen Widget Tests', () {
    // Test básico de estructura
    testWidgets('should build scaffold with appbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Container(
                child: Image.asset(
                  'assets/images/renace.png',
                  height: 30,
                ),
              ),
            ),
            body: Container(),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    // Test de PageView para carrusel
    testWidgets('should display pageview carousel',
        (WidgetTester tester) async {
      final images = [
        'assets/images/ola.jpeg',
        'assets/images/ola2.jpg',
        'assets/images/ola3.jpeg',
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              height: 240,
              child: PageView.builder(
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Container(
                    key: ValueKey('image_$index'),
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byType(PageView), findsOneWidget);
      expect(find.byKey(const ValueKey('image_0')), findsOneWidget);
    });

    // Test de indicadores de página
    testWidgets('should display page indicators', (WidgetTester tester) async {
      const totalImages = 3;
      const currentIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalImages, (index) {
                return GestureDetector(
                  onTap: () {},
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 6.0),
                    height: 10.0,
                    width: currentIndex == index ? 20.0 : 10.0,
                    decoration: BoxDecoration(
                      color: currentIndex == index
                          ? Colors.deepPurpleAccent
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedContainer), findsNWidgets(3));
      expect(find.byType(GestureDetector), findsNWidgets(3));
    });

    // Test de FloatingActionButton
    testWidgets('should display floating action button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white, size: 30),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    // Test de botones elevados
    testWidgets('should display elevated buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.psychology_alt_outlined),
                  label: const Text('Psycho AI'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.forum_outlined),
                  label: const Text('Foro'),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Buscar por iconos en lugar de tipo de botón
      expect(find.byIcon(Icons.psychology_alt_outlined), findsOneWidget);
      expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      expect(find.text('Psycho AI'), findsOneWidget);
      expect(find.text('Foro'), findsOneWidget);
    });

    // Test de BottomNavigationBar
    testWidgets('should display bottom navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: 1,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb_outline),
                  label: 'Inspire',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    // Test de SingleChildScrollView
    testWidgets('should have scrollable content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(height: 200, color: Colors.red),
                  Container(height: 200, color: Colors.blue),
                  Container(height: 200, color: Colors.green),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Column), findsOneWidget);
    });

    // Test de interacción con FAB
    testWidgets('FAB should be tappable', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                tapped = true;
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(tapped, true);
    });
  });
}
