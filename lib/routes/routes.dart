import 'package:flutter/material.dart';

import '../pages/animal_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list =
      <String, WidgetBuilder>{
    '/animals/list': (_) => const AnimalPage(),
  };

  static String initial = '/animals/list';

  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState to = Routes.navigatorKey!.currentState!;
}
