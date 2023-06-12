import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/animal.dart';
import 'package:pontaagro/entities/farm.dart';
import 'package:pontaagro/services/animal_service.dart';
import 'package:pontaagro/stores/animal_store.dart';

class MockObjectBoxDatabase extends Mock implements ObjectBoxDatabase {}

class MockAnimalService extends Mock implements AnimalService {}

void main() {
  late AnimalStore sut;
  late MockAnimalService mockAnimalService;

  setUp(() {
    mockAnimalService = MockAnimalService();
    sut = AnimalStore(mockAnimalService);
  });

  test(
    "initial values are correct",
    () {
      expect(sut.animals, []);
      expect(sut.isLoading, false);
    },
  );

  group('CRUDAnimals', () {
    final animalsFromDataBase = [
      Animal(tag: 'Test 1'),
      Animal(tag: 'Test 2'),
      Animal(tag: 'Test 3'),
    ];
    final animal = Animal(tag: 'Test 1');
    final farm = Farm(name: 'Test 1');

    void arrangeAnimalServiceReturns3Animals() {
      when(() => mockAnimalService.getAll()).thenAnswer(
        (_) async => animalsFromDataBase,
      );
    }

    void saveAnimal() {
      when(() => mockAnimalService.save(animal.tag, farm)).thenAnswer(
        (_) async => animal,
      );
    }

    void updateAnimal() {
      when(() => mockAnimalService.update(animal)).thenAnswer(
        (_) async => (_),
      );
    }

    void removeAnimal() {
      when(() => mockAnimalService.remove(animal)).thenAnswer(
        (_) async => (_),
      );
    }

    test(
      "save animal using the AnimalService",
      () async {
        saveAnimal();
        await sut.save('Test 1', farm);
        verify(() => mockAnimalService.save(animal.tag, farm)).called(1);
      },
    );

    test(
      """save animal,
      set animal to the ones from the service,
      indicates that data is equal""",
      () async {
        saveAnimal();
        final future = sut.save(animal.tag, farm);
        await future;
        expect(sut.animals.length, 1);
        expect(sut.animals[0], animal);
      },
    );

    test(
      "update animal using the AnimalService",
      () async {
        updateAnimal();
        await sut.update(animal);
        verify(() => mockAnimalService.update(animal)).called(1);
      },
    );

    test(
      "remove animal using the AnimalService",
      () async {
        removeAnimal();
        await sut.remove(animal);
        verify(() => mockAnimalService.remove(animal)).called(1);
      },
    );

    test(
      """remove animal,
      set animal to the ones from the service,
      indicates that data is equal""",
      () async {
        removeAnimal();
        final future = sut.remove(animal);
        await future;
        expect(sut.animals.length, 0);
        expect(sut.animals, isEmpty);
      },
    );

    test(
      "gets Animals using the AnimalService",
      () async {
        arrangeAnimalServiceReturns3Animals();
        await sut.getAll();
        verify(() => mockAnimalService.getAll()).called(1);
      },
    );
    test(
      """indicates loading of data,
      sets animals to the ones from the service,
      indicates that data is not being loaded anymore""",
      () async {
        arrangeAnimalServiceReturns3Animals();
        final future = sut.getAll();
        expect(sut.isLoading, true);
        await future;
        expect(sut.animals, animalsFromDataBase);
        expect(sut.isLoading, false);
      },
    );
  });
}
