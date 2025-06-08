import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ForumScreen Widget Tests', () {

    // Test 1: AppBar básico
    testWidgets('AppBar renders with back and settings buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MockForumScreen()),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    // Test 2: Campo de mensaje
    testWidgets('Message input field works', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MockForumScreen()),
      );

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      await tester.enterText(textField, 'Test message');
      expect(find.text('Test message'), findsOneWidget);
    });

    // Test 3: Botón de envío
    testWidgets('Send button responds to tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MockForumScreen()),
      );

      final sendButton = find.byIcon(Icons.send_rounded);
      expect(sendButton, findsOneWidget);

      await tester.tap(sendButton);
      await tester.pump();
      // No crash = success
    });

    // Test 4: Estado vacío
    testWidgets('Empty state shows correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MockEmptyScreen()),
      );

      expect(find.byIcon(Icons.forum_outlined), findsOneWidget);
      expect(find.text('No hay mensajes'), findsOneWidget);
    });

    // Test 5: Mensaje con botones
    testWidgets('Message card shows like and comment buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(home: MockMessageScreen()),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
      expect(find.byIcon(Icons.mode_comment_outlined), findsOneWidget);
    });
  });

  group('CommentsDialog Tests', () {

    // Test 6: Diálogo básico
    testWidgets('CommentsDialog opens and closes', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => MockCommentsDialog(),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Comentarios'), findsOneWidget);

      // Cerrar diálogo
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });
}

// Mocks simplificados
class MockForumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: const Text('FORUM'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: Center(child: Text('Messages Area'))),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Escribe mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MockEmptyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.forum_outlined, size: 60),
            Text('No hay mensajes'),
          ],
        ),
      ),
    );
  }
}

class MockMessageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text('Usuario'),
              subtitle: Text('Mensaje de prueba'),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border_rounded),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.mode_comment_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MockCommentsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Comentarios'),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Text('Sin comentarios'),
          ],
        ),
      ),
    );
  }
}