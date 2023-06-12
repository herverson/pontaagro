import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'database/objectbox_database.dart';
import 'services/animal_service.dart';
import 'services/farm_service.dart';
import 'stores/animal_store.dart';
import 'stores/farm_store.dart';

final providers = <SingleChildWidget>[
  Provider<ObjectBoxDatabase>(
    create: (context) => ObjectBoxDatabase(),
  ),
  Provider<FarmService>(
    create: (context) => FarmService(
      context.read(),
    ),
  ),
  Provider<AnimalService>(
    create: (context) => AnimalService(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<AnimalStore>(
    create: (context) => AnimalStore(
      context.read(),
    ),
  ),
  ChangeNotifierProvider<FarmStore>(
    create: (context) => FarmStore(context.read()),
  ),
];
