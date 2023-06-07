import 'package:flutter/material.dart';
import 'package:pontaagro/pages/add_animal_page.dart';

import '../pages/animal_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/': (_) => const AnimalPage(),
    '/animals/add': (_) => const AddAnimalPage(),
  };

  static String initial = '/';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState to = Routes.navigatorKey!.currentState!;
}
