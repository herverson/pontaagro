import 'package:objectbox/objectbox.dart';

@Entity()
class Animal {
  int id = 0;
  String tag;

  Animal({required this.tag});
}
