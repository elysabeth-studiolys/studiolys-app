import 'package:flutter/material.dart';
import 'route_names.dart';

/// Configuration du routeur de l'application
class AppRouter {
  AppRouter._();

  /// Génère les routes de l'application
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.root:
      case RouteNames.home:
        // Sera géré par le bottom navigation
        return null;

      case RouteNames.statistics:
        // Sera géré par le bottom navigation
        return null;

      case RouteNames.todo:
        // Sera géré par le bottom navigation
        return null;

      case RouteNames.journal:
        // Sera géré par le bottom navigation
        return null;

      // TODO: Ajouter les autres routes au fur et à mesure
      // case RouteNames.addTodo:
      //   return MaterialPageRoute(
      //     builder: (_) => const AddTodoScreen(),
      //   );

      default:
        return _errorRoute(settings.name);
    }
  }

  /// Route d'erreur pour les routes non trouvées
  static Route<dynamic> _errorRoute(String? routeName) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Erreur'),
        ),
        body: Center(
          child: Text('Route non trouvée: $routeName'),
        ),
      ),
    );
  }

  /// Navigation helpers
  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.push<T>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget screen) {
    return Navigator.pushReplacement<T, TO>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
