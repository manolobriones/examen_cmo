import 'package:flutter/material.dart';
import 'package:examen_cmo/screen/screen.dart';

/// Configuración centralizada de rutas de la aplicación
class AppRoutes {
  /// Ruta inicial de la aplicación que se muestra al iniciar
  static const initialRoute = 'login';

  /// Mapa de rutas principales de la aplicación
  static Map<String, Widget Function(BuildContext)> routes = {
    'login': (BuildContext context) => const LoginScreen(),
    'list': (BuildContext context) => const ProductListScreen(),
    'home': (BuildContext context) => const HomeScreen(),
    'category': (BuildContext context) => const CategoryScreen(),
    'provider': (BuildContext context) => const ProvidersListView(),
  };

  /// Manejador para rutas no definidas, muestra pantalla de error
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return const ErrorScreen();
      },
    );
  }
}
