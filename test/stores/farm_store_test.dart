import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/farm.dart';
import 'package:pontaagro/services/farm_service.dart';
import 'package:pontaagro/stores/farm_store.dart';

class MockObjectBoxDatabase extends Mock implements ObjectBoxDatabase {}

class MockFarmService extends Mock implements FarmService {}

void main() {
  late FarmStore sut;
  late MockFarmService mockFarmService;

  setUp(() {
    mockFarmService = MockFarmService();
    sut = FarmStore(mockFarmService);
  });

  test(
    "initial values are correct",
    () {
      expect(sut.farms, []);
      expect(sut.isLoading, false);
    },
  );

  group('CRUDFarms', () {
    final farmsFromDataBase = [
      Farm(name: 'Test 1'),
      Farm(name: 'Test 2'),
      Farm(name: 'Test 3'),
    ];
    final farm = Farm(name: 'Test 1');

    void arrangeFarmServiceReturns3Farms() {
      when(() => mockFarmService.getAll()).thenAnswer(
        (_) async => farmsFromDataBase,
      );
    }

    void saveFarm() {
      when(() => mockFarmService.save(farm.name)).thenAnswer(
        (_) async => farm,
      );
    }

    void updateFarm() {
      when(() => mockFarmService.update(farm)).thenAnswer(
        (_) async => (_),
      );
    }

    void removeFarm() {
      when(() => mockFarmService.remove(farm)).thenAnswer(
        (_) async => (_),
      );
    }

    test(
      "save farm using the FarmService",
      () async {
        saveFarm();
        await sut.save(farm.name);
        verify(() => mockFarmService.save(farm.name)).called(1);
      },
    );

    test(
      """save farm,
      set farm to the ones from the service,
      indicates that data is equal""",
      () async {
        saveFarm();
        final future = sut.save(farm.name);
        await future;
        expect(sut.farms.length, 1);
        expect(sut.farms[0], farm);
      },
    );

    test(
      "update farm using the FarmService",
      () async {
        updateFarm();
        await sut.update(farm);
        verify(() => mockFarmService.update(farm)).called(1);
      },
    );

    test(
      "remove farm using the FarmService",
      () async {
        removeFarm();
        await sut.remove(farm);
        verify(() => mockFarmService.remove(farm)).called(1);
      },
    );

    test(
      """remove farm,
      set farm to the ones from the service,
      indicates that data is equal""",
      () async {
        removeFarm();
        final future = sut.remove(farm);
        await future;
        expect(sut.farms.length, 0);
        expect(sut.farms, isEmpty);
      },
    );

    test(
      "gets Farms using the FarmService",
      () async {
        arrangeFarmServiceReturns3Farms();
        await sut.getAll();
        verify(() => mockFarmService.getAll()).called(1);
      },
    );

    test(
      """indicates loading of data,
      sets farms to the ones from the service,
      indicates that data is not being loaded anymore""",
      () async {
        arrangeFarmServiceReturns3Farms();
        final future = sut.getAll();
        expect(sut.isLoading, true);
        await future;
        expect(sut.farms, farmsFromDataBase);
        expect(sut.isLoading, false);
      },
    );
  });
}
