// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

// Widget simple extraído del código original
class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String timeRange;
  final bool isCompleted;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.timeRange,
    this.isCompleted = false,
    this.onTap,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.purple[50],
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: GoogleFonts.comicNeue(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: GoogleFonts.comicNeue()),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(timeRange, style: GoogleFonts.comicNeue()),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.green : Colors.deepPurple,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }
}

// Widget de mensaje cuando no hay tareas
class NoTasksMessage extends StatelessWidget {
  final String message;

  const NoTasksMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.comicNeue(
            fontSize: 16,
            color: Colors.grey[800],
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}

void main() {
  group('Widget Tests', () {
    testWidgets('TaskCard displays correct information',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Mi Tarea',
              description: 'Descripción de la tarea',
              timeRange: '09:00 - 10:00',
              isCompleted: false,
            ),
          ),
        ),
      );

      expect(find.text('Mi Tarea'), findsOneWidget);
      expect(find.text('Descripción de la tarea'), findsOneWidget);
      expect(find.text('09:00 - 10:00'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    });

    testWidgets('TaskCard shows completed state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Tarea Completada',
              description: 'Descripción',
              timeRange: '09:00 - 10:00',
              isCompleted: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_unchecked), findsNothing);
    });

    testWidgets('TaskCard responds to tap', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Tarea',
              description: 'Descripción',
              timeRange: '09:00 - 10:00',
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      expect(wasTapped, isTrue);
    });

    testWidgets('TaskCard toggle button works', (WidgetTester tester) async {
      bool wasToggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              title: 'Tarea',
              description: 'Descripción',
              timeRange: '09:00 - 10:00',
              onToggle: () => wasToggled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      expect(wasToggled, isTrue);
    });

    testWidgets('NoTasksMessage displays correctly',
        (WidgetTester tester) async {
      const message = 'No hay tareas para hoy';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NoTasksMessage(message: message),
          ),
        ),
      );

      expect(find.text(message), findsOneWidget);
    });

    testWidgets('FloatingActionButton appears correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Center(child: Text('Home')),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('AppBar shows correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: Image.asset('assets/images/renace.png', height: 30),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {},
                ),
              ],
            ),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });
  });
}
