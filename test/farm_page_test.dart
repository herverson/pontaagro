import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/farm.dart';
import 'package:pontaagro/pages/farm_page.dart';
import 'package:pontaagro/services/farm_service.dart';
import 'package:pontaagro/stores/farm_store.dart';
import 'package:provider/provider.dart';

class MockObjectBoxDatabase extends Mock implements ObjectBoxDatabase {}

class MockFarmService extends Mock implements FarmService {}

void main() {
  late MockFarmService mockFarmService;

  setUp(() {
    mockFarmService = MockFarmService();
  });

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

  void arrangeFarmServiceReturns3FarmsAfter2SecondWait() {
    when(() => mockFarmService.getAll()).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        return farmsFromDataBase;
      },
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Pontaagro',
      home: ChangeNotifierProvider(
        create: (_) => FarmStore(mockFarmService),
        child: const FarmPage(),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      arrangeFarmServiceReturns3Farms();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Pontaagro'), findsOneWidget);
    },
  );

  testWidgets(
    "loading indicator is displayed while waiting for farms",
    (WidgetTester tester) async {
      arrangeFarmServiceReturns3FarmsAfter2SecondWait();

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byKey(const Key('progress-indicator')), findsOneWidget);

      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    "farms are displayed",
    (WidgetTester tester) async {
      arrangeFarmServiceReturns3Farms();

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      for (final farm in farmsFromDataBase) {
        expect(find.text(farm.name), findsOneWidget);
        expect(find.text(farm.name), findsOneWidget);
      }
    },
  );
}
