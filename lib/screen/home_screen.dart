import 'package:flutter/material.dart';

/// Pantalla principal que muestra los botones de navegación a las diferentes secciones
/// de la aplicación: Productos, Categorías y Proveedores.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pantalla de Inicio')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botón de navegación a la pantalla de productos
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'list');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Ver Productos', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Botón de navegación a la pantalla de categorías
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'category');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, color: Colors.white),
                  SizedBox(width: 10),
                  Text('Ver Categorías', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Botón de navegación a la pantalla de proveedores
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, 'provider');
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.business, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Ver Proveedores',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
