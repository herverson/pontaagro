import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/animal.dart';
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

  group('getAnimals', () {
    final animalsFromDataBase = [
      Animal(tag: 'Test 1'),
      Animal(tag: 'Test 2'),
      Animal(tag: 'Test 3'),
    ];

    void arrangeAnimalServiceReturns3Animals() {
      when(() => mockAnimalService.getAll()).thenAnswer(
        (_) async => animalsFromDataBase,
      );
    }

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
      sets farms to the ones from the service,
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
