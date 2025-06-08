import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class SimplePsychoAiScreen extends StatefulWidget {
  const SimplePsychoAiScreen({Key? key}) : super(key: key);
  @override
  State<SimplePsychoAiScreen> createState() => _SimplePsychoAiScreenState();
}

class _SimplePsychoAiScreenState extends State<SimplePsychoAiScreen> {
  final TextEditingController _questionController = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  Timer? _responseTimer;

  @override
  void initState() {
    super.initState();
    _messages.add(Message(
      text:
          "¡Hola! Soy tu asistente de bienestar mental. ¿En qué puedo ayudarte?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _responseTimer?.cancel();
    _questionController.dispose();
    super.dispose();
  }

  void _sendQuestion() {
    if (_questionController.text.isEmpty) return;

    final question = _questionController.text;
    _questionController.clear();

    setState(() {
      _messages.add(Message(text: question, isUser: true));
      _isLoading = true;
    });

    _responseTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _messages.add(Message(text: "Respuesta simulada", isUser: false));
          _isLoading = false;
        });
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(Message(
        text:
            "¡Hola! Soy tu asistente de bienestar mental. ¿En qué puedo ayudarte?",
        isUser: false,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PsychoAI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Este asistente es solo para apoyo',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Container(
                  margin: const EdgeInsets.all(8),
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Colors.purple[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(message.text),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu pregunta...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendQuestion(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendQuestion,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  group('PsychoAI Widget Tests', () {
    testWidgets('Debe mostrar elementos básicos de UI',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      expect(find.text('PsychoAI'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
      expect(find.textContaining('Este asistente es solo para apoyo'),
          findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('Debe mostrar mensaje de bienvenida',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      expect(
          find.text(
              '¡Hola! Soy tu asistente de bienestar mental. ¿En qué puedo ayudarte?'),
          findsOneWidget);
    });

    testWidgets('Debe permitir escribir texto', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      await tester.enterText(find.byType(TextField), 'Mi pregunta');
      expect(find.text('Mi pregunta'), findsOneWidget);
    });

    testWidgets('Debe enviar mensaje y mostrar carga',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Respuesta simulada'), findsOneWidget);
    });

    testWidgets('Campo debe limpiarse después de enviar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      await tester.enterText(find.byType(TextField), 'Test message');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      final TextField textField = tester.widget(find.byType(TextField));
      expect(textField.controller!.text, isEmpty);

      await tester.pump(const Duration(milliseconds: 600));
    });

    testWidgets('Debe limpiar chat correctamente', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      await tester.enterText(find.byType(TextField), 'Test');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pump(const Duration(milliseconds: 600));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Test'), findsNothing);
      expect(
          find.text(
              '¡Hola! Soy tu asistente de bienestar mental. ¿En qué puedo ayudarte?'),
          findsOneWidget);
    });

    testWidgets('No debe enviar mensaje vacío', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimplePsychoAiScreen()));

      await tester.tap(find.byIcon(Icons.send));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
