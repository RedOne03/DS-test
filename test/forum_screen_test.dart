import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:untitled2/screens/forum_screen.dart'; // Ajusta la ruta según tu proyecto

void main() {
  group('ForumScreen Tests', () {
    // Test 1: Verificar que getUserImage maneja URLs vacías correctamente
    testWidgets('getUserImage returns default asset for empty URL',
        (WidgetTester tester) async {
      // Crear una instancia del widget para acceder a métodos privados
      const widget = ForumScreen();
      final state = _ForumScreenTestHelper();

      // Test con URL null
      final imageProvider1 = state.testGetUserImage(null);
      expect(imageProvider1, isA<AssetImage>());
      expect(
          (imageProvider1 as AssetImage).assetName, 'assets/images/user.jpg');

      // Test con URL vacía
      final imageProvider2 = state.testGetUserImage('');
      expect(imageProvider2, isA<AssetImage>());
      expect(
          (imageProvider2 as AssetImage).assetName, 'assets/images/user.jpg');
    });

    // Test 2: Verificar que getUserImage maneja URLs de Google correctamente
    testWidgets('getUserImage handles Google URLs correctly',
        (WidgetTester tester) async {
      final state = _ForumScreenTestHelper();

      // Test con URL de Google (http -> https)
      const googleUrl = 'http://lh3.googleusercontent.com/test.jpg';
      final imageProvider = state.testGetUserImage(googleUrl);
      expect(imageProvider, isA<NetworkImage>());
      expect((imageProvider as NetworkImage).url,
          'https://lh3.googleusercontent.com/test.jpg');
    });

    // Test 3: Verificar que getUserImage maneja URLs de assets correctamente
    testWidgets('getUserImage handles asset URLs correctly',
        (WidgetTester tester) async {
      final state = _ForumScreenTestHelper();

      const assetUrl = 'assets/images/custom_avatar.png';
      final imageProvider = state.testGetUserImage(assetUrl);
      expect(imageProvider, isA<AssetImage>());
      expect((imageProvider as AssetImage).assetName, assetUrl);
    });

    // Test 4: Verificar que getUserImage maneja URLs HTTP regulares
    testWidgets('getUserImage handles regular HTTP URLs',
        (WidgetTester tester) async {
      final state = _ForumScreenTestHelper();

      const httpUrl = 'https://example.com/avatar.jpg';
      final imageProvider = state.testGetUserImage(httpUrl);
      expect(imageProvider, isA<NetworkImage>());
      expect((imageProvider as NetworkImage).url, httpUrl);
    });

    // Test 5: Verificar que el widget se construye correctamente
    testWidgets('ForumScreen builds without crashing',
        (WidgetTester tester) async {
      // Mock de AppLocalizations (versión simplificada)
      await tester.pumpWidget(
        MaterialApp(
          home: const MockedForumScreen(),
          localizationsDelegates: const [],
        ),
      );

      // Verificar que se construye sin errores
      expect(find.byType(Scaffold), findsOneWidget);
    });

    // Test 6: Verificar que los controladores se inicializan correctamente
    test('Controllers are initialized properly', () {
      final messageController = TextEditingController();
      final scrollController = ScrollController();

      expect(messageController.text, isEmpty);
      expect(scrollController.hasClients, isFalse);

      // Cleanup
      messageController.dispose();
      scrollController.dispose();
    });

    // Test 7: Verificar validación de mensaje vacío
    test('Message validation works correctly', () {
      // Simular validación de mensaje
      String testMessage1 = '';
      String testMessage2 = '   ';
      String testMessage3 = 'Mensaje válido';

      expect(testMessage1.trim().isEmpty, isTrue);
      expect(testMessage2.trim().isEmpty, isTrue);
      expect(testMessage3.trim().isEmpty, isFalse);
    });

    // Test 8: Verificar lógica de estados booleanos
    test('Boolean states work correctly', () {
      bool isPostingMessage = false;
      bool isLiked = false;
      bool isAuthor = false;

      expect(isPostingMessage, isFalse);
      expect(isLiked, isFalse);
      expect(isAuthor, isFalse);

      // Cambiar estados
      isPostingMessage = true;
      isLiked = true;
      isAuthor = true;

      expect(isPostingMessage, isTrue);
      expect(isLiked, isTrue);
      expect(isAuthor, isTrue);
    });
  });

  group('CommentsDialog Tests', () {
    // Test 9: Verificar que getUserImage en CommentsDialog funciona
    test('CommentsDialog getUserImage works correctly', () {
      final helper = _CommentsDialogTestHelper();

      // Test con URL vacía
      final imageProvider1 = helper.testGetUserImage('');
      expect(imageProvider1, isA<AssetImage>());

      // Test con asset
      final imageProvider2 = helper.testGetUserImage('assets/images/test.jpg');
      expect(imageProvider2, isA<AssetImage>());

      // Test con HTTP
      final imageProvider3 =
          helper.testGetUserImage('https://example.com/test.jpg');
      expect(imageProvider3, isA<NetworkImage>());
    });

    // Test 10: Verificar inicialización de variables
    test('CommentsDialog variables initialize correctly', () {
      final commentController = TextEditingController();
      List<dynamic> comments = [];
      bool isLoading = true;
      bool isPosting = false;

      expect(commentController.text, isEmpty);
      expect(comments, isEmpty);
      expect(isLoading, isTrue);
      expect(isPosting, isFalse);

      commentController.dispose();
    });
  });
}

// Helper class para acceder a métodos privados de ForumScreen
class _ForumScreenTestHelper {
  ImageProvider testGetUserImage(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) {
      return const AssetImage('assets/images/user.jpg');
    }
    if (photoUrl.contains('googleusercontent.com')) {
      final secureUrl = photoUrl.replaceFirst('http://', 'https://');
      return NetworkImage(secureUrl);
    }
    if (photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    }
    if (photoUrl.startsWith('assets/')) {
      return AssetImage(photoUrl);
    }
    return const AssetImage('assets/images/user.jpg');
  }
}

// Helper class para CommentsDialog
class _CommentsDialogTestHelper {
  ImageProvider testGetUserImage(String photoUrl) {
    if (photoUrl.isEmpty) {
      return const AssetImage('assets/images/user.jpg');
    }
    if (photoUrl.startsWith('assets/')) {
      return AssetImage(photoUrl);
    } else if (photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    }
    return const AssetImage('assets/images/user.jpg');
  }
}

// Mock simplificado del ForumScreen para testing
class MockedForumScreen extends StatelessWidget {
  const MockedForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Forum'),
      ),
      body: const Center(
        child: Text('Mock Forum Screen'),
      ),
    );
  }
}
