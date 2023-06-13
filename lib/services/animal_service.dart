import '../database/objectbox.g.dart';
import '../database/objectbox_database.dart';
import '../entities/animal.dart';
import '../entities/farm.dart';

class AnimalService {
  late final ObjectBoxDatabase _database;
  AnimalService(this._database);

  Future<Box> getBox() async {
    final store = await _database.getStore();
    return store.box<Animal>();
  }

  Future<List<Animal>> getAll() async {
    final box = await getBox();
    return box.getAll() as List<Animal>;
  }

  Future<Animal> save(String tag, Farm farm) async {
    final animal = Animal(tag: tag);
    animal.farm.target = farm;
    final box = await getBox();
    box.put(animal);
    return animal;
  }

  Future<void> update(Animal animal) async {
    final box = await getBox();
    box.put(animal);
  }

  Future<void> remove(Animal animal) async {
    final box = await getBox();
    box.remove(animal.id);
  }
}
