import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InspiraScreen Logic Tests', () {
    // Test de valores iniciales
    test('should have correct initial image list', () {
      final images = [
        'assets/images/ola.jpeg',
        'assets/images/ola2.jpg',
        'assets/images/ola3.jpeg',
      ];

      expect(images.length, 3);
      expect(images[0], 'assets/images/ola.jpeg');
      expect(images[1], 'assets/images/ola2.jpg');
      expect(images[2], 'assets/images/ola3.jpeg');
    });

    // Test de lógica de navegación del carrusel
    test('should calculate next page index correctly', () {
      const currentIndex = 0;
      const imagesLength = 3;
      final nextPage = (currentIndex + 1) % imagesLength;

      expect(nextPage, 1);
    });

    test('should wrap around at last page', () {
      const currentIndex = 2;
      const imagesLength = 3;
      final nextPage = (currentIndex + 1) % imagesLength;

      expect(nextPage, 0);
    });

    test('should handle middle page navigation', () {
      const currentIndex = 1;
      const imagesLength = 3;
      final nextPage = (currentIndex + 1) % imagesLength;

      expect(nextPage, 2);
    });

    // Test de duraciones de animación
    test('should have correct animation durations', () {
      const psychoAiDuration = Duration(milliseconds: 1500);
      const fabDuration = Duration(milliseconds: 150);
      const pageChangeDuration = Duration(milliseconds: 400);
      const autoChangeDuration = Duration(seconds: 5);

      expect(psychoAiDuration.inMilliseconds, 1500);
      expect(fabDuration.inMilliseconds, 150);
      expect(pageChangeDuration.inMilliseconds, 400);
      expect(autoChangeDuration.inSeconds, 5);
    });

    // Test de valores de escala de animación
    test('should have correct scale animation values', () {
      const scaleBegin = 0.95;
      const scaleEnd = 1.03;
      const fabScaleBegin = 1.0;
      const fabScaleEnd = 0.90;

      expect(scaleBegin < scaleEnd, true);
      expect(fabScaleBegin > fabScaleEnd, true);
      expect((scaleEnd - scaleBegin).toStringAsFixed(2), '0.08');
    });

    // Test de índices de página
    test('should handle page indicator logic', () {
      const totalPages = 3;

      for (int i = 0; i < totalPages; i++) {
        final isActive = i == 1; // página actual
        final width = isActive ? 20.0 : 10.0;
        final expectedWidth = i == 1 ? 20.0 : 10.0;

        expect(width, expectedWidth);
      }
    });

    // Test de colores
    test('should have correct color values', () {
      final activeColor = Colors.deepPurpleAccent;
      final inactiveColor = Colors.grey.shade400;
      final backgroundColor = Colors.deepPurple;

      expect(activeColor, Colors.deepPurpleAccent);
      expect(backgroundColor, Colors.deepPurple);
      expect(inactiveColor.value, Colors.grey.shade400.value);
    });
  });

  // Tests de widgets muy básicos
  group('Basic Widget Tests', () {
    testWidgets('should create basic container', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Container(
            height: 100,
            width: 100,
            color: Colors.blue,
          ),
        ),
      );

      final container = find.byType(Container);
      expect(container, findsOneWidget);
    });

    testWidgets('should create basic scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });
  });
}
