import 'package:examen_cmo/providers/category_provider.dart';
import 'package:examen_cmo/providers/providers_provider.dart';
import 'package:examen_cmo/routes/app_routes.dart';
import 'package:examen_cmo/services/services.dart';
import 'package:examen_cmo/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Punto de entrada principal de la aplicación
void main() => runApp(AppState());

/// Configuración de estado global de la aplicación utilizando Provider
/// Inicializa y proporciona todos los servicios necesarios a la aplicación
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProvidersProvider()),
      ],
      child: const MainApp(),
    );
  }
}

/// Widget principal que configura la aplicación
/// Define rutas, tema y configuraciones generales
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Examen CMO',
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      theme: MyTheme.myTheme,
    );
  }
}
