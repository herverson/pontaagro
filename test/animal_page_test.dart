import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pontaagro/database/objectbox_database.dart';
import 'package:pontaagro/entities/animal.dart';
import 'package:pontaagro/entities/farm.dart';
import 'package:pontaagro/pages/animal_page.dart';
import 'package:pontaagro/services/animal_service.dart';
import 'package:pontaagro/stores/animal_store.dart';
import 'package:provider/provider.dart';

class MockObjectBoxDatabase extends Mock implements ObjectBoxDatabase {}

class MockAnimalService extends Mock implements AnimalService {}

void main() {
  late MockAnimalService mockAnimalService;

  setUp(() {
    mockAnimalService = MockAnimalService();
  });

  final animalsFromDataBase = [
    Animal(tag: 'Test 1'),
    Animal(tag: 'Test 2'),
    Animal(tag: 'Test 3'),
  ];
  final farm = Farm(name: 'Teste');

  void arrangeAnimalServiceReturns3Animals() {
    when(() => mockAnimalService.getAll()).thenAnswer(
      (_) async => animalsFromDataBase,
    );
  }

  void arrangeFarmServiceReturns3FarmsAfter2SecondWait() {
    when(() => mockAnimalService.getAll()).thenAnswer(
      (_) async {
        await Future.delayed(const Duration(seconds: 2));
        return animalsFromDataBase;
      },
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      title: 'Teste',
      home: ChangeNotifierProvider(
        create: (_) => AnimalStore(mockAnimalService),
        child: AnimalPage(
          farm: farm,
        ),
      ),
    );
  }

  testWidgets(
    "title is displayed",
    (WidgetTester tester) async {
      arrangeAnimalServiceReturns3Animals();
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text(farm.name), findsOneWidget);
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
    "animals are displayed",
    (WidgetTester tester) async {
      arrangeAnimalServiceReturns3Animals();

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.pump();

      for (final animal in animalsFromDataBase) {
        expect(find.text(animal.tag), findsOneWidget);
        expect(find.text(animal.tag), findsOneWidget);
      }
    },
  );
}
