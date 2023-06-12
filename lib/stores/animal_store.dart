import 'package:flutter/material.dart';

import '../entities/animal.dart';
import '../entities/farm.dart';
import '../pages/animal_form_widget.dart';
import '../services/animal_service.dart';

class AnimalStore extends ChangeNotifier {
  List<Animal> _animals = [];
  final List<AnimalFormWidget> _listForms = [
    AnimalFormWidget(animal: Animal(tag: ''))
  ];
  Farm farm = Farm(name: '');
  late final AnimalService _animalService;

  AnimalStore(
    this._animalService,
  );

  List<Animal> get animals => _animals;

  List<AnimalFormWidget> get listForms => _listForms;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> save(String tag, Farm farm) async {
    final animal = await _animalService.save(tag, farm);
    animals.add(animal);
    onClose();
  }

  Future<void> update(Animal animal) async {
    await _animalService.update(animal);
    notifyListeners();
  }

  Future<void> getAll() async {
    _isLoading = true;
    notifyListeners();
    _animals = await _animalService.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> remove(Animal animal) async {
    _animalService.remove(animal);
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
