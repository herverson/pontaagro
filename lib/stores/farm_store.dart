import 'package:flutter/material.dart';

import '../entities/farm.dart';
import '../services/farm_service.dart';

class FarmStore extends ChangeNotifier {
  List<Farm> _farms = [];
  late final FarmService _farmService;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  FarmStore(this._farmService);

  List<Farm> get farms => _farms;

  Future<void> save(String name) async {
    final farm = await _farmService.save(name);
    farms.add(farm);
    notifyListeners();
  }

  Future<void> update(Farm farm) async {
    await _farmService.update(farm);
    notifyListeners();
  }

  Future<void> getAll() async {
    _isLoading = true;
    notifyListeners();
    _farms = await _farmService.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> remove(Farm farm) async {
    _farmService.remove(farm);
    farms.remove(farm);
    notifyListeners();
  }
}
