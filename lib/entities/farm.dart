import 'package:objectbox/objectbox.dart';

import 'animal.dart';

@Entity()
class Farm {
  int id = 0;
  String name;

  @Backlink()
  final animals = ToMany<Animal>();

  Farm({required this.name});
}
