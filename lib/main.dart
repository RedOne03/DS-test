import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:untitled2/screens/login_screen.dart';
import 'package:untitled2/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  // Asegura que Flutter esté inicializado antes de usar código asíncrono
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase usando la configuración generada en firebase_options.dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Una vez inicializado Firebase, ejecuta la app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReHabits',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Aplicar Google Fonts a todo el tema de la aplicación
        textTheme: GoogleFonts.playfairDisplayTextTheme(),
        // Personalizar el tema para los elementos específicos
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.comicNeue(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedLabelStyle: GoogleFonts.comicNeue(fontSize: 12),
          unselectedLabelStyle: GoogleFonts.comicNeue(fontSize: 10),
        ),
        // Otros elementos de tema personalizados
        tabBarTheme: TabBarTheme(
          labelStyle: GoogleFonts.commissioner(fontSize: 14, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.commissioner(fontSize: 14),
        ),
        // Para diálogos y alertas
        dialogTheme: DialogTheme(
          titleTextStyle: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: GoogleFonts.playfairDisplay(fontSize: 16),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}