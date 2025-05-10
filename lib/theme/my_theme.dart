import 'package:flutter/material.dart';

class MyTheme {
  static const Color primary = Colors.teal;
  static const Color darkGrayText = Color(
    0xFF303030,
  ); // Gris oscuro para textos

  static final ThemeData myTheme = ThemeData(
    primaryColor: primary,
    brightness: Brightness.light,
    fontFamily: 'Releway',
    appBarTheme: const AppBarTheme(
      color: primary,
      elevation: 10,
      foregroundColor: Colors.white,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primary),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white, // Color blanco para los íconos
      shape: CircleBorder(), // Forma circular para todos los FAB
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor:
            Colors.white, // Color del texto para los ElevatedButton
        backgroundColor: primary, // Mantiene el color de fondo actual
      ),
    ),
    // Configuración específica para los botones de navegación
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primary,
      unselectedItemColor: darkGrayText,
      // Asegura que el texto en los elementos del bottomNavigationBar sea gris oscuro
      unselectedLabelStyle: TextStyle(color: darkGrayText),
      selectedLabelStyle: TextStyle(
        color: darkGrayText,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
