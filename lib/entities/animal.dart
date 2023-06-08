import 'package:objectbox/objectbox.dart';

import 'farm.dart';

@Entity()
class Animal {
  int id = 0;
  String tag;

  final farm = ToOne<Farm>();

  Animal({required this.tag});
}
