import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';
import 'settings.dart';
import 'inspira.dart';
import '/widgets/database_helper.dart';
import 'dart:ui'; // Para BackdropFilter e ImageFilter

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  User? currentUser;
  final String reminderTime = '08:00 AM';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Verificar si existe el documento del usuario en Firestore
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists) {
          // Usuario existe en Firestore (registro normal)
          setState(() {
            userData = userDoc.data();
            isLoading = false;
          });
        } else {
          // Usuario no existe en Firestore (probablemente login con Google)
          await _createUserDocumentForGoogleUser();
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createUserDocumentForGoogleUser() async {
    try {
      if (currentUser == null) return;

      // Crear un nuevo documento para el usuario de Google
      final userData = {
        'uid': currentUser!.uid,
        'correo': currentUser!.email,
        'usuario': currentUser!.displayName ?? currentUser!.email!.split('@')[0],
        'fechaRegistro': FieldValue.serverTimestamp(),
        'ultimoAcceso': FieldValue.serverTimestamp(),
        'provider': 'google', // Identificar que viene de Google
        'photoURL': currentUser!.photoURL,
        'metaPersonal': 'Vivir una vida más saludable', // Datos por defecto de la versión anterior
        'fechaNacimiento': '15 de Octubre, 2003', // Datos por defecto de la versión anterior
        'diasProgreso': 150, // Datos por defecto de la versión anterior
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .set(userData);

      // Volver a cargar los datos
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      setState(() {
        this.userData = userDoc.data();
        isLoading = false;
      });
    } catch (e) {
      print('Error creating user document: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getUserName() {
    if (userData != null && userData!['usuario'] != null) {
      return userData!['usuario'];
    } else if (currentUser?.displayName != null) {
      return currentUser!.displayName!;
    } else if (currentUser?.email != null) {
      return currentUser!.email!.split('@')[0];
    }
    return 'Usuario no identificado';
  }

  String? _getUserPhotoUrl() {
    if (userData != null && userData!['photoURL'] != null) {
      return userData!['photoURL'];
    }
    return currentUser?.photoURL;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    final veryLightPurple = Colors.purple[50];
    final lightPurple = Colors.purple[100];

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Información del perfil
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
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _getUserPhotoUrl() != null
                            ? NetworkImage(_getUserPhotoUrl()!)
                            : const AssetImage('assets/images/user.jpg') as ImageProvider,
                        backgroundColor: veryLightPurple,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _getUserName(),
                        style: GoogleFonts.comicNeue(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${userData?['diasProgreso'] ?? 150} días de progreso',
                        style: GoogleFonts.comicNeue(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                // Información personal
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información Personal',
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nombre completo: ${_getUserName()}',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                      Text(
                        'Correo: ${currentUser?.email ?? 'No disponible'}',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                      Text(
                        'Fecha de nacimiento: ${userData?['fechaNacimiento'] ?? '15 de Octubre, 2003'}',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                      Text(
                        'Meta personal: ${userData?['metaPersonal'] ?? 'Vivir una vida más saludable'}',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Gráfico de progreso circular
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
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 10.0,
                        percent: 0.75,
                        center: Text(
                          "75%",
                          style: GoogleFonts.comicNeue(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        progressColor: Colors.purple[800],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Progreso general',
                        style: GoogleFonts.comicNeue(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Metas del usuario
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mis Metas',
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '✅ Mantener rutina diaria',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                      Text(
                        '✅ Ejercicio 3 veces por semana',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                      Text(
                        '✅ Meditación diaria',
                        style: GoogleFonts.comicNeue(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Configuraciones del usuario
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
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
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          'Perfil Privado',
                          style: GoogleFonts.comicNeue(color: Colors.black),
                        ),
                        value: true,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: Text(
                          'Mostrar Progreso',
                          style: GoogleFonts.comicNeue(color: Colors.black),
                        ),
                        value: true,
                        onChanged: (value) {},
                      ),
                      SwitchListTile(
                        title: Text(
                          'Notificaciones',
                          style: GoogleFonts.comicNeue(color: Colors.black),
                        ),
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Red de apoyo
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Red de Apoyo',
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: veryLightPurple,
                              backgroundImage: AssetImage('assets/images/friend${index + 1}.jpg'),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Información de cuenta de Firestore
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.4),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de la cuenta',
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('ID de usuario', currentUser?.uid ?? 'No disponible'),
                      _buildInfoRow(
                          'Fecha de registro',
                          userData?['fechaRegistro'] != null
                              ? _formatDate(userData!['fechaRegistro'].toDate())
                              : 'No disponible'
                      ),
                      _buildInfoRow(
                          'Último acceso',
                          userData?['ultimoAcceso'] != null
                              ? _formatDate(userData!['ultimoAcceso'].toDate())
                              : 'No disponible'
                      ),
                      _buildInfoRow(
                          'Proveedor',
                          userData?['provider'] ??
                              (currentUser?.providerData[0].providerId ?? 'No disponible')
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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
              currentIndex: 2,  // Índice actual para Perfil
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
                } else if (index == 1) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) => const InspiraScreen(),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.comicNeue(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}