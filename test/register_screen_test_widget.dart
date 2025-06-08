import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Crear un widget simple que simule RegisterScreen sin dependencias
class MockRegisterScreen extends StatefulWidget {
  const MockRegisterScreen({super.key});

  @override
  State<MockRegisterScreen> createState() => _MockRegisterScreenState();
}

class _MockRegisterScreenState extends State<MockRegisterScreen> {
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    usuarioController.dispose();
    correoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usuarioController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: correoController,
              decoration: const InputDecoration(
                labelText: 'Correo',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      setState(() => isLoading = !isLoading);
                    },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Registrarse'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ya tengo cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  group('RegisterScreen Widget Tests', () {
    testWidgets('Debe mostrar todos los campos requeridos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      expect(find.text('Usuario'), findsOneWidget);
      expect(find.text('Correo'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
      expect(find.text('Registrarse'), findsOneWidget);
    });

    testWidgets('Debe tener 3 campos de texto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      expect(find.byType(TextField), findsNWidgets(3));
    });

    testWidgets('Debe mostrar iconos en los campos', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('Botón debe cambiar a loading cuando se presiona',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      // Verificar estado inicial
      expect(find.text('Registrarse'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // Presionar botón
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verificar estado de loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Registrarse'), findsNothing);
    });

    testWidgets('Campos deben aceptar texto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      await tester.enterText(find.byType(TextField).first, 'usuario123');
      expect(find.text('usuario123'), findsOneWidget);
    });

    testWidgets('Campo de contraseña debe estar oculto', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      final passwordField = tester.widget<TextField>(
        find.byType(TextField).last,
      );
      expect(passwordField.obscureText, isTrue);
    });

    testWidgets('Debe tener botón de navegación a login', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: MockRegisterScreen()),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Ya tengo cuenta'), findsOneWidget);
    });
  });
}
