import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled2/screens/home_screen.dart';
import 'package:untitled2/screens/register.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: correoController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Inicio de sesión exitoso',
              style: GoogleFonts.comicNeue(fontSize: 16), // Tamaño aumentado
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No se encontró usuario con ese correo.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Contraseña incorrecta.';
      } else {
        errorMessage = 'Error al iniciar sesión: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
            style: GoogleFonts.comicNeue(fontSize: 16), // Tamaño aumentado
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocurrió un error inesperado',
            style: GoogleFonts.comicNeue(fontSize: 16), // Tamaño aumentado
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Inicio de sesión con Google exitoso',
                style: GoogleFonts.comicNeue(fontSize: 16), // Tamaño aumentado
              ),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al iniciar sesión con Google: $e',
            style: GoogleFonts.comicNeue(fontSize: 16), // Tamaño aumentado
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen más visible
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40), // Espacio reducido para la imagen
                  // Imagen de logo más grande
                  Image.asset(
                    'assets/images/renace2.png',
                    height: 120, // Tamaño aumentado
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                  // Campo de correo
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: correoController,
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18, // Tamaño aumentado
                      ),
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                        labelStyle: GoogleFonts.comicNeue(
                          color: Colors.white70,
                          fontSize: 16, // Tamaño aumentado
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purpleAccent),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.white70, size: 24), // Icono agrandado
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio aumentado
                  // Campo de contraseña
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      style: GoogleFonts.comicNeue(
                        color: Colors.white,
                        fontSize: 18, // Tamaño aumentado
                      ),
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: GoogleFonts.comicNeue(
                          color: Colors.white70,
                          fontSize: 16, // Tamaño aumentado
                        ),
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.4),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purpleAccent),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white70, size: 24), // Icono agrandado
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 10), // Espacio ajustado
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Acción para recuperar contraseña
                      },
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white70,
                          fontSize: 16, // Tamaño aumentado
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio aumentado
                  // Botón de inicio de sesión
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple[900]!.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18), // Altura aumentada
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                        height: 28,
                        width: 28,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                          : Text(
                        'Iniciar Sesión',
                        style: GoogleFonts.comicNeue(
                          fontSize: 18, // Tamaño aumentado
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio aumentado
                  // Botón de Google
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: OutlinedButton(
                      onPressed: isLoading ? null : signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 17), // Altura aumentada
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0), // Espacio aumentado
                            child: Image.network(
                              'https://cdn-icons-png.freepik.com/256/1199/1199414.png',
                              height: 28, // Tamaño aumentado
                              width: 28, // Tamaño aumentado
                            ),
                          ),
                          Text(
                            'Continuar con Google',
                            style: GoogleFonts.comicNeue(
                              fontSize: 17, // Tamaño aumentado
                              fontWeight: FontWeight.w600, // Negrita
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 25), // Espacio aumentado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes cuenta?',
                        style: GoogleFonts.comicNeue(
                          color: Colors.white70,
                          fontSize: 16, // Tamaño aumentado
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: Text(
                          'Regístrate aquí',
                          style: GoogleFonts.comicNeue(
                            color: Colors.purpleAccent,
                            fontSize: 16, // Tamaño aumentado
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}