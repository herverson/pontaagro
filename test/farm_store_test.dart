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

  group('getFarms', () {
    final farmsFromDataBase = [
      Farm(name: 'Test 1'),
      Farm(name: 'Test 2'),
      Farm(name: 'Test 3'),
    ];

    void arrangeFarmServiceReturns3Farms() {
      when(() => mockFarmService.getAll()).thenAnswer(
        (_) async => farmsFromDataBase,
      );
    }

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
