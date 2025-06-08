import 'package:flutter/material.dart';
import '../screens/user_screen.dart';
import '../screens/home_screen.dart';

void openUserScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const UserScreen()),
  );
}

void handleBottomNavigationTap(int index, BuildContext context) {
  if (index == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } else if (index == 1) {
    // Ya estamos en la pantalla principal
  } else if (index == 2) {
    openUserScreen(context);
  }
}
