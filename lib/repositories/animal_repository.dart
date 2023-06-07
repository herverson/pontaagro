import 'package:flutter/material.dart';

import '../database/objectbox.g.dart';
import '../database/objectbox_database.dart';
import '../entities/animal.dart';
import '../pages/animal_form_widget.dart';

class AnimalRepository extends ChangeNotifier {
  List<Animal> _animals = [];
  final List<AnimalFormWidget> _listForms = [
    AnimalFormWidget(animal: Animal(tag: ''))
  ];
  late final ObjectBoxDatabase _database;

  AnimalRepository(this._database);

  List<Animal> get animals => _animals;
  List<AnimalFormWidget> get listForms => _listForms;

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<Animal>();
  }

  save(String tag) async {
    final animal = Animal(tag: tag);
    final box = await getBox();
    box.put(animal);
    animals.add(animal);
    onClose();
  }

  update(Animal animal) async {
    final box = await getBox();
    box.put(animal);
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

  onAdd() {
    listForms.add(AnimalFormWidget(animal: Animal(tag: '')));
    notifyListeners();
  }

  onClose() {
    listForms.clear();
    listForms.add(AnimalFormWidget(animal: Animal(tag: '')));
    notifyListeners();
  }
}
