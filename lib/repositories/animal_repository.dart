import 'package:flutter/material.dart';

import '../database/objectbox.g.dart';
import '../database/objectbox_database.dart';
import '../entities/animal.dart';

class AnimalRepository extends ChangeNotifier {
  List<Animal> _animals = [];
  late final ObjectBoxDatabase _database;

  AnimalRepository(this._database);

  List<Animal> get animals => _animals;

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<Animal>();
  }

  save(String tag) async {
    final animal = Animal(tag: tag);
    final box = await getBox();
    box.put(animal);
    animals.add(animal);
    notifyListeners();
  }

  update(Animal animal) async {
    final box = await getBox();
    box.put(animal);
    animals.add(animal);
    notifyListeners();
  }

  getAll() async {
    final box = await getBox();
    _animals = box.getAll() as List<Animal>;
    notifyListeners();
  }

  remove(Animal animal) async {
    final box = await getBox();
    box.remove(animal.id);
    animals.remove(animal);
    notifyListeners();
  }
}
