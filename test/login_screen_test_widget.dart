import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Creamos un LoginScreen simplificado solo para pruebas
class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({Key? key}) : super(key: key);

  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Logo simulado
              Container(
                height: 120,
                child: const Icon(Icons.flutter_dash, size: 80),
              ),
              const SizedBox(height: 30),
              // Campo email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              // Campo contraseña
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              // Botón login
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          isLoading = true;
                        });
                      },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Iniciar Sesión'),
              ),
              const SizedBox(height: 20),
              // Botón Google
              OutlinedButton(
                onPressed: isLoading ? null : () {},
                child: const Text('Continuar con Google'),
              ),
              const SizedBox(height: 25),
              // Link registro
              TextButton(
                onPressed: () {},
                child: const Text('Regístrate aquí'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  group('LoginScreen Simple Tests', () {
    testWidgets('Debe mostrar campos básicos', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimpleLoginScreen()));

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.email), findsOneWidget);
      expect(find.byIcon(Icons.lock), findsOneWidget);
    });

    testWidgets('Debe mostrar botones', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimpleLoginScreen()));

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Continuar con Google'), findsOneWidget);
    });

    testWidgets('Debe permitir escribir texto', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimpleLoginScreen()));

      await tester.enterText(
          find.byType(TextFormField).first, 'test@example.com');
      expect(find.text('test@example.com'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).last, 'password123');
      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('Botón debe cambiar a loading al presionar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimpleLoginScreen()));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsNothing);
    });

    testWidgets('Debe tener scroll', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimpleLoginScreen()));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('Debe mostrar link de registro', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SimpleLoginScreen()));

      expect(find.text('Regístrate aquí'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
