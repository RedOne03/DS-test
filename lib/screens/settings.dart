import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Ajustes',
          style: GoogleFonts.comicNeue(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: CupertinoColors.lightBackgroundGray.withOpacity(0.7),
        elevation: 0,
        automaticallyImplyLeading: true, // Esto habilita la flecha de retorno
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
            children: [
              _buildSettingsItem(
                context,
                icon: Icons.account_circle,
                title: 'Cuenta',
                subtitle: 'Gestiona tu información personal y preferencias',
              ),
              _buildSettingsItem(
                context,
                icon: Icons.notifications,
                title: 'Notificaciones',
                subtitle: 'Configura las alertas y recordatorios de hábitos',
              ),
              _buildSettingsItem(
                context,
                icon: Icons.language,
                title: 'Idioma',
                subtitle: 'Cambia el idioma de la aplicación',
              ),
              _buildSettingsItem(
                context,
                icon: Icons.help_center,
                title: 'Centro de ayuda',
                subtitle: 'Encuentra respuestas a tus preguntas frecuentes',
              ),
              _buildSettingsItem(
                context,
                icon: Icons.privacy_tip,
                title: 'Política de privacidad',
                subtitle: 'Consulta cómo protegemos tus datos',
              ),
              _buildSettingsItem(
                context,
                icon: Icons.description,
                title: 'Condiciones del servicio',
                subtitle: 'Revisa los términos y condiciones de uso',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(BuildContext context, {required IconData icon, required String title, required String subtitle}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.white.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.purple[800]),
        title: Text(
          title,
          style: GoogleFonts.comicNeue(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.comicNeue(
            fontSize: 15,
            color: Colors.grey[800],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: () {
          // Acciones para cada ítem
        },
      ),
    );
  }
}