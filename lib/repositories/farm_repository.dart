import 'package:flutter/material.dart';

import '../database/objectbox.g.dart';
import '../database/objectbox_database.dart';
import '../entities/farm.dart';

class FarmRepository extends ChangeNotifier {
  List<Farm> _farms = [];
  late final ObjectBoxDatabase _database;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _length = 0;

  int get length => _length;

  FarmRepository(this._database);

  List<Farm> get farms => _farms;

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<Farm>();
  }

  save(String name) async {
    final farm = Farm(name: name);
    final box = await getBox();
    box.put(farm);
    farms.add(farm);
    notifyListeners();
  }

  update(Farm farm) async {
    final box = await getBox();
    box.put(farm);
    notifyListeners();
  }

  getAll() async {
    _isLoading = true;
    notifyListeners();
    final box = await getBox();
    _farms = box.getAll() as List<Farm>;
    _isLoading = false;
    notifyListeners();
  }

  remove(Farm farm) async {
    final box = await getBox();
    box.remove(farm.id);
    farms.remove(farm);
    notifyListeners();
  }
}
