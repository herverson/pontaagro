import '../database/objectbox.g.dart';
import '../database/objectbox_database.dart';
import '../entities/farm.dart';

class FarmService {
  late final ObjectBoxDatabase _database;
  FarmService(this._database);

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<Farm>();
  }

  Future<List<Farm>> getAll() async {
    final box = await getBox();
    return box.getAll() as List<Farm>;
  }

  Future<Farm> save(String name) async {
    final farm = Farm(name: name);
    final box = await getBox();
    box.put(farm);
    return farm;
  }

  Future<void> update(Farm farm) async {
    final box = await getBox();
    box.put(farm);
  }

  Future<void> remove(Farm farm) async {
    final box = await getBox();
    box.remove(farm.id);
  }
}
