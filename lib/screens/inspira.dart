import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'home_screen.dart';
import 'settings.dart';
import 'user_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/database_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:ui'; // Para BackdropFilter e ImageFilter

class InspiraScreen extends StatefulWidget {
  const InspiraScreen({super.key});

  @override
  _InspiraScreenState createState() => _InspiraScreenState();
}

class _InspiraScreenState extends State<InspiraScreen> {
  final List<String> images = [
    'assets/images/ola.jpg',
    'assets/images/ola2.jpg',
    'assets/images/ola3.jpg',
  ];
  final List<String> subtitles = [
    "Efectos negativos del alcohol:",
    "Efectos negativos de las drogas:",
    "Efectos negativos de la ludopatía:"
  ];
  final List<String> descriptions = [
    "- Daña el hígado.\n- Afecta la memoria.\n- Puede causar adicción.",
    "- Afectan el sistema nervioso.\n- Pueden causar problemas mentales.\n- Alto riesgo de dependencia.",
    "- Problemas financieros.\n- Aislamiento social.\n- Riesgo de ansiedad y depresión."
  ];
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoChange();
  }

  void _startAutoChange() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentIndex = nextImageIndex(currentIndex, images.length);
      });
    });
  }

  int nextImageIndex(int currentIndex, int length) {
    return (currentIndex + 1) % length;
  }

  int previousImageIndex(int currentIndex, int length) {
    return (currentIndex - 1 + length) % length;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0),
            child: Image.asset(
              'assets/images/renace.png',
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ),
        backgroundColor: CupertinoColors.lightBackgroundGray.withOpacity(0.7),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 30, color: Colors.black),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120), // Aumentado para evitar overflow
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Carrusel de imágenes
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          images[currentIndex],
                          width: double.infinity,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: 10,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                            onPressed: () => setState(() {
                              currentIndex = previousImageIndex(currentIndex, images.length);
                            }),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 30),
                            onPressed: () => setState(() {
                              currentIndex = nextImageIndex(currentIndex, images.length);
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Detalles del carrusel
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${subtitles[currentIndex]}\n",
                          style: GoogleFonts.comicNeue(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        TextSpan(
                          text: descriptions[currentIndex],
                          style: GoogleFonts.comicNeue(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),

                const SizedBox(height: 20),

                // Frases motivacionales
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Frases Motivacionales',
                        style: GoogleFonts.comicNeue(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      _buildInspirationCard(
                        "El éxito es la suma de pequeños esfuerzos repetidos día tras día.",
                        "Robert Collier",
                        "assets/images/frase1.jpg",
                      ),
                      _buildInspirationCard(
                        "No importa lo lento que vayas, siempre y cuando no te detengas.",
                        "Confucio",
                        "assets/images/frase2.jpg",
                      ),
                      _buildInspirationCard(
                        "La disciplina es el puente entre las metas y los logros.",
                        "Jim Rohn",
                        "assets/images/frase3.jpg",
                      ),
                    ],
                  ),
                ),

                // Consejos para mantener hábitos
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Consejos para Mantener Hábitos',
                        style: GoogleFonts.comicNeue(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      const SizedBox(height: 16),
                      _buildTipCard(
                        "Establece metas pequeñas y alcanzables.",
                      ),
                      _buildTipCard(
                        "Celebra tus logros, por pequeños que sean.",
                      ),
                      _buildTipCard(
                        "Mantén un registro de tu progreso.",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: CupertinoColors.lightBackgroundGray.withOpacity(0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black54,
              currentIndex: 1,
              selectedLabelStyle: GoogleFonts.comicNeue(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: GoogleFonts.comicNeue(
                fontSize: 16,
              ),
              iconSize: 35,
              onTap: (index) {
                if (index == 0) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const HomeScreen(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                } else if (index == 2) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const UserScreen(),
                      transitionDuration: Duration.zero,
                    ),
                  );
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Inicio",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.lightbulb_outline),
                  label: "Inspirar",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: "Perfil",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInspirationCard(String quote, String author, String imagePath) {
    return Card(
      color: Colors.purple[50],
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quote,
              style: GoogleFonts.comicNeue(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "- $author",
              style: GoogleFonts.comicNeue(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(String tip) {
    return Card(
      color: Colors.purple[50],
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.lightbulb, color: Colors.black, size: 30),
        title: Text(
          tip,
          style: GoogleFonts.comicNeue(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }
}