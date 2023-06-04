import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'database/objectbox_database.dart';
import 'repositories/animal_repository.dart';

final providers = <SingleChildWidget>[
  Provider<ObjectBoxDatabase>(
    create: (context) => ObjectBoxDatabase(),
  ),
  ChangeNotifierProvider<AnimalRepository>(
    create: (context) => AnimalRepository(
      context.read(),
    ),
  ),
];
